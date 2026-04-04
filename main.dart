import 'package:flutter/material.dart';
import 'screens/auth/login_screen.dart';

void main() {
  runApp(const DreamAriseApp());
}

class DreamAriseApp extends StatelessWidget {
  const DreamAriseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DreamAriseLoginScreen(),
    );
  }
}