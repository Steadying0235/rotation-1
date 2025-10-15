=== RF Attack Tables
#table( columns: (auto, auto, auto, auto, auto, auto),
  inset: 10pt,
  align: horizon,
  table.header(
    [*Attack Type*], [*Target Component*], [*Wavelength*], [*Distance*], [*Required Power*], [*Reference*]
  ),
  [ Spoofing ],
  [Pressure sensor],
  [655 - 800 MHz],
  [0.2 m],
  [ Have not found exact value yet],
  [@tuTransductionShieldLowComplexity2021],
  [Denial of Service],
  [SPI or I2C channel between control unit and IMU],
  [The exact value depends on board. Tested ranges are from 18 - 354 MHz],
  [Real tests conducted \@ 0.44 m and 2.4 m],
  [The exact value depends on board. 
  Arduino: \~30 dBm \@ 2.4m
  Pixhawk4: 47x more power than Arduino
  DJI: 98x more power than Arduino
  ],
  [@jangParalyzingDronesEMI2023],
  [Spoofing],
  [CCD Camera],
  [Sweeping range from 20-100 MHz \@ 0.1 MHz increments.
  Most cameras were vulnerable between 50-90 MHz],
  [0 - 60 cm],
  [ Have not found exact value yet],
  [@GhostShotManipulatingImage],
  [Spoofing],
  [LiDAR time-of-flight circuit],
  [Sweeping range from 400-1000 MHz.
  Sensors found vulnerable \@ 949.8 MHz, 960.9 MHz, and 977.4 MHz],
  [2 m , 4 m, 6 m],
  [maximum gain of 25 dB in real-world experiments],
  [@bhupathirajuEMILiDARUncoveringVulnerabilities2023],
)
#table(columns: (auto, auto, auto, auto, auto, auto),
  inset: 10pt,
  align: horizon,
  table.header(
    [*Attack Type*], [*Target Component*], [*Wavelength*], [*Distance*], [*Required Power*], [*Reference*]
  ),
  [Spoofing],
  [Power conversion system (AC-DC converter, DC-DC converter, current sensor, battery charger)],
  [ Frequency sweep from 50 MHz to 3 GHz \@ 19 dBm power.
    DC-DC converters most vulnerable between 1-1.3 GHz
    AC-DC converters most vulnerable between 1.4-1.6 GHz
    Current sensors most vulnerable between 0.3-0.5 GHz
    Battery chargers most vulnerable between 0.7-0.9 GHz and 1.2-1.4 GHz],
  [A battery charger was tested at range between 1-5 m. The authors note that the attack can be successful up to 2 m distance.],
  [19 dBm],
  [@szakalyAssaultBatteryEvaluating2024],
)

#bibliography("refs.bib")