#import "@preview/charged-ieee:0.1.4": ieee

#show: ieee.with(
  title: [Towards Developing a Feasible End-to-End IEMI Attack Platform for Robotic
    Vehicles], authors: (
    (
      name: "Steven Thompson", department: [Department of Computer Science & Engineering], organization: [Washington University in St. Louis], location: [St. Louis, MO], email: "steven.t@wustl.edu",
    ),
  ), index-terms: ("IEMI attacks", "cyber-physical system security"), bibliography: bibliography("refs.bib", style: "ieee"),
)

#set heading(numbering: "1.")

= Background and Motivation

== Robotic Vehicle Security

*Robotic Vehicles (RVs):* Robotic vehicles like autonomous cars, delivery
robots, and drones, are becoming increasingly integrated in human society. These
systems depend on the cohesive integration of sensors, perception, planning, and
control to operate safely in dynamic environments. Sensor suites for these
vehicles typically include LiDAR and radar for ranging, cameras for scene
understanding, GNSS and IMUs for localization, and numerous other sensors for
health and state estimation. Since these vehicles act on sensed information to
make real-time and safety-critical decisions, any disturbance of the physical
sensing system can directly lead to hazardous outcomes such as collisions, loss
of control, or mission failure @xiaoSoKUnderstandingFundamentals2025.

Therefore, attacks against robotic vehicles differ from typical cyber attacks.
With these systems, an adversary does not need to compromise software or
computer networks to cause harm. Instead, an attacker can manipulate the
physical sensing layer either by spoofing or jamming signals or by injecting
voltages or currents via conducted or radiated EMI
@xiaoSoKUnderstandingFundamentals2025 @kimSystematicStudyPhysical2024.
Furthermore, because many sensing systems were optimized for cost and
performance rather than adversarial robustness @kimSystematicStudyPhysical2024,
attackers with access only to modest resources can sometimes produce substantial
effects by targeting known weak points @szakalyAssaultBatteryEvaluating2024.

*Intentional Electromagnetic Interference (IEMI):* In an IEMI attack, an
adversary radiates electromagnetic energy to induce currents and voltages inside
vehicle electronics with goals ranging from temporary disruption of perception
systems to destroying hardware. EMI attacks directly target sensing hardware and
communication channels, which are common across many platforms. These attacks
also tend to be stealthier than light, laser, or acoustic signal attacks,
further making them an attractive mechanism to disrupt vehicle function
@GhostShotManipulatingImage.

These practical constraints shape the real-world feasibility of IEMI against
robotic vehicles. Effective coupling depends on attacker antenna gain and
accuracy, distance between the attacker and target, PCB design, and relative
motion between attacker and vehicle @xiaoSoKUnderstandingFundamentals2025
@kimSystematicStudyPhysical2024. However, defenses such as shielded enclosures,
cable routing and bonding, board-level filtering and decoupling, sensor fusion
and redundancy, and on-sensor diagnostics raise the bar for successful
exploitation by increasing required attack strength, tightening timing
tolerances for synchronized spoofing, or enabling rapid detection
@xiaoSoKUnderstandingFundamentals2025 @kimSystematicStudyPhysical2024
@mohammedIEMIEffectEfficacy2024. Many reported lab demonstrations assume
idealized aiming, short ranges, or specially configured test setups
@jangParalyzingDronesEMI2023 @sonRockingDronesIntentionala. Therefore, bridging
the gap between lab to realistic operation requires models that include mobility
and aiming error, mission-level impact, and coupling measurements for targeted
components.

== IEMI Attack Countermeasures

Robotic vehicles are exposed to an array of IEMI threats that exploit sensor
physics rather than software bugs, and although many mitigation techniques have
been proposed, no single defense is universally applicable. Practical protection
requires context-aware tradeoffs among size, weight, cost, thermal buildup,
sensing performance, and operational complexity
@xiaoSoKUnderstandingFundamentals2025 @kimSystematicStudyPhysical2024
@mohammedIEMIEffectEfficacy2024.

*Physical Countermeasures:* Physical hardening appears to be the most direct way
to reduce coupling of attacker signals to analog sensor paths. When applied
correctly, shielding and board-level filtering can substantially attenuate
injected signals @kuneGhostTalkMitigating2013. Careful design of PCB layout can
further reduce entry points for coupling @mohammedIEMIEffectEfficacy2024, and
dummy circuits can further mitigate the effects of malicious EMI signals
@tuTransductionShieldLowComplexity2021. However, these mitigations can reduce
legitimate sensor functionality, complicate thermal and mechanical design, and
can ultimately increase the system's mass, volume, and cost
@xiaoSoKUnderstandingFundamentals2025. Moreover, gaps within the shielding are
still exploitable by well-crafted directional attacks.
@bhupathirajuEMILiDARUncoveringVulnerabilities2023. Additionally, hardware
redundancy and sensor diversity reduces single-point failures but increase
weight, power draw, and system complexity. These mitigations push the problem
into the sensor-fusion domain with the assumption that coordinated, multimodal
attacks are not possible. However, as discussed by the authors of
@xiaoSoKUnderstandingFundamentals2025, the dominant sensor mechanism can still
be exploited.

