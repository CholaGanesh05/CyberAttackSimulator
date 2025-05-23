import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

class SimulationScreen extends StatefulWidget {
  @override
  _SimulationScreenState createState() => _SimulationScreenState();
}

class _SimulationScreenState extends State<SimulationScreen>
    with SingleTickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _animationController;
  int _currentEffect = 0;
  bool _showReboot = false;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: Duration(seconds: 1));
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 30),
    )..forward();
    
    _startSimulation();
  }

  void _startSimulation() async {
    // Glitch phase
    for (int i = 0; i < 15; i++) {
      await Future.delayed(Duration(milliseconds: 200));
      setState(() => _currentEffect = i % 3);
    }

    // Fake reboot sequence
    setState(() => _showReboot = true);
    await Future.delayed(Duration(seconds: 5));
    
    // Show end button
    _confettiController.play();
  }

  Widget _buildGlitchEffect() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 100),
      decoration: BoxDecoration(
        color: [
          Colors.red.withOpacity(0.3),
          Colors.blue.withOpacity(0.3),
          Colors.green.withOpacity(0.3)
        ][_currentEffect % 3],
      ),
      child: CustomPaint(
        painter: GlitchPainter(_currentEffect),
      ),
    );
  }

  Widget _buildRebootScreen() {
    return Container(
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.white),
          SizedBox(height: 20),
          Text('SYSTEM REBOOTING...', style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold
          )),
          Text('Do not turn off your device', 
            style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (!_showReboot) _buildGlitchEffect(),
          if (_showReboot) _buildRebootScreen(),
          
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                emissionFrequency: 0.1,
                numberOfParticles: 20,
              ),
            ),
          ),
          
          if (_showReboot)
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('End Simulation', style: TextStyle(fontSize: 24)),
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20)),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}

class GlitchPainter extends CustomPainter {
  final int seed;

  GlitchPainter(this.seed);

  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(seed);
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke;

    // Draw random glitch lines
    for (int i = 0; i < 100; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final dx = random.nextDouble() * 20 - 10;
      final dy = random.nextDouble() * 20 - 10;
      
      canvas.drawLine(
        Offset(x, y),
        Offset(x + dx, y + dy),
        paint..strokeWidth = random.nextDouble() * 3,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}