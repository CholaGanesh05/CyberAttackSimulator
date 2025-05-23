import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Attack Simulation App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _buttonController;
  late AnimationController _backgroundController;
  
  late Animation<double> _logoAnimation;
  late Animation<double> _textAnimation;
  late Animation<double> _buttonAnimation;
  late Animation<double> _backgroundAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controllers
    _logoController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );
    _textController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );
    _buttonController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _backgroundController = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    );

    // Initialize animations
    _logoAnimation = CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    );
    _textAnimation = CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOutBack,
    );
    _buttonAnimation = CurvedAnimation(
      parent: _buttonController,
      curve: Curves.bounceOut,
    );
    _backgroundAnimation = CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.linear,
    );
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * 3.14159,
    ).animate(_backgroundController);

    _startAnimationSequence();
  }

  void _startAnimationSequence() {
    // Start background animation immediately
    _backgroundController.repeat();
    
    // Logo animation
    Timer(Duration(milliseconds: 500), () {
      _logoController.forward();
    });
    
    // Text animation
    Timer(Duration(milliseconds: 2000), () {
      _textController.forward();
    });
    
    // Button animation
    Timer(Duration(milliseconds: 3000), () {
      _buttonController.forward();
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _buttonController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([_backgroundAnimation, _rotationAnimation]),
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.5 + _backgroundAnimation.value * 0.5,
                colors: [
                  Colors.red.withOpacity(0.15),
                  Colors.grey[900]!.withOpacity(0.8),
                  Colors.black,
                ],
              ),
            ),
            child: Stack(
              children: [
                // Animated background particles
                ...List.generate(20, (index) {
                  final angle = (index * 18.0) + (_rotationAnimation.value * 180 / 3.14159);
                  final radius = 150.0 + (index * 15);
                  return Positioned(
                    left: MediaQuery.of(context).size.width / 2 + 
                          (radius * 0.5) * (angle * 3.14159 / 180).cos() - 2,
                    top: MediaQuery.of(context).size.height / 2 + 
                         (radius * 0.3) * (angle * 3.14159 / 180).sin() - 2,
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.redAccent.withOpacity(0.3 - (index * 0.01)),
                      ),
                    ),
                  );
                }),
                
                // Main content
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Animated Logo with glow effect
                      ScaleTransition(
                        scale: _logoAnimation,
                        child: Container(
                          padding: EdgeInsets.all(30),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.redAccent.withOpacity(0.6),
                              width: 3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.redAccent.withOpacity(0.4),
                                blurRadius: 30,
                                spreadRadius: 8,
                              ),
                              BoxShadow(
                                color: Colors.redAccent.withOpacity(0.2),
                                blurRadius: 60,
                                spreadRadius: 15,
                              ),
                            ],
                          ),
                          child: AnimatedBuilder(
                            animation: _rotationAnimation,
                            builder: (context, child) {
                              return Transform.rotate(
                                angle: _rotationAnimation.value * 0.1,
                                child: Icon(
                                  Icons.shield,
                                  size: 90,
                                  color: Colors.redAccent,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      
                      SizedBox(height: 40),
                      
                      // Animated Welcome Text
                      SlideTransition(
                        position: Tween<Offset>(
                          begin: Offset(0, 1),
                          end: Offset.zero,
                        ).animate(_textAnimation),
                        child: FadeTransition(
                          opacity: _textAnimation,
                          child: Column(
                            children: [
                              Text(
                                'Welcome',
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 3.0,
                                  shadows: [
                                    Shadow(
                                      color: Colors.redAccent.withOpacity(0.5),
                                      blurRadius: 10,
                                      offset: Offset(0, 0),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'to the Simulation',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[400],
                                  letterSpacing: 1.5,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      SizedBox(height: 60),
                      
                      // Animated Button with hover effect
                      ScaleTransition(
                        scale: _buttonAnimation,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(35),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.redAccent.withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              HapticFeedback.heavyImpact();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                      SizedBox(width: 16),
                                      Text(
                                        'Initializing attack simulation...',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  backgroundColor: Colors.redAccent,
                                  duration: Duration(seconds: 3),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(horizontal: 45, vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(35),
                              ),
                              elevation: 0,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.play_arrow, size: 28),
                                SizedBox(width: 12),
                                Text(
                                  'Simulate Attack',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      
                      SizedBox(height: 40),
                      
                      // Animated subtitle
                      FadeTransition(
                        opacity: _buttonAnimation,
                        child: Text(
                          'Experience advanced cybersecurity scenarios',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

extension on double {
  double cos() => math.cos(this);
  double sin() => math.sin(this);
}

// Add math import
import 'dart:math' as math;
