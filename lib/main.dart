import 'package:flutter/material.dart';
import 'pages/Home/home_page.dart';
import 'pages/Services/services_screen_admin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Quita la banderita de debug
      title: 'Barbería',
      home: ServicesScreenAdmin(), // HomePage como pantalla principal
    );
  }
}
