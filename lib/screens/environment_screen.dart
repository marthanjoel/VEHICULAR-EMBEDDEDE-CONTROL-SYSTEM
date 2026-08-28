import 'package:flutter/material.dart';

class EnvironmentScreen extends StatefulWidget {
  const EnvironmentScreen({super.key});

  @override
  State<EnvironmentScreen> createState() =>
      _EnvironmentScreenState();
}

class _EnvironmentScreenState
    extends State<EnvironmentScreen> {
  bool systemOn = false;

  double cabinTemperature = 25.0;
  double humidity = 50.0;
  double engineTemperature = 40.0;

  bool flameDetected = false;

  bool get overheating {
    return engineTemperature > 50;
  }

  bool get highHumidity {
    return humidity > 70;
  }

  bool get alert {
    return flameDetected || overheating;
  }

  String get systemStatus {
    if (!systemOn) {
      return 'SYSTEM OFF';
    }

    if (flameDetected) {
      return 'FIRE ALERT!';
    }

    if (overheating) {
      return 'ENGINE OVERHEATING!';
    }

    if (highHumidity) {
      return 'HIGH HUMIDITY';
    }

    return 'SYSTEM SAFE';
  }

  Color get statusColor {
    if (!systemOn) {
      return Colors.grey;
    }

    if (alert) {
      return Colors.red;
    }

    if (highHumidity) {
      return Colors.orange;
    }

    return Colors.green;
  }

  void toggleSystem() {
    setState(() {
      systemOn = !systemOn;

      if (!systemOn) {
        flameDetected = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ENVIRONMENT CONTROL',
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
              Icons.thermostat,
              size: 85,
              color: Colors.blue,
            ),

            const SizedBox(height: 10),

            const Text(
              'VEHICULAR ENVIRONMENT CONTROL SYSTEM',
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
                color: statusColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Icon(
                    alert
                        ? Icons.warning
                        : Icons.thermostat,
                    size: 65,
                    color: Colors.white,
                  ),

                  const SizedBox(height: 10),

                  Text(
                    systemStatus,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: toggleSystem,
                icon: Icon(
                  systemOn
                      ? Icons.power_settings_new
                      : Icons.play_arrow,
                ),
                label: Text(
                  systemOn
                      ? 'TURN SYSTEM OFF'
                      : 'TURN SYSTEM ON',
                ),
              ),
            ),

            const SizedBox(height: 20),

            // CABIN TEMPERATURE
            EnvironmentCard(
              icon: Icons.thermostat,
              title: 'CABIN TEMPERATURE',
              value:
                  '${cabinTemperature.toStringAsFixed(1)} °C',
              status: 'Cabin temperature',
              color: Colors.orange,
            ),

            const SizedBox(height: 15),

            // HUMIDITY
            EnvironmentCard(
              icon: Icons.water_drop,
              title: 'CABIN HUMIDITY',
              value:
                  '${humidity.toStringAsFixed(1)} %',
              status: highHumidity
                  ? 'HIGH HUMIDITY'
                  : 'NORMAL',
              color: highHumidity
                  ? Colors.orange
                  : Colors.blue,
            ),

            const SizedBox(height: 15),

            // ENGINE TEMPERATURE
            EnvironmentCard(
              icon: Icons.local_fire_department,
              title: 'ENGINE TEMPERATURE',
              value:
                  '${engineTemperature.toStringAsFixed(1)} °C',
              status: overheating
                  ? 'OVERHEATING!'
                  : 'NORMAL',
              color: overheating
                  ? Colors.red
                  : Colors.green,
            ),

            const SizedBox(height: 15),

            // FLAME
            Card(
              child: SwitchListTile(
                value: flameDetected,
                onChanged: systemOn
                    ? (value) {
                        setState(() {
                          flameDetected = value;
                        });
                      }
                    : null,
                secondary: Icon(
                  Icons.local_fire_department,
                  color: flameDetected
                      ? Colors.red
                      : Colors.green,
                ),
                title: const Text(
                  'FLAME SENSOR',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  flameDetected
                      ? 'FIRE DETECTED!'
                      : 'NO FIRE DETECTED',
                ),
              ),
            ),

            const SizedBox(height: 15),

            // HVAC / RELAY
            Card(
              child: ListTile(
                leading: Icon(
                  Icons.ac_unit,
                  color: alert
                      ? Colors.red
                      : Colors.blue,
                  size: 35,
                ),
                title: const Text(
                  'HVAC / WINDOW RELAY',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  alert
                      ? 'RELAY ACTIVE'
                      : 'RELAY OFF',
                ),
              ),
            ),

            const SizedBox(height: 20),

            // TEST CONTROLS
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'ENVIRONMENT SENSOR TEST',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    ElevatedButton(
                      onPressed: systemOn
                          ? () {
                              setState(() {
                                engineTemperature =
                                    engineTemperature > 50
                                        ? 40
                                        : 60;
                              });
                            }
                          : null,
                      child: Text(
                        overheating
                            ? 'CLEAR OVERHEATING'
                            : 'SIMULATE OVERHEATING',
                      ),
                    ),

                    const SizedBox(height: 8),

                    ElevatedButton(
                      onPressed: systemOn
                          ? () {
                              setState(() {
                                humidity =
                                    highHumidity
                                        ? 50
                                        : 80;
                              });
                            }
                          : null,
                      child: Text(
                        highHumidity
                            ? 'CLEAR HUMIDITY'
                            : 'SIMULATE HIGH HUMIDITY',
                      ),
                    ),

                    const SizedBox(height: 8),

                    ElevatedButton(
                      onPressed: systemOn
                          ? () {
                              setState(() {
                                flameDetected =
                                    !flameDetected;
                              });
                            }
                          : null,
                      child: Text(
                        flameDetected
                            ? 'CLEAR FIRE'
                            : 'SIMULATE FIRE',
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'VEHICULAR ENVIRONMENT CONTROL SYSTEM',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EnvironmentCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String status;
  final Color color;

  const EnvironmentCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.status,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),

        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.12),
          child: Icon(
            icon,
            color: color,
          ),
        ),

        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        subtitle: Text(status),

        trailing: Text(
          value,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }
}

