# Vehicle Environment Control System

## Overview

The Vehicle Environment Control System is an Arduino-based vehicle safety and environment monitoring system controlled through a Flutter mobile application.

The system monitors the vehicle environment and provides automatic responses when dangerous conditions are detected.

## System Architecture

```text
Flutter Mobile App
        |
      USB OTG
        |
    Arduino UNO
        |
  -------------------------
  |       |       |       |
 DHT11   LM35   Flame   Outputs
 Sensor Sensor  Sensor
                  |
          ----------------
          |      |       |
        Relay  Buzzer   RGB LED
