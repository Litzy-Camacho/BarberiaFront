import 'package:flutter/material.dart';
import 'pages/home_page.dart'; // Importa el HomePage

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
      home: const HomePage(), // HomePage como pantalla principal
    );
  }
}
