Fs = 100;

wayponts = [1 1 1; 3 1 1; 3 0 0; 0 0 0];
t = [1; 10; 20; 30];

traj = waypointTrajectory(wayponts, t, "SampleRate", Fs);
[posVeh, orientVeh, velVeh, accVeh, angvelVeh] = lookupPose(traj, ...
    t(1):1/Fs:t(end));

imu = imuSensor("accel-gyro-mag", "SampleRate", Fs);
mountedIMU = imuSensor("accel-gyro-mag", "SampleRate", Fs);

posVeh2IMU = [2.4 0.5 0.4];
orientVeh2IMU = quaternion([0 0 90], "eulerd", "ZYX", "frame");

helperPlotIMU(posVeh(1,:), orientVeh(1,:), posVeh2IMU, orientVeh2IMU);