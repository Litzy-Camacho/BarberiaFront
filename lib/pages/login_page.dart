import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'reset_password_page.dart';
import 'user.dart';
import 'barber.dart';
import 'admin.dart';
import 'register_page.dart';
import 'user_page.dart'; // Asegúrate de que la ruta sea correcta
import 'dart:core';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String emailError = '';
  bool isPasswordEmpty = true;

  // Función para validar el correo
  bool isValidEmail(String email) {
    // Expresión regular para validar el formato del correo
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');
    return regex.hasMatch(email);
  }

  @override
  void initState() {
    super.initState();
    passwordController.addListener(() {
      setState(() {
        isPasswordEmpty = passwordController.text.isEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // IZQUIERDA: Imagen
          Expanded(
            flex: 1,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/imag/login.jpg',
                  fit: BoxFit.cover,
                ),
                Container(
                  color: Colors.black.withOpacity(0.5), // Cambia el valor según la intensidad que desees
                ),
              ],
            ),
          ),

          // DERECHA: Formulario
          Expanded(
            flex: 1,
            child: Container(
              color: const Color(0xFF1C1C1C), // Fondo negro-grisáceo
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Formulario
                      _LoginTextField(
                        controller: emailController,
                        label: 'Correo',
                        hintText: 'Ingresa tu correo',
                        errorText: emailError,
                      ),
                      const SizedBox(height: 20),
                      _LoginTextField(
                        controller: passwordController,
                        label: 'Contraseña',
                        hintText: 'Ingresa tu contraseña',
                        obscureText: true,
                      ),
                      const SizedBox(height: 10),

                      // Pregunta y enlace "Recuperar" al lado
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            '¿Olvidaste tu contraseña?',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ResetPasswordPage(),
                                ),
                              );
                            },
                            child: const Text(
                              'Recuperar',
                              style: TextStyle(
                                color: Colors.blue, // Azul
                                fontSize: 14,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Texto de "¿No tienes cuenta? Regístrate"
                      Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              '¿No tienes cuenta?',
                              style: TextStyle(color: Colors.white, fontSize: 14),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const RegisterPage(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Regístrate',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 14,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Botón Confirmar
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isPasswordEmpty
                                ? Colors.grey.shade700 // Si la contraseña está vacía, gris
                                : Colors.white, // Si no está vacía, blanco
                            foregroundColor: isPasswordEmpty
                                ? Colors.white // Si la contraseña está vacía, texto blanco
                                : Colors.black, // Si no está vacía, texto negro
                            disabledBackgroundColor: Colors.grey.shade700, // Gris para deshabilitado
                            disabledForegroundColor: Colors.white, // Texto blanco para deshabilitado
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                          onPressed: isPasswordEmpty
                              ? null // Deshabilitado si la contraseña está vacía
                              : () {
                                  String email = emailController.text.trim().toLowerCase();

                                  if (!isValidEmail(email)) {
                                    setState(() {
                                      emailError = 'Correo inválido';
                                    });
                                    return;
                                  }

                                  Widget destination;

                                  if (email == 'admin@gmail.com') {
                                    destination = const HomePageAdmin();
                                  } else if (email == 'barber@gmail.com') {
                                    destination = const HomePageBarber();
                                  } else if (email == 'user@gmail.com') {
                                    destination = const HomePageUser();
                                  } else {
                                    setState(() {
                                      emailError = 'Correo no reconocido';
                                    });
                                    return;
                                  }

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => destination),
                                  );
                                },
                          child: const Text('Confirmar'),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Divider (Línea abajo para ver las opciones de google/github)
                      Row(
                        children: const [
                          Expanded(child: Divider(color: Colors.white)),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              'O inicia sesión con',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Expanded(child: Divider(color: Colors.white)),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Botones sociales
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            FontAwesomeIcons.google,
                            color: Colors.white,
                            size: 30,
                          ),
                          SizedBox(width: 30),
                          Icon(
                            FontAwesomeIcons.github,
                            color: Colors.white,
                            size: 30,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginTextField extends StatefulWidget {
  final String label;
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  final String? errorText;

  const _LoginTextField({
    required this.label,
    required this.hintText,
    this.obscureText = false,
    required this.controller,
    this.errorText,
  });

  @override
  _LoginTextFieldState createState() => _LoginTextFieldState();
}

class _LoginTextFieldState extends State<_LoginTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: const TextStyle(color: Colors.white, fontSize: 16)),
        const SizedBox(height: 5),
        // Campo de texto sin efectos de hover
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: widget.controller,
            obscureText: widget.obscureText,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              errorText: widget.errorText,
            ),
          ),
        ),
      ],
    );
  }
}



