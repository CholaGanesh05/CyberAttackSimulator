import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

class EndScreen extends StatefulWidget {
  @override
  _EndScreenState createState() => _EndScreenState();
}

class _EndScreenState extends State<EndScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: Duration(seconds: 5));
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black, Colors.blue.shade900],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.security, size: 100, color: Colors.greenAccent),
                SizedBox(height: 30),
                Text("SYSTEM SECURED",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.greenAccent,
                      shadows: [
                        Shadow(
                          color: Colors.white,
                          blurRadius: 20,
                        ),
                      ],
                    )),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    "Simulation successfully terminated. Remember:\n"
                    "1. Never share personal details\n"
                    "2. Verify suspicious messages\n"
                    "3. Use two-factor authentication",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green.shade900,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    shape: StadiumBorder(),
                    elevation: 10,
                  ),
                  onPressed: () => Navigator.popUntil(
                      context, (route) => route.isFirst),
                  child: Text("RESTART SIMULATION",
                      style: TextStyle(letterSpacing: 1.5)),
                ),
              ],
            ),
          ),
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: -1,
            emissionFrequency: 0.05,
            numberOfParticles: 30,
            gravity: 0.1,
            colors: [Colors.greenAccent, Colors.blueAccent, Colors.white],
          ),
        ],
      ),
    );
  }
}
