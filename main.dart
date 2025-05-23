import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'features/sms_scam/sms_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scam Simulator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'RobotoMono',
        scaffoldBackgroundColor: Colors.black,
        textTheme: TextTheme(
          headline4: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            color: Colors.white,
          ),
          bodyText2: TextStyle(
            fontSize: 16,
            height: 1.4,
            color: Colors.white70,
          ),
        ),
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            TargetPlatform.android: SharedAxisPageTransitionsBuilder(
              transitionType: SharedAxisTransitionType.vertical,
            ),
            TargetPlatform.iOS: SharedAxisPageTransitionsBuilder(
              transitionType: SharedAxisTransitionType.vertical,
            ),
          },
        ),
      ),
      home: SmsScreen(),
    );
  }
}
