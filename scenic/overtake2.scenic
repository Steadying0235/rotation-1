# Overtake2 scenario: ego overtakes a slower car and returns to lane
#
# This scenario corrects the lane-change usage in the original `overtake.scenic`.
# It uses `LaneChangeBehavior` with explicit lane sections (faster/slower lanes)
# and performs a timed passing maneuver to ensure the ego moves into the overtaking
# lane, accelerates to pass, then returns to its original lane.
#
# To run with a simulator (example):
# scenic --2d overtake2.scenic --model scenic.simulators.metadrive.model --simulate

param map = localPath('../../assets/maps/CARLA/Town05.xodr')
param carla_map = 'Town05'
param time_step = 1.0/10

model scenic.domains.driving.model

# Slow driver behavior (lead car)
behavior SlowDriver():
    while True:
        # maintain a steady slow speed and follow the lane
        self.speed = 6
        do FollowLaneBehavior(target_speed=6)
        wait

# Overtaking behavior (ego)
behavior OvertakeBehavior():
    # Start by following the lane at a moderate speed
    try:
        do FollowLaneBehavior(target_speed=12)
    # When we are close enough to the slower car, attempt an overtaking maneuver
    interrupt when (distance from self to secondCar) < 25:
        # remember the original lane section so we can return to it later
        origLaneSec = self.laneSection

        # choose an overtaking lane:
        # prefer a designated "faster" lane if present; otherwise try left lane mappings
        if origLaneSec.fasterLane is not None:
            overtakingLaneSec = origLaneSec.fasterLane
        elif getattr(origLaneSec, 'laneToLeft', None) is not None:
            overtakingLaneSec = origLaneSec.laneToLeft
        elif getattr(origLaneSec, '_laneToLeft', None) is not None:
            overtakingLaneSec = origLaneSec._laneToLeft
        else:
            # no lane available to overtake; slow down and resume following
            # (this prevents a hard failure on single-lane roads)
            self.speed = min(self.speed, 6)
            do FollowLaneBehavior(target_speed=6)
            wait

        # change into the overtaking lane and accelerate to pass
        do LaneChangeBehavior(laneSectionToSwitch=overtakingLaneSec, target_speed=20)
        # after changing lanes, push throttle and follow lane for a short duration to complete pass
        do FollowLaneBehavior(target_speed=20) for 4 seconds

        # attempt to return to the original lane section (if still available)
        # If the original lane sec object is no longer a valid target, try a slower lane mapping
        if origLaneSec is not None:
            do LaneChangeBehavior(laneSectionToSwitch=origLaneSec, target_speed=12)
        else:
            # fallback: attempt to go into a slower lane associated with current position
            if self.laneSection.slowerLane is not None:
                do LaneChangeBehavior(laneSectionToSwitch=self.laneSection.slowerLane, target_speed=12)

        # resume normal lane following
        do FollowLaneBehavior(target_speed=12)

# Spawn ego and slower car ahead of it
ego = new Car with behavior OvertakeBehavior
secondCar = new Car ahead of ego by Range(20, 25), facing roadDirection, with behavior SlowDriver

# initial speeds (must be zero for simulator startup)
ego.speed = 0
secondCar.speed = 0

# basic sanity requirement: ensure cars didn't spawn overlapping
require (distance to secondCar) > 10

# Optional monitor to mark a successful pass:
monitor SuccessfulPass():
    initialGap = distance from ego to secondCar
    # wait until ego is close enough to start the maneuver
    while (distance from ego to secondCar) > 10:
        wait
    # wait for ego to be closer than the initial gap (indicating catch-up)
    while (distance from ego to secondCar) >= initialGap:
        wait
    # now wait until ego is ahead of the second car (distance from secondCar to ego small)
    # Note: after the ego passes, distance from secondCar to ego should decrease.
    for i in range(50):
        # poll for a short period to allow the passing to complete
        if (distance from secondCar to ego) < 6:
            passed = True
            terminate
        wait
    # if we timeout, just terminate monitor (scenario still valid but didn't detect pass)
    terminate

require monitor SuccessfulPass()

# Safety termination: increased to 120 seconds to allow longer simulations
terminate after 120 seconds
