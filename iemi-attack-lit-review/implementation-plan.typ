#set page(header: [_Steven Thompson_
  #h(1fr)
  Physical CPS Attack Platform Implementation Plan])
#show link: underline

= End-of-rotation goals:

+ Create a reproducible environment for simulating physical drone attacks using
  MATLAB/Simulink
+ Attempt to model a drone takeover attack through IMU spoofing with EMI signal
  injection
+ Systematize and begin to integrate other physical attack mechanisms (vision,
  LiDAR, acoustic signals)

== Week 1 - Environment Setup & Sensor Modeling (09/17-09/23)

- Goals:
  - Install, setup, and verify functionality of MATLAB/Simulink modules
    - Tools:
      - UAV Toolbox
      - Quadcopter drone model
      - Control System Toolbox

  - Initially, create a minimal quadcopter environment and run baseline simulations
    without noise or disturbances

  - Then, add IMU and GPS models and integrate closed-loop control with EKF state
    estimation
    - IMU sensor model ideas:
      - configurable bias, scale factor, noise, and sampling rate
    - GPS sensor model ideas:
      - Configurable position, velocity, noise, and latency

- Deliverables:
  - By the end of this week I plan to have a working MATLAB/Simulink environment
  - To verify functionality, I want to capture localization metrics like attitude
    and altitude error plots during these simulations

== Week 2 - RF Front-End & Attacker API (09/24-09/30)

- Goals:
  - Model full RF transceiver for EMI attacks
    - components: antenna, low-noise amplifier, mixer, filter
  - Define attacker parameter inputs for IMU and GPS sensors
    - parameter ideas: transmission power, distance, antenna gain, waveform type,
      duration
  - Tools:
    - Communications toolbox
    - Simscape electrical
    - Antenna toolbox

- Deliverables:
  - A configurable RF front-end for EMI attacks

== Week 3 - Simulate IMU and GPS Spoofing with IEMI (10/01-10/07)

- Goals:
  - Deliver results from an end-to-end RF simulation where attacker parameters
    produce realistic GPS/IMU spoofing outcomes
  - Possible attack scenarios:
    - Vary transmission power, distance, waveform, antenna orientations
    - Attacks while the drone is flying

- Deliverables:
  - Attack success metrics from running the proposed simulations
    - GPS spoofing success if vehicle position error > a predefined threshold
    - IMU spoofing success if the IEMI induces instability with the drone

== Week 4 - Developing Other Physical Attack Libraries (10/08-10/15)

- Goals:
  - Extend the physical attack API to include possible vision, LiDAR, and acoustic
    attacks
  - Vision:
    - Generate synthetic scenes and create an injection API that can replace or insert
      adversarial frames at given times
  - LiDAR:
    - Implement spoofed range readings or adversarial point cloud injection to induce
      obstacles or false range-to-ground readings
  - Acoustic:
    - Map simulated vibrational input to an induced IMU signal based on its resonant
      frequency
  - Tools:
    - UAV Toolbox
    - Computer Vision Toolbox

- Deliverables:

  - API's for modeling possible attacks on a drone's vision and LiDAR systems. And
    an API for attacking IMU sensors with acoustic signals.

== Week 5 - Large-Scale Testing and Documentation (10/16-10/22)

- Goals:
  - Run large-scale tests incorporating flight dynamics and attack
    detection/mitigations
  - finalize environment documentation

- Deliverables:
  - Fully documented and reproducible simulation environment for physical attacks on
    drones
  - A final report detailing attack methods, required transmission powers and
    distances, and attack detection performance

=== Helpful references for myself
- #link("https://www.mathworks.com/discovery/drone-simulation.html")
- #link(
    "https://www.mathworks.com/videos/series/drone-simulation-and-control.html",
  )
- #link("https://www.mathworks.com/help/sps/ug/quadcopter-drone.html")
- #link(
    "https://www.mathworks.com/videos/programming-drones-with-simulink-1513024653640.html",
  )
- #link("https://www.mathworks.com/products/uav.html")
- #link("https://www.mathworks.com/help/uav/ug/uav-package-delivery.html")
- #link("https://www.mathworks.com/products/antenna.html")
- #link(
    "https://www.mathworks.com/help/nav/ug/end-to-end-gps-legacy-navigation-receiver-using-ca-code.html",
  )
- #link(
    "https://www.nwengineeringllc.com/article/rf-front-end-design-specifications-and-component-selection.php",
  )
