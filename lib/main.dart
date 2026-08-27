import 'package:flutter/material.dart';

void main() {
  runApp(const VehicularEnvironmentApp());
}

class VehicularEnvironmentApp extends StatelessWidget {
  const VehicularEnvironmentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vehicular Environment Control System',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: const DashboardPage(),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'VEHICULAR ENVIRONMENT',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'ENVIRONMENT CONTROL SYSTEM',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: sensorCard(
                    Icons.thermostat,
                    'Temperature',
                    '28 °C',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: sensorCard(
                    Icons.water_drop,
                    'Humidity',
                    '65 %',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            statusCard(
              Icons.local_fire_department,
              'Flame Detection',
              'SAFE',
              Colors.green,
            ),

            const SizedBox(height: 12),

            statusCard(
              Icons.ac_unit,
              'HVAC / Relay',
              'OFF',
              Colors.green,
            ),

            const SizedBox(height: 12),

            statusCard(
              Icons.volume_up,
              'Buzzer',
              'OFF',
              Colors.green,
            ),

            const SizedBox(height: 25),

            const Text(
              'SYSTEM CONTROL',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.power_settings_new),
              label: const Text('TURN HVAC ON'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),

            const SizedBox(height: 10),

            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.usb),
              label: const Text('CONNECT TO ARDUINO'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),

            const SizedBox(height: 20),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(
                      Icons.circle,
                      size: 16,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'System Status: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text('NORMAL'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget sensorCard(
    IconData icon,
    String title,
    String value,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 40),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget statusCard(
    IconData icon,
    String title,
    String status,
    Color statusColor,
  ) {
    return Card(
      child: ListTile(
        leading: Icon(
          icon,
          size: 36,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Text(
          status,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: statusColor,
          ),
        ),
      ),
    );
  }
}