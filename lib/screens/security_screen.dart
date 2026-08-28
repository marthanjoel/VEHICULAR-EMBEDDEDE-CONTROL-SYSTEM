import 'package:flutter/material.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  bool systemArmed = false;
  bool vibrationDetected = false;

  String get securityStatus {
    if (!systemArmed) {
      return 'SYSTEM DISARMED';
    }

    if (vibrationDetected) {
      return 'SECURITY ALERT!';
    }

    return 'VEHICLE SECURE';
  }

  Color get statusColor {
    if (!systemArmed) {
      return Colors.grey;
    }

    if (vibrationDetected) {
      return Colors.red;
    }

    return Colors.green;
  }

  void armSystem() {
    setState(() {
      systemArmed = true;
      vibrationDetected = false;
    });
  }

  void disarmSystem() {
    setState(() {
      systemArmed = false;
      vibrationDetected = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'VEHICLE SECURITY',
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
              Icons.security,
              size: 85,
              color: Colors.blue,
            ),

            const SizedBox(height: 10),

            const Text(
              'VEHICLE SECURITY & ANTI-THEFT',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25),

            // STATUS
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Icon(
                    vibrationDetected
                        ? Icons.warning
                        : systemArmed
                            ? Icons.lock
                            : Icons.lock_open,
                    size: 70,
                    color: Colors.white,
                  ),

                  const SizedBox(height: 12),

                  Text(
                    securityStatus,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    vibrationDetected
                        ? 'Unauthorized vibration detected!'
                        : systemArmed
                            ? 'Vehicle is being monitored.'
                            : 'Security system is not active.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ARM / DISARM
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: systemArmed ? null : armSystem,
                    icon: const Icon(Icons.lock),
                    label: const Text('ARM SYSTEM'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: systemArmed ? disarmSystem : null,
                    icon: const Icon(Icons.lock_open),
                    label: const Text('DISARM'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // VIBRATION SENSOR
            Card(
              child: SwitchListTile(
                value: vibrationDetected,
                onChanged: systemArmed
                    ? (value) {
                        setState(() {
                          vibrationDetected = value;
                        });
                      }
                    : null,
                secondary: Icon(
                  Icons.vibration,
                  color: vibrationDetected
                      ? Colors.red
                      : Colors.green,
                ),
                title: const Text(
                  'VIBRATION SENSOR',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  vibrationDetected
                      ? 'VIBRATION DETECTED'
                      : 'NO VIBRATION DETECTED',
                ),
              ),
            ),

            const SizedBox(height: 15),

            // LED
            Card(
              child: ListTile(
                leading: Icon(
                  Icons.lightbulb,
                  color: statusColor,
                  size: 35,
                ),
                title: const Text(
                  'SECURITY LED',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  !systemArmed
                      ? 'OFF'
                      : vibrationDetected
                          ? 'RED LED - ALERT'
                          : 'YELLOW LED - NORMAL',
                ),
              ),
            ),

            const SizedBox(height: 15),

            // BUZZER
            Card(
              child: ListTile(
                leading: Icon(
                  Icons.volume_up,
                  color: vibrationDetected
                      ? Colors.red
                      : Colors.grey,
                  size: 35,
                ),
                title: const Text(
                  'SECURITY BUZZER',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  vibrationDetected
                      ? 'BUZZER ACTIVE'
                      : 'BUZZER OFF',
                ),
              ),
            ),

            const SizedBox(height: 20),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'SECURITY SENSOR TEST',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    ElevatedButton.icon(
                      onPressed: systemArmed
                          ? () {
                              setState(() {
                                vibrationDetected =
                                    !vibrationDetected;
                              });
                            }
                          : null,
                      icon: const Icon(Icons.vibration),
                      label: Text(
                        vibrationDetected
                            ? 'CLEAR VIBRATION'
                            : 'SIMULATE VIBRATION',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
