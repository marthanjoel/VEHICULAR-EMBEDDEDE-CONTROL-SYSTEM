import 'package:flutter/material.dart';

class ParkingScreen extends StatefulWidget {
  const ParkingScreen({super.key});

  @override
  State<ParkingScreen> createState() => _ParkingScreenState();
}

class _ParkingScreenState extends State<ParkingScreen> {
  bool systemArmed = false;
  bool obstacleDetected = false;

  int sensorValue = 1023;

  String get distanceStatus {
    if (obstacleDetected) {
      return 'OBSTACLE DETECTED';
    }

    if (sensorValue <= 150) {
      return 'VERY CLOSE';
    }

    if (sensorValue <= 349) {
      return 'CLOSE';
    }

    if (sensorValue <= 699) {
      return 'CAUTION';
    }

    return 'SAFE';
  }

  Color get statusColor {
    if (obstacleDetected) {
      return Colors.red;
    }

    if (sensorValue <= 349) {
      return Colors.red;
    }

    if (sensorValue <= 699) {
      return Colors.orange;
    }

    return Colors.green;
  }

  IconData get statusIcon {
    if (obstacleDetected) {
      return Icons.warning;
    }

    if (sensorValue <= 349) {
      return Icons.dangerous;
    }

    if (sensorValue <= 699) {
      return Icons.warning_amber_rounded;
    }

    return Icons.check_circle;
  }

  String get buzzerStatus {
    if (!systemArmed) {
      return 'OFF';
    }

    if (obstacleDetected || sensorValue <= 349) {
      return 'FAST BUZZER';
    }

    if (sensorValue <= 699) {
      return 'SLOW BUZZER';
    }

    return 'OFF';
  }

  String get ledStatus {
    if (!systemArmed) {
      return 'OFF';
    }

    if (obstacleDetected || sensorValue <= 349) {
      return 'RED LED';
    }

    if (sensorValue <= 699) {
      return 'YELLOW LED';
    }

    return 'GREEN LED';
  }

  void startSystem() {
    setState(() {
      systemArmed = true;
    });
  }

  void disarmSystem() {
    setState(() {
      systemArmed = false;
      obstacleDetected = false;
    });
  }

  void setSensorValue(int value) {
    if (!systemArmed) return;

    setState(() {
      sensorValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PARKING ASSISTANCE',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(
              Icons.local_parking,
              size: 80,
              color: Colors.blue,
            ),

            const SizedBox(height: 10),

            const Text(
              'ADVANCED PARKING ASSISTANCE SYSTEM',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            // STATUS
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: systemArmed
                    ? statusColor
                    : Colors.grey,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Icon(
                    systemArmed
                        ? statusIcon
                        : Icons.power_settings_new,
                    color: Colors.white,
                    size: 65,
                  ),

                  const SizedBox(height: 10),

                  Text(
                    systemArmed
                        ? distanceStatus
                        : 'SYSTEM OFF',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    systemArmed
                        ? _description()
                        : 'Press START SYSTEM',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed:
                        systemArmed ? null : startSystem,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('START'),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: ElevatedButton.icon(
                    onPressed:
                        systemArmed ? disarmSystem : null,
                    icon: const Icon(Icons.stop),
                    label: const Text('DISARM'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // SENSOR
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    const Text(
                      'JOYSTICK / DISTANCE SENSOR',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),

                    const SizedBox(height: 15),

                    Text(
                      sensorValue.toString(),
                      style: TextStyle(
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                        color: systemArmed
                            ? statusColor
                            : Colors.grey,
                      ),
                    ),

                    const Text(
                      'VALUE: 0 - 1023',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 15),

                    Slider(
                      min: 0,
                      max: 1023,
                      value: sensorValue.toDouble(),
                      onChanged: systemArmed
                          ? (value) {
                              setState(() {
                                sensorValue =
                                    value.round();
                              });
                            }
                          : null,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 15),

            // OBSTACLE
            Card(
              child: SwitchListTile(
                value: obstacleDetected,
                onChanged: systemArmed
                    ? (value) {
                        setState(() {
                          obstacleDetected = value;
                        });
                      }
                    : null,
                secondary: Icon(
                  Icons.radar,
                  color: obstacleDetected
                      ? Colors.red
                      : Colors.green,
                ),
                title: const Text(
                  'OBSTACLE SENSOR',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  obstacleDetected
                      ? 'OBSTACLE DETECTED!'
                      : 'NO OBSTACLE',
                ),
              ),
            ),

            const SizedBox(height: 15),

            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          Icon(
                            Icons.lightbulb,
                            color: systemArmed
                                ? statusColor
                                : Colors.grey,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'LED',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(ledStatus),
                        ],
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          Icon(
                            Icons.volume_up,
                            color: systemArmed
                                ? statusColor
                                : Colors.grey,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'BUZZER',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(buzzerStatus),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    _testButton('VERY CLOSE', 100),
                    _testButton('CLOSE', 300),
                    _testButton('MEDIUM', 512),
                    _testButton('SAFE', 900),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _description() {
    if (obstacleDetected) {
      return 'Obstacle detected. STOP!';
    }

    if (sensorValue <= 150) {
      return 'Vehicle extremely close.';
    }

    if (sensorValue <= 349) {
      return 'Vehicle close to obstacle.';
    }

    if (sensorValue <= 699) {
      return 'Be careful. Obstacle getting closer.';
    }

    return 'Distance is safe.';
  }

  Widget _testButton(String text, int value) {
    return ElevatedButton(
      onPressed: systemArmed
          ? () => setSensorValue(value)
          : null,
      child: Text(text),
    );
  }
}