*Digital Countermeasures:* Digital defenses aim to detect or mitigate injected
signals without changes to hardware. Statistical contamination metrics, anomaly
detection, and sensor-level plausibility checks can identify attack signals and
trigger fail-safe modes @kuneGhostTalkMitigating2013
@zhangDetectionElectromagneticInterference2020a
@jeongUnRockingDronesFoundations2023. Software and compiler-directed approaches
can add resilient processing that reduces attack impact without hardware
modification @choiDefendingEMIAttacks2024. However, attackers who learn
detection metrics can craft waveforms that mimic legitimate signals.
Additionally, detection thresholds that are tuned to avoid false positives in
noisy operational environments may be ineffective against sophisiticated
injections @xiaoSoKUnderstandingFundamentals2025.//@yanSoKMinimalistApproach2020a.

Assessing the real-world feasibility of systems using one or many of these
countermeasures is crucial. Robotic vehicles are safety-critical machines and
must be robust against any conceivable attack. Therefore, a high-fidelity attack
simulation platform should integrate known countermeasures into its systems.

== Assessing Feasibility of IEMI Attacks

*Profiling an Adversary:* The real-world feasibility of mission-critical attacks
depends on attacker resources, aiming capability, environmental factors, and
target configuration @szakalyAssaultBatteryEvaluating2024
@bhupathirajuEMILiDARUncoveringVulnerabilities2023. These conditions limit
generalization to field settings because many published experiments require
precise accuracy, have only been demonstrated at short ranges, or do not
consider end-to-end effects on the target cyber-physical system
@sonRockingDronesIntentionala @jangParalyzingDronesEMI2023
@lavauSecuringTemperatureMeasurements2023
@dayanikliElectromagneticSensorActuator2020a. To make feasibility claims
actionable, researchers should adopt explicit attacker models that capture
transmitter power, antenna gain, aiming accuracy, and mitigations taken by the
target. Attack success metrics should include measurement perturbation magnitude
and mission level probabilities of failure.

*Developing High-Fidelity Attack Simulation and Validation:*
Some prior works @kimSystematicStudyPhysical2024 @jangParalyzingDronesEMI2023
@jeongUnRockingDronesFoundations2023 have seen success in simulating attacks on
robotic vehicles. The authors of @kimSystematicStudyPhysical2024 developed
RVProber to assign prerequisite conditions that make a variety of physical
robotic vehicle attacks possible. To determine prerequisite parameters, RVProber
uses a SITL simulator to model robotic vehicles under attack by injecting
scheduling jitters and mutating attack parameters based on compromised sensor
values. However, modeling attacks like this does not account for the complex
electrical characteristics of sensors, integration with communication channels,
countermeasures, or, as discussed in the previous section, attacker
capabilities.

In @jangParalyzingDronesEMI2023, the authors attempt to demonstrate the
feasibility of their proposed paralyzing drone attack using PX4 SITL simulation
and analyzing how the attack propagates through a simulated drone's control
logic. The simulation uses a fluctuating IMU data stream to mimic their attack.
Using this attack method, the authors found that the simulated drone did not
attempt to filter the compromised IMU values. Thus, the measurements were
directly sent to the drone's attitude control algorithm. This result, however,
is likely infeasible in the real-world because state estimation or
countermeasures like sensor fusion algorithms are likely to prevent the
corrupted IMU data from propagating through the control logic and crashing the
drone.

The authors of @jeongUnRockingDronesFoundations2023 sought to develop an
acoustic signal injection testbed using PX4 SITL and HITL, finding that sampling
jitter, which originates from hardware imperfections, is a critical
consideration for accurate attack modeling. The authors also attempted to
capture drone movement in the SITL simulator by emulating resonant MEMs sensors
under stationary and dynamic cases. Overall, this attack testbed, while more
comprehensive than previously proposed ones, is still narrowly focused on MEMs
accelerometers and gyroscopes. These sensors, while critical for localization,
only make up a fraction of the sensors onboard drones. While sensors related to
a drone's perception system, like LiDAR and cameras, may be unaffected by
acoustic signal injection attacks, these sensors are vulnerable to IEMI attacks.
Thus the effects of these attacks are crucial to capture in a comprehensive
simulation platform.

From the above analysis, one can conclude that bridging the gap between
controlled demonstrations and field reality requires an approach which combines
high-fidelity simulation with hardware-in-the-loop (HITL) validation. To account
for directionality, a practical IEMI attack simulator for robotic vehicles
should combine radio wave propagation models with antenna pattern models.
Moreover, detailed sensor models that capture sensor-specific behaviors along
with EM coupling models are necessary to analyze how the EMI signals translate
into currents and voltages on the target system's circuits and propagate through
the system's perception and control stacks. Additionally, an attacker waveform
library informed by documented attacks will let researchers exercise realitic
threat scenarios and explore important parameter spaces such as power,
frequency, attack accuracy, and relative motion between the attacker and target.
This library should further be integrated with vehicle dynamics to analyze
completely analyze the end-to-end outcome of a given attack.


