import 'package:flutter/material.dart';
import 'pages/Home/home_page.dart';
import './pages/Barber/barber_profile.dart';
import './pages/Administrator/admin_profile.dart';

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
      home: PantallaBarbero(), // HomePage como pantalla principal
    );
  }
}
