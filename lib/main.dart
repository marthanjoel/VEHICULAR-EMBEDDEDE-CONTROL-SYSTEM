import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const VehicleEnvironmentApp());
}

class VehicleEnvironmentApp extends StatelessWidget {
  const VehicleEnvironmentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vehicle Environment Control',
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF06111F),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
      ),
      home: const VehicleHome(),
    );
  }
}

class VehicleHome extends StatefulWidget {
  const VehicleHome({super.key});

  @override
  State<VehicleHome> createState() => _VehicleHomeState();
}

class _VehicleHomeState extends State<VehicleHome> {
  // ==========================================================
  // CONNECTION
  // ==========================================================

  bool arduinoConnected = false;

  // ==========================================================
  // SYSTEM
  // ==========================================================

  bool started = false;
  bool armed = false;

  // ==========================================================
  // REAL ARDUINO SENSOR VALUES
  //
  // These start at ZERO.
  // They will later be replaced by values received from Arduino.
  // ==========================================================

  double cabinTemperature = 0.0;
  double humidity = 0.0;
  double engineTemperature = 0.0;

  bool flameDetected = false;

  bool relayOn = false;
  bool buzzerOn = false;

  // ==========================================================
  // LOG
  // ==========================================================

  final List<String> logs = [];

  // ==========================================================
  // THRESHOLDS
  // ==========================================================

  bool get cabinHot => cabinTemperature > 35.0;

  bool get engineHot => engineTemperature > 200.0;

  bool get emergency =>
      flameDetected || cabinHot || engineHot;

  String get systemStatus {
    if (!started) {
      return 'SYSTEM STOPPED';
    }

    if (!armed) {
      return 'SYSTEM DISARMED';
    }

    if (flameDetected && engineHot) {
      return 'FIRE & OVERHEATING';
    }

    if (flameDetected) {
      return 'FIRE DETECTED';
    }

    if (engineHot) {
      return 'ENGINE OVERHEATING';
    }

    if (cabinHot) {
      return 'CABIN TOO HOT';
    }

    return 'SYSTEM SAFE';
  }

  Color get statusColor {
    if (!started) {
      return Colors.grey;
    }

    if (!armed) {
      return Colors.orange;
    }

    if (emergency) {
      return Colors.red;
    }

    return Colors.green;
  }

  IconData get statusIcon {
    if (!started) {
      return Icons.power_settings_new;
    }

    if (!armed) {
      return Icons.lock_open;
    }

    if (emergency) {
      return Icons.warning_rounded;
    }

    return Icons.verified;
  }

  // ==========================================================
  // START
  // ==========================================================

  void startSystem() {
    setState(() {
      started = true;
    });

    sendCommand('START');
    addLog('SYSTEM STARTED');
  }

  // ==========================================================
  // STOP
  // ==========================================================

  void stopSystem() {
    setState(() {
      started = false;
      armed = false;
      relayOn = false;
      buzzerOn = false;
    });

    sendCommand('STOP');
    addLog('SYSTEM STOPPED');
  }

  // ==========================================================
  // ARM
  // ==========================================================

  void armSystem() {
    if (!started) {
      showMessage('START the system first.');
      return;
    }

    setState(() {
      armed = true;
    });

    sendCommand('ARM');
    addLog('SYSTEM ARMED');
  }

  // ==========================================================
  // DISARM
  // ==========================================================

  void disarmSystem() {
    setState(() {
      armed = false;
      relayOn = false;
      buzzerOn = false;
    });

    sendCommand('DISARM');
    addLog('SYSTEM DISARMED');
  }

  // ==========================================================
  // ARDUINO COMMAND
  // ==========================================================

  void sendCommand(String command) {
    /*
      REAL USB SERIAL CONNECTION WILL BE CONNECTED HERE.

      Commands sent to Arduino:

      START
      STOP
      ARM
      DISARM
    */

    debugPrint('Arduino command: $command');
  }

  // ==========================================================
  // ARDUINO DATA RECEIVER
  // ==========================================================

  void receiveArduinoData(String line) {
    /*
      Arduino sends:

      DATA,28.7,59.0,150.2,0,0,0

      Format:

      DATA,
      cabin temperature,
      humidity,
      engine temperature,
      flame,
      relay,
      buzzer
    */

    line = line.trim();

    if (!line.startsWith('DATA,')) {
      return;
    }

    final parts = line.split(',');

    if (parts.length < 7) {
      return;
    }

    final cabin = double.tryParse(parts[1]) ?? 0.0;
    final hum = double.tryParse(parts[2]) ?? 0.0;
    final engine = double.tryParse(parts[3]) ?? 0.0;

    final flame = parts[4] == '1';
    final relay = parts[5] == '1';
    final buzzer = parts[6] == '1';

    setState(() {
      cabinTemperature = cabin;
      humidity = hum;
      engineTemperature = engine;

      flameDetected = flame;
      relayOn = relay;
      buzzerOn = buzzer;
    });
  }

