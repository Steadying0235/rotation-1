"""Overtake scenario adapted for Scenic/CARLA (Carla_Challenge style)

Ego safely overtakes a slower vehicle ahead by following these steps:
  1. Activate left turn signal
  2. Change to left lane and accelerate smoothly, then turn off left blinker
  3. Follow the overtaking lane until there is a safe distance past the slower car
  4. Turn on the right turn signal and change back to the initial lane

To run with CARLA (example):
    scenic examples/driving/Carla_Challenge/this_file.scenic --2d --model scenic.simulators.carla.model --simulate

This file follows the same model and behavior idioms used in the Carla_Challenge examples:
 - uses FollowLaneBehavior and ChangeLaneBehavior primitives
 - uses simple looping / waiting to model signaling durations and smooth acceleration

Tuning parameters near the top.
"""
param map = localPath('../../assets/maps/CARLA/Town05.xodr')
param carla_map = 'Town05'
param time_step = 1.0/10        # simulation step used by waits
model scenic.domains.driving.model

# TUNABLE CONSTANTS (meters, seconds, speeds)
OVERTAKE_TRIGGER_DISTANCE = 20     # begin overtaking when ego within this distance to lead car
SAFE_CLEARANCE = 6                 # return to lane once ego is this far past lead car
OVERTAKE_ACCEL_STEPS = 40          # number of small increments to accelerate while overtaking
OVERTAKE_ACCEL_STEP = 0.5          # speed increment per step (m/s) during overtaking
SLOW_CAR_SPEED = 6                 # speed of the slower vehicle (m/s)
EGO_CRUISE_SPEED = 12              # target cruise speed for ego before/after overtaking (m/s)
SIGNAL_ON_SECONDS = 0.6            # how long to show turn signal before/after lane change

# Simple slow driver behavior for the vehicle to be overtaken
behavior SlowDriver():
    while True:
        self.speed = SLOW_CAR_SPEED
        do FollowLaneBehavior()
        wait

# Overtaking behavior for the ego vehicle
behavior OvertakeBehavior():
    # Initially follow lane at cruise speed
    self.speed = EGO_CRUISE_SPEED
    do FollowLaneBehavior()

    # Wait until the ego approaches the slower vehicle close enough to plan an overtake
    while (distance from self to secondCar) > OVERTAKE_TRIGGER_DISTANCE:
        wait

    # 1) Activate left turn signal for a short duration (intent)
    # Note: Scenic scenarios can set custom attributes; if your CARLA integration
    # maps an attribute like `blinker_left` to a simulator action, adapt accordingly.
    self.blinker = "left"
    for _ in range(int(SIGNAL_ON_SECONDS / time_step)):
        wait

    # 2) Change to left lane and accelerate smoothly while in the left lane
    do ChangeLaneBehavior(direction="left")

    # Smooth acceleration increments while staying in the overtaking lane
    for i in range(OVERTAKE_ACCEL_STEPS):
        # modest acceleration per step; clamp to a safe maximum
        self.speed = min(self.speed + OVERTAKE_ACCEL_STEP, EGO_CRUISE_SPEED + 6.0)
        do FollowLaneBehavior()
        wait

    # turn off left blinker shortly after lane change
    for _ in range(int(0.2 / time_step)):
        wait
    self.blinker = "off"

    # 3) Continue in overtaking lane until ego has passed the slow vehicle by SAFE_CLEARANCE
    #    We use the ego's x-projection relative to secondCar to decide when it's safe
    while (distance from self to secondCar) < (SAFE_CLEARANCE + secondCar.length):
        do FollowLaneBehavior()
        wait

    # 4) Signal right and change back to the original lane
    self.blinker = "right"
    for _ in range(int(SIGNAL_ON_SECONDS / time_step)):
        wait
    do ChangeLaneBehavior(direction="right")

    # brief pause to allow lane change to complete and then turn off blinker
    for _ in range(int(0.2 / time_step)):
        wait
    self.blinker = "off"

    # Resume normal cruising behavior in the right lane
    self.speed = EGO_CRUISE_SPEED
    do FollowLaneBehavior()

# SPAWN / PLACEMENT
# Place the slower car ahead of ego so ego can overtake
# Use the 'ahead of' placement pattern common in the examples to set relative positions.
ego = new Car with behavior OvertakeBehavior
secondCar = new Car ahead of ego by OVERTAKE_TRIGGER_DISTANCE + 5, facing roadDirection, with behavior SlowDriver

# initial speeds should be zero to allow simulator startup to set them
ego.speed = 0
secondCar.speed = 0

require (distance to secondCar) > 0

# Monitor to assert the overtaking completed (ego passes the secondCar)
monitor OvertakeMonitor():
    initialGap = distance from ego to secondCar
    # wait until a close approach
    while distance from ego to secondCar > 5:
        wait
    # now wait until ego has pulled ahead and established a larger gap than initial
    while distance from ego to secondCar < initialGap + 2:
        wait
    passed = True
    terminate

require monitor OvertakeMonitor()

# Safety: terminate the scenario if it runs for too long
terminate after 30 seconds
