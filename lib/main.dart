import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'W ASLA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.red, useMaterial3: true),
      home: const SplashScreen(),
    );
  }
}