  // ==========================================================
  // ARDUINO CONNECTION
  // ==========================================================

  void connectArduino() {
    /*
      USB OTG CONNECTION WILL BE IMPLEMENTED HERE.

      Phone
        ↓
      USB OTG
        ↓
      Arduino UNO
    */

    setState(() {
      arduinoConnected = !arduinoConnected;
    });

    if (arduinoConnected) {
      addLog('ARDUINO CONNECTION ENABLED');
      showMessage('Arduino connection enabled.');
    } else {
      addLog('ARDUINO DISCONNECTED');
      showMessage('Arduino disconnected.');
    }
  }

  // ==========================================================
  // LOG
  // ==========================================================

  void addLog(String message) {
    setState(() {
      logs.insert(0, message);

      if (logs.length > 12) {
        logs.removeLast();
      }
    });
  }

  // ==========================================================
  // MESSAGE
  // ==========================================================

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  // ==========================================================
  // UI
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A192B),
        title: const Row(
          children: [
            Icon(Icons.directions_car),
            SizedBox(width: 10),
            Flexible(
              child: Text(
                'VEHICLE ENVIRONMENT CONTROL',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Center(
              child: Row(
                children: [
                  Icon(
                    Icons.circle,
                    size: 10,
                    color: arduinoConnected
                        ? Colors.green
                        : Colors.orange,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    arduinoConnected
                        ? 'ARDUINO'
                        : 'NO ARDUINO',
                    style: TextStyle(
                      color: arduinoConnected
                          ? Colors.green
                          : Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 1000,
              ),
              child: Column(
                children: [

                  // =================================================
                  // CONNECTION
                  // =================================================

                  connectionCard(),

                  const SizedBox(height: 16),

                  // =================================================
                  // STATUS
                  // =================================================

                  statusCard(),

                  const SizedBox(height: 16),

                  // =================================================
                  // CONTROLS
                  // =================================================

                  controlCard(),

                  const SizedBox(height: 24),

                  const SectionTitle(
                    title: 'ENVIRONMENT MONITORING',
                  ),

                  const SizedBox(height: 12),

                  // =================================================
                  // SENSORS
                  // =================================================

                  sensorGrid(),

                  const SizedBox(height: 24),

                  // =================================================
                  // FIRE
                  // =================================================

                  firePanel(),

                  const SizedBox(height: 24),

                  const SectionTitle(
                    title: 'SYSTEM DEVICES',
                  ),

                  const SizedBox(height: 12),

                  deviceCard(
                    'VENTILATION / RELAY',
                    relayOn,
                    Icons.air,
                  ),

                  const SizedBox(height: 10),

                  deviceCard(
                    'WARNING BUZZER',
                    buzzerOn,
                    Icons.volume_up,
                  ),

                  const SizedBox(height: 24),

                  const SectionTitle(
                    title: 'ACTIVITY LOG',
                  ),

                  const SizedBox(height: 12),

                  logCard(),

                  const SizedBox(height: 24),

                  thresholdCard(),

                  const SizedBox(height: 20),

                  const Text(
                    'HARDWARE CONTROL READY',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // CONNECTION CARD
  // ==========================================================

  Widget connectionCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: boxDecoration(),
      child: Row(
        children: [
          Icon(
            arduinoConnected
                ? Icons.usb
                : Icons.usb_off,
            size: 32,
            color: arduinoConnected
                ? Colors.green
                : Colors.orange,
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  'ARDUINO CONTROLLER',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  arduinoConnected
                      ? 'Arduino connected'
                      : 'No Arduino connected',
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          ElevatedButton(
            onPressed: connectArduino,
            child: Text(
              arduinoConnected
                  ? 'DISCONNECT'
                  : 'CONNECT',
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // STATUS CARD
  // ==========================================================

  Widget statusCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.10),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: statusColor,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Icon(
            statusIcon,
            color: statusColor,
            size: 65,
          ),

          const SizedBox(height: 10),

          Text(
            systemStatus,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: statusColor,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 7),

          Text(
            emergency
                ? 'ATTENTION REQUIRED'
                : 'Vehicle environment monitoring system',
            style: const TextStyle(
              color: Colors.white60,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // CONTROL CARD
  // ==========================================================

  Widget controlCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: boxDecoration(),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'SYSTEM CONTROL',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed:
                      started ? null : startSystem,
                  icon: const Icon(
                    Icons.play_arrow,
                  ),
                  label: const Text('START'),
                  style: ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.all(15),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: ElevatedButton.icon(
                  onPressed:
                      started ? stopSystem : null,
                  icon: const Icon(Icons.stop),
                  label: const Text('STOP'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.red.shade800,
                    padding:
                        const EdgeInsets.all(15),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed:
                      armed ? null : armSystem,
                  icon: const Icon(Icons.lock),
                  label: const Text('ARM'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.green.shade800,
                    padding:
                        const EdgeInsets.all(15),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: ElevatedButton.icon(
                  onPressed:
                      armed ? disarmSystem : null,
                  icon:
                      const Icon(Icons.lock_open),
                  label: const Text('DISARM'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.orange.shade800,
                    padding:
                        const EdgeInsets.all(15),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // SENSOR GRID
  // ==========================================================

  Widget sensorGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns =
            constraints.maxWidth >= 700 ? 4 : 2;

        return GridView.count(
          crossAxisCount: columns,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          shrinkWrap: true,
          physics:
              const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.05,
          children: [
            sensorCard(
              'CABIN TEMPERATURE',
              '${cabinTemperature.toStringAsFixed(1)} °C',
              Icons.thermostat,
              cabinHot,
            ),

            sensorCard(
              'HUMIDITY',
              '${humidity.toStringAsFixed(1)} %',
              Icons.water_drop,
              humidity > 70,
            ),

            sensorCard(
              'ENGINE TEMPERATURE',
              '${engineTemperature.toStringAsFixed(1)} °C',
              Icons.local_fire_department,
              engineHot,
            ),

            fireCard(),
          ],
        );
      },
    );
  }

  // ==========================================================
  // SENSOR CARD
  // ==========================================================

  Widget sensorCard(
    String title,
    String value,
    IconData icon,
    bool danger,
  ) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF0B1A2C),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: danger
              ? Colors.red
              : Colors.white10,
          width: danger ? 2 : 1,
        ),
      ),
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 38,
            color:
                danger ? Colors.red : Colors.blue,
          ),

          const SizedBox(height: 10),

          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.white60,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color:
                  danger ? Colors.red : Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // FIRE CARD
  // ==========================================================

  Widget fireCard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: flameDetected
            ? Colors.red.withOpacity(0.18)
            : const Color(0xFF0B1A2C),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color:
              flameDetected ? Colors.red : Colors.green,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          Icon(
            flameDetected
                ? Icons.local_fire_department
                : Icons.shield,
            size: 42,
            color:
                flameDetected ? Colors.red : Colors.green,
          ),

          const SizedBox(height: 8),

          Text(
            flameDetected
                ? 'FIRE DETECTED'
                : 'NO FIRE',
            textAlign: TextAlign.center,
            style: TextStyle(
              color:
                  flameDetected ? Colors.red : Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            flameDetected
                ? 'FLAME SENSOR ACTIVE'
                : 'FLAME SENSOR NORMAL',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 9,
              color: Colors.white60,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // FIRE PANEL
  // ==========================================================

  Widget firePanel() {
    if (!flameDetected) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.08),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Colors.green.withOpacity(0.5),
          ),
        ),
        child: const Row(
          children: [
            Icon(
              Icons.shield,
              color: Colors.green,
              size: 35,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'FIRE MONITORING: NORMAL',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.red,
          width: 2,
        ),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.local_fire_department,
            color: Colors.red,
            size: 65,
          ),

          SizedBox(height: 8),

          Text(
            '🔥 FIRE EMERGENCY',
            style: TextStyle(
              color: Colors.red,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 8),

          Text(
            'FLAME SENSOR HAS DETECTED FIRE',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // DEVICE CARD
  // ==========================================================

  Widget deviceCard(
    String title,
    bool active,
    IconData icon,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: boxDecoration(),
      child: Row(
        children: [
          Icon(
            icon,
            size: 32,
            color:
                active ? Colors.orange : Colors.grey,
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Text(
            active ? 'ACTIVE' : 'OFF',
            style: TextStyle(
              color:
                  active ? Colors.orange : Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // LOG CARD
  // ==========================================================

  Widget logCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: boxDecoration(),
      child: logs.isEmpty
          ? const Text(
              'No activity yet.',
              style: TextStyle(
                color: Colors.white54,
              ),
            )
          : Column(
              children: logs.map((log) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(
                    vertical: 6,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.circle,
                        size: 7,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          log,
                          style:
                              const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
    );
  }

  // ==========================================================
  // THRESHOLD CARD
  // ==========================================================

  Widget thresholdCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: boxDecoration(),
      child: const Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            'SAFETY THRESHOLDS',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 12),

          ThresholdRow(
            name: 'Cabin temperature',
            value: '> 35 °C',
          ),

          ThresholdRow(
            name: 'Engine temperature',
            value: '> 200 °C',
          ),

          ThresholdRow(
            name: 'Humidity',
            value: '> 70 %',
          ),

          ThresholdRow(
            name: 'Flame',
            value: 'DETECTED',
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // DECORATION
  // ==========================================================

  BoxDecoration boxDecoration() {
    return BoxDecoration(
      color: const Color(0xFF0B1A2C),
      borderRadius: BorderRadius.circular(18),
    );
  }
}

// ================================================================
// SECTION TITLE
// ================================================================

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

// ================================================================
// THRESHOLD ROW
// ================================================================

class ThresholdRow extends StatelessWidget {
  final String name;
  final String value;

  const ThresholdRow({
    super.key,
    required this.name,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const Icon(
            Icons.circle,
            size: 7,
            color: Colors.blue,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(name),
          ),

          Text(
            value,
            style: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}