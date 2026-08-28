import 'package:flutter/material.dart';

import 'security_screen.dart';
import 'lighting_screen.dart';
import 'driver_monitoring_screen.dart';
import 'parking_screen.dart';
import 'environment_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'VEHICULAR CONTROL SYSTEM',
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
            const SizedBox(height: 10),

            const Icon(
              Icons.directions_car,
              size: 80,
              color: Colors.blue,
            ),

            const SizedBox(height: 10),

            const Text(
              'VEHICULAR CONTROL SYSTEM',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
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
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text(
                  'Not connected',
                ),
                trailing: ElevatedButton(
                  onPressed: () {},
                  child: const Text('CONNECT'),
                ),
              ),
            ),

            const SizedBox(height: 25),

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

            const SizedBox(height: 15),

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

            const SizedBox(height: 25),

            Text(
              'LUTWAMA JOEL MARTHAN',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.bold,
              ),
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

        trailing: const Icon(
          Icons.arrow_forward_ios,
        ),

        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => screen,
            ),
          );
        },
      ),
    );
  }
}
