# Overtake scenario: ego overtakes a slower car and returns to lane

param map = localPath('../../assets/maps/CARLA/Town05.xodr')
param carla_map = 'Town05'
param time_step = 1.0/10

model scenic.domains.driving.model

# Slow driver behavior (lead car)
behavior SlowDriver():
    while True:
        self.speed = 6
        do FollowLaneBehavior()
        wait

# Overtaking behavior (ego)
behavior OvertakeBehavior():
    do FollowLaneBehavior()
    while (distance from self to secondCar) > 20:
        wait
    do ChangeLaneBehavior(direction="left")
    for i in range(40):
        self.speed = min(self.speed + 5.0, 32)
        do FollowLaneBehavior()
        wait
    do ChangeLaneBehavior(direction="right")
    do FollowLaneBehavior()

# Spawn ego and slower car ahead of it
ego = new Car with behavior OvertakeBehavior
secondCar = new Car ahead of ego by 20, facing roadDirection, with behavior SlowDriver

# initial speeds (must be zero for simulator startup)
ego.speed = 0
secondCar.speed = 0

require (distance to secondCar) > 0

monitor OvertakeMonitor():
    initialGap = distance from ego to secondCar
    while distance from ego to secondCar > 5:
        wait
    while distance from ego to secondCar < initialGap + 2:
        wait
    passed = True
    terminate

require monitor OvertakeMonitor()

terminate after 20 seconds