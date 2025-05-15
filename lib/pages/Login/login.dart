import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'reset_password_email.dart';
import 'create_account.dart';
import '../Clients/user_profile.dart';
import '../Login/session.dart'; // Asegúrate de crear este archivo con la clase Session
import '../Home/home_page.dart';

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

  bool isValidEmail(String email) {
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
      backgroundColor: const Color(0xFF1C1C1C),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _LoginTextField(
                  controller: emailController,
                  label: 'Correo',
                  hintText: 'Ingresa tu correo',
                  errorText: emailError.isEmpty ? null : emailError,
                ),
                const SizedBox(height: 20),
                _LoginTextField(
                  controller: passwordController,
                  label: 'Contraseña',
                  hintText: 'Ingresa tu contraseña',
                  obscureText: true,
                ),
                const SizedBox(height: 10),

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
                          color: Colors.blue,
                          fontSize: 14,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),

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

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isPasswordEmpty ? Colors.grey.shade700 : Colors.white,
                    foregroundColor: isPasswordEmpty ? Colors.white : Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  onPressed: isPasswordEmpty
                      ? null
                      : () {
                          String email = emailController.text.trim().toLowerCase();

                          if (!isValidEmail(email)) {
                            setState(() {
                              emailError = 'Correo inválido';
                            });
                            return;
                          }

                          Widget destination;
                          String userRole;

                          if (email == 'admin@gmail.com') {
                            destination = const HomePage(); // Igual que user
                            userRole = 'admin';
                          } else if (email == 'barber@gmail.com') {
                            destination = const HomePage();
                            userRole = 'barber';
                          } else if (email == 'user@gmail.com') {
                            destination = const HomePage();
                            userRole = 'user';
                          } else {
                            setState(() {
                              emailError = 'Correo no reconocido';
                            });
                            return;
                          }

                          // Guardar email y rol en sesión
                          Session.email.value = email;
                          Session.role.value = userRole;

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => destination),
                          );
                        },
                  child: const Text('Confirmar'),
                ),
                const SizedBox(height: 20),

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

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(FontAwesomeIcons.google, color: Colors.white, size: 30),
                    SizedBox(width: 30),
                    Icon(FontAwesomeIcons.github, color: Colors.white, size: 30),
                  ],
                ),
              ],
            ),
          ),
        ),
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
