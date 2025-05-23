import 'package:flutter/material.dart';
import 'features/sms_scam/sms_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scam Simulator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        textTheme: TextTheme(
          headline4: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
          bodyText2: TextStyle(
            fontSize: 16,
            height: 1.4,
          ),
        ),
      ),
      home: SmsScreen(),
    );
  }
}