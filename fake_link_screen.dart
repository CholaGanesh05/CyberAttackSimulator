import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'dart:async';
import 'end_screen.dart';

class FakeLinkScreen extends StatefulWidget {
  @override
  _FakeLinkScreenState createState() => _FakeLinkScreenState();
}

class _FakeLinkScreenState extends State<FakeLinkScreen> with TickerProviderStateMixin {
  late AnimationController _glitchController;
  late AnimationController _hackController;
  bool _showEndButton = false;

  @override
  void initState() {
    super.initState();
    _glitchController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 50),
    )..repeat();
    
    _hackController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    )..forward();

    Timer(Duration(seconds: 10), () => setState(() => _showEndButton = true));
  }

  @override
  void dispose() {
    _glitchController.dispose();
    _hackController.dispose();
    super.dispose();
  }

  Widget _buildGlitchText(String text) {
    return AnimatedBuilder(
      animation: _glitchController,
      builder: (context, child) {
        return Stack(
          children: [
            Transform.translate(
              offset: Offset((sin(_glitchController.value * 20) * 3, 0),
              child: Text(text,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 28,
                    shadows: [
                      Shadow(
                        color: Colors.red.withOpacity(0.5),
                        blurRadius: 20,
                      ),
                    ],
                  )),
            ),
            Transform.translate(
              offset: Offset(0, (cos(_glitchController.value * 20) * 2)),
              child: Text(text,
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 28,
                    shadows: [
                      Shadow(
                        color: Colors.green.withOpacity(0.3),
                        blurRadius: 15,
                      ),
                    ],
                  )),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            AnimatedBuilder(
              animation: _hackController,
              builder: (context, child) {
                return CustomPaint(
                  painter: MatrixPainter(_hackController.value),
                  size: Size.infinite,
                );
              },
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildGlitchText("🛑 SYSTEM BREACHED 🛑"),
                  SizedBox(height: 40),
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: LiquidCircularProgressIndicator(
                      value: _hackController.value,
                      valueColor: AlwaysStoppedAnimation(Colors.red),
                      backgroundColor: Colors.black,
                      borderColor: Colors.red,
                      borderWidth: 2,
                      direction: Axis.vertical,
                      center: AnimatedCountup(
                        begin: 0,
                        end: 100,
                        duration: Duration(seconds: 10),
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  if (_showEndButton)
                    ScaleTransition(
                      scale: CurvedAnimation(
                        parent: _hackController,
                        curve: Curves.elasticOut,
                      ),
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.emergency),
                        label: Text("EMERGENCY SHUTDOWN"),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red.shade900,
                          onPrimary: Colors.white,
                          shape: StadiumBorder(),
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 20),
                          shadowColor: Colors.red,
                          elevation: 15,
                        ),
                        onPressed: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => EndScreen()),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MatrixPainter extends CustomPainter {
  final double progress;

  MatrixPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final random = Random(DateTime.now().millisecond);
    
    for (int i = 0; i < 100 * progress; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      canvas.drawLine(
        Offset(x, y),
        Offset(x, y + 30),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) =>
