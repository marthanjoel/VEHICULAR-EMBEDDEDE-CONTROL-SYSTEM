```dart
import 'package:flutter/material.dart';

import 'screens/lighting_screen.dart';
import 'screens/parking_screen.dart';
import 'screens/security_screen.dart';
import 'screens/driver_monitoring_screen.dart';
import 'screens/environment_screen.dart';

void main() {
  runApp(const VehicularApp());
}

class VehicularApp extends StatelessWidget {
  const VehicularApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vehicular Control System',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'VEHICULAR CONTROL SYSTEM',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Icon(
                      Icons.directions_car,
                      size: 60,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'VEHICULAR SYSTEM',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Text(
                        'SYSTEM NORMAL',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.usb,
                  size: 35,
                ),
                title: const Text(
                  'Arduino Connection',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text('Not connected'),
                trailing: ElevatedButton(
                  onPressed: () {},
                  child: const Text('CONNECT'),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'VEHICLE SYSTEMS',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 12),

            systemCard(
              context,
              Icons.lightbulb,
              'SMART LIGHTING',
              'Vehicle lighting control',
              const SmartLightingScreen(),
            ),

            systemCard(
              context,
              Icons.local_parking,
              'PARKING ASSISTANCE',
              'Obstacle and parking monitoring',
              const ParkingScreen(),
            ),

            systemCard(
              context,
              Icons.security,
              'VEHICLE SECURITY',
              'Anti-theft and security system',
              const SecurityScreen(),
            ),

            systemCard(
              context,
              Icons.person,
              'DRIVER MONITORING',
              'Driver monitoring and alerts',
              const DriverMonitoringScreen(),
            ),

            systemCard(
              context,
              Icons.thermostat,
              'ENVIRONMENT CONTROL',
              'Temperature, humidity and flame',
              const EnvironmentScreen(),
            ),
          ],
        ),
      ),
    );
  }

  Widget systemCard(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    Widget screen,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          radius: 28,
          child: Icon(
            icon,
            size: 30,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => screen,
            ),
          );
        },
      ),
    );
  }
}
```
