import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Easy Parkir',

      theme: ThemeData(
        primaryColor: const Color(0xff0D93B0),
        scaffoldBackgroundColor: const Color(0xffF5F7FA),
        useMaterial3: true,
      ),

      home: const LoginScreen(),
    );
  }
}
