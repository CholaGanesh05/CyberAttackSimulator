import 'package:flutter/material.dart';
import 'dart:async';
import 'end_screen.dart';

class FakeLinkScreen extends StatefulWidget {
  @override
  _FakeLinkScreenState createState() => _FakeLinkScreenState();
}

class _FakeLinkScreenState extends State<FakeLinkScreen> with SingleTickerProviderStateMixin {
  bool _showEndButton = false;
  late AnimationController _glitchController;

  @override
  void initState() {
    super.initState();
    _glitchController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
      lowerBound: -0.5,
      upperBound: 0.5,
    )..repeat();
    
    Timer(Duration(seconds: 10), () {
      setState(() => _showEndButton = true);
    });
  }

  @override
  void dispose() {
    _glitchController.dispose();
    super.dispose();
  }

  Widget _buildGlitchText(String text) {
    return AnimatedBuilder(
      animation: _glitchController,
      builder: (context, child) {
        return Stack(
          children: [
            Transform.translate(
              offset: Offset(_glitchController.value * 3, 0),
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.red.withOpacity(0.5),
                      blurRadius: 20,
                    ),
                  ],
                ),
              ),
            ),
            Text(
              text,
              style: TextStyle(
                color: Colors.red.shade100,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
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
            // Matrix rain background
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [Colors.black, Colors.transparent],
                stops: [0.5, 1.0],
              ).createShader(bounds),
              blendMode: BlendMode.dstIn,
              child: Opacity(
                opacity: 0.3,
                child: Image.asset('assets/matrix_rain.gif', fit: BoxFit.cover),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildGlitchText("⚠️ CRITICAL ERROR ⚠️"),
                  SizedBox(height: 30),
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: CircularProgressIndicator(
                      strokeWidth: 4,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                      backgroundColor: Colors.red.withOpacity(0.2),
                    ),
                  ),
                  SizedBox(height: 30),
                  if (_showEndButton)
                    TweenAnimationBuilder(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: Duration(seconds: 1),
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.scale(
                            scale: value,
                            child: child,
                          ),
                        );
                      },
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red.shade900,
                          onPrimary: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 10,
                          shadowColor: Colors.red.withOpacity(0.5),
                        ),
                        onPressed: () => Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            transitionDuration: Duration(milliseconds: 800),
                            pageBuilder: (_, __, ___) => EndScreen(),
                            transitionsBuilder: (_, a, __, c) => FadeTransition(
                              opacity: a,
                              child: c,
                            ),
                          ),
                        ),
                        child: Text("TERMINATE SIMULATION",
                            style: TextStyle(letterSpacing: 1.2)),
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