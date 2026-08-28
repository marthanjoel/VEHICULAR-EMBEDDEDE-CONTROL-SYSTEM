```dart
import 'package:flutter/material.dart';

class DriverMonitoringScreen extends StatefulWidget {
  const DriverMonitoringScreen({super.key});

  @override
  State<DriverMonitoringScreen> createState() =>
      _DriverMonitoringScreenState();
}

class _DriverMonitoringScreenState
    extends State<DriverMonitoringScreen> {
  bool isMonitoring = false;

  int heartRate = 80;
  double temperature = 36.5;
  bool headTiltDetected = false;

  bool get heartRateNormal {
    return heartRate >= 50 && heartRate <= 120;
  }

  bool get temperatureNormal {
    return temperature <= 38.0;
  }

  bool get driverSafe {
    return isMonitoring &&
        heartRateNormal &&
        temperatureNormal &&
        !headTiltDetected;
  }

  String get driverStatus {
    if (!isMonitoring) {
      return 'MONITORING OFF';
    }

    if (driverSafe) {
      return 'DRIVER SAFE';
    }

    return 'DRIVER ALERT!';
  }

  Color get driverStatusColor {
    if (!isMonitoring) {
      return Colors.grey;
    }

    if (driverSafe) {
      return Colors.green;
    }

    return Colors.red;
  }

  void toggleMonitoring() {
    setState(() {
      isMonitoring = !isMonitoring;

      if (!isMonitoring) {
        heartRate = 80;
        temperature = 36.5;
        headTiltDetected = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'DRIVER MONITORING',
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
              Icons.monitor_heart,
              size: 85,
              color: Colors.blue,
            ),

            const SizedBox(height: 10),

            const Text(
              'DRIVER MONITORING & ALERT SYSTEM',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            // DRIVER STATUS
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: driverStatusColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Icon(
                    driverSafe
                        ? Icons.verified_user
                        : isMonitoring
                            ? Icons.warning
                            : Icons.monitor_heart,
                    size: 65,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    driverStatus,
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

            MonitoringCard(
              icon: Icons.favorite,
              title: 'HEART RATE',
              value: isMonitoring ? '$heartRate BPM' : '-- BPM',
              status: !isMonitoring
                  ? 'NOT MONITORED'
                  : heartRateNormal
                      ? 'NORMAL'
                      : 'ABNORMAL',
              color: !isMonitoring
                  ? Colors.grey
                  : heartRateNormal
                      ? Colors.green
                      : Colors.red,
            ),

            const SizedBox(height: 15),

            MonitoringCard(
              icon: Icons.thermostat,
              title: 'BODY TEMPERATURE',
              value: isMonitoring
                  ? '${temperature.toStringAsFixed(1)} °C'
                  : '-- °C',
              status: !isMonitoring
                  ? 'NOT MONITORED'
                  : temperatureNormal
                      ? 'NORMAL'
                      : 'HIGH',
              color: !isMonitoring
                  ? Colors.grey
                  : temperatureNormal
                      ? Colors.green
                      : Colors.red,
            ),

            const SizedBox(height: 15),

            MonitoringCard(
              icon: Icons.person,
              title: 'HEAD POSITION',
              value: headTiltDetected ? 'TILTED' : 'NORMAL',
              status: !isMonitoring
                  ? 'NOT MONITORED'
                  : headTiltDetected
                      ? 'HEAD TILT DETECTED'
                      : 'NORMAL',
              color: !isMonitoring
                  ? Colors.grey
                  : headTiltDetected
                      ? Colors.red
                      : Colors.green,
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton.icon(
                onPressed: toggleMonitoring,
                icon: Icon(
                  isMonitoring ? Icons.stop : Icons.play_arrow,
                ),
                label: Text(
                  isMonitoring
                      ? 'STOP MONITORING'
                      : 'START MONITORING',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
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
                      'DRIVER SENSOR TEST',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: isMonitoring
                              ? () {
                                  setState(() {
                                    heartRate = 80;
                                  });
                                }
                              : null,
                          child: const Text('NORMAL HEART'),
                        ),

                        ElevatedButton(
                          onPressed: isMonitoring
                              ? () {
                                  setState(() {
                                    heartRate = 150;
                                  });
                                }
                              : null,
                          child: const Text('HIGH HEART'),
                        ),

                        ElevatedButton(
                          onPressed: isMonitoring
                              ? () {
                                  setState(() {
                                    headTiltDetected =
                                        !headTiltDetected;
                                  });
                                }
                              : null,
                          child: const Text('TOGGLE TILT'),
                        ),
                      ],
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

class MonitoringCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String status;
  final Color color;

  const MonitoringCard({
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
          backgroundColor: color.withValues(alpha: 0.12),
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
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
      ),
    );
  }
}
```
