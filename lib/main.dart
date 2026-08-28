import 'package:flutter/material.dart';

import 'screens/security_screen.dart';
import 'screens/lighting_screen.dart';
import 'screens/driver_monitoring_screen.dart';
import 'screens/parking_screen.dart';
import 'screens/environment_screen.dart';

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
              size: 85,
              color: Colors.blue,
            ),

            const SizedBox(height: 10),

            const Text(
              'VEHICULAR CONTROL SYSTEM',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Integrated Vehicle Monitoring & Control',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 25),

            // SYSTEM STATUS
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Icon(
                      Icons.settings_remote,
                      size: 45,
                      color: Colors.green,
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      'SYSTEM STATUS',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Text(
                        'SYSTEM READY',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ARDUINO CONNECTION
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
                  'Simulation mode',
                ),
                trailing: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Arduino connection will be added next.',
                        ),
                      ),
                    );
                  },
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
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 12),

            systemCard(
              context,
              Icons.lightbulb,
              'SMART LIGHTING',
              'Automatic lighting and brightness control',
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
              'Anti-theft and vibration monitoring',
              const SecurityScreen(),
            ),

            systemCard(
              context,
              Icons.monitor_heart,
              'DRIVER MONITORING',
              'Driver health and alert monitoring',
              const DriverMonitoringScreen(),
            ),

            systemCard(
              context,
              Icons.thermostat,
              'ENVIRONMENT CONTROL',
              'Cabin, engine temperature, humidity and fire',
              const EnvironmentScreen(),
            ),

            const SizedBox(height: 25),

            const Text(
              'VEHICULAR CONTROL SYSTEM',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              'LUTWAMA JOEL MARTHAN',
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 20),
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
      elevation: 2,
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
          size: 18,
        ),

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
