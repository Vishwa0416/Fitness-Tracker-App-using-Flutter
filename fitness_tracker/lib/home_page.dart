import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Stream<StepCount> _stepCountStream;
  int _steps = 0;

  double get distance => _steps * 0.78 / 1000;
  double get calories => _steps * 0.04;

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  void _requestPermission() async {
    if (await Permission.activityRecognition.request().isGranted) {
      _startListening();
    } else {
      print("Permission not granted");
    }
  }

  void _startListening() {
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(
      _onStepCount,
      onError: _onStepCountError,
      cancelOnError: true,
    );
  }

  void _onStepCount(StepCount event) {
    setState(() {
      _steps = event.steps;
    });
  }

  void _onStepCountError(error) {
    print('Step Count Error: $error');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fitness Tracker')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildStatCard("👣 Steps", _steps.toString()),
            _buildStatCard("🔥 Calories Burnt", calories.toStringAsFixed(2) + " kcal"),
            _buildStatCard("📏 Distance", distance.toStringAsFixed(2) + " km"),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(label, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        trailing: Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
