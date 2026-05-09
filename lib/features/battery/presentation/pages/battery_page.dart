import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BatteryPage extends StatefulWidget {
  const BatteryPage({super.key});

  @override
  State<BatteryPage> createState() => _BatteryPageState();
}

class _BatteryPageState extends State<BatteryPage> {
  static const platform = MethodChannel('battery_channel');

  String battery = "Unknown";

  Future<void> getBattery() async {
    final result = await platform.invokeMethod('getBatteryLevel');

    setState(() {
      battery = "$result%";
    });
  }

  Future<void> showNativeToast() async {
    await platform.invokeMethod('showToast');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Battery & Native")),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            const Icon(Icons.battery_full, size: 100, color: Colors.green),

            const SizedBox(height: 20),

            Text(
              "Battery: $battery",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                getBattery();
              },

              child: const Text("Cek Baterai anda"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                showNativeToast();
              },

              child: const Text("Show Native Toast"),
            ),
          ],
        ),
      ),
    );
  }
}
