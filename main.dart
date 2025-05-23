import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'simulation_screen.dart';
import 'analysis_screen.dart';
import 'prevention_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scam Simulator',
      theme: ThemeData.dark(),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _simulationCompleted = false;

  void _startSimulation() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SimulationScreen()),
    ).then((value) => setState(() => _simulationCompleted = true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Scam Simulator')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!_simulationCompleted)
              ElevatedButton(
                onPressed: _startSimulation,
                child: Text('Start Simulation', style: TextStyle(fontSize: 24)),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                ),
              ),
            if (_simulationCompleted) _buildPostSimulationOptions(),
          ],
        ),
      ),
    );
  }

  Widget _buildPostSimulationOptions() {
    return Column(
      children: [
        OpenContainer(
          closedBuilder: (_, openContainer) => _buildOptionCard(
            'Attack Analysis',
            Icons.security,
            Colors.red,
          ),
          openBuilder: (_, closeContainer) => AnalysisScreen(),
        ),
        SizedBox(height: 20),
        OpenContainer(
          closedBuilder: (_, openContainer) => _buildOptionCard(
            'Preventive Measures',
            Icons.shield,
            Colors.green,
          ),
          openBuilder: (_, closeContainer) => PreventionScreen(),
        ),
      ],
    );
  }

  Widget _buildOptionCard(String title, IconData icon, Color color) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        padding: EdgeInsets.all(20),
        width: 250,
        child: Row(
          children: [
            Icon(icon, size: 40, color: color),
            SizedBox(width: 20),
            Text(title, style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}