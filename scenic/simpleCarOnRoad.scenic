# Simple scenario: Place a car on a road using Scenic

param map = localPath('../../assets/maps/CARLA/SimpleFlatRoad.xodr')
#param sumo_map = localPath('../../assets/maps/CARLA/Town05.net.xml')
#param carla_map = 'Town05'
param time_step = 1.0/10

model scenic.domains.driving.model

ego = new Car with behavior DriveAvoidingCollisions(avoidance_threshold=5)



behavior AccelerateThenVeerIntoEgo():
    # Accelerate to catch up to ego
    while (distance from self to ego) > 10:
        self.speed = min(self.speed + 2.0, 20)   # Accelerate up to 20 units, faster
        do FollowLaneBehavior()
        wait
    # When close, try to veer into ego
    do ChangeLaneBehavior(direction="towards", target=ego)

# Add a second car behind ego
secondSpot = new OrientedPoint behind ego by 15
secondCar = new Car at secondSpot, facing roadDirection, with behavior AccelerateThenVeerIntoEgo

require (distance to secondCar) > 0

terminate after 15 seconds
