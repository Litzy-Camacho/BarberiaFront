import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'reset_password_page.dart';
import 'register_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // IZQUIERDA: Imagen
          Expanded(
            flex: 1,
            child: Image.asset(
              'assets/imag/1.png', // Ruta de la imagen
              fit: BoxFit.cover,
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
                      // Botones Iniciar Sesión / Registrarse
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _LoginButton(
                            title: 'Iniciar Sesión',
                            onPressed: () {
                              // Actualmente estamos en login, no hacemos nada
                            },
                          ),
                          const SizedBox(width: 20),
                          _LoginButton(
                            title: 'Registrarse',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegisterPage(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),

                      // Formulario
                      _LoginTextField(
                        label: 'Correo',
                        hintText: 'Ingresa tu correo',
                      ),
                      const SizedBox(height: 20),
                      _LoginTextField(
                        label: 'Contraseña',
                        hintText: 'Ingresa tu contraseña',
                        obscureText: true,
                      ),
                      const SizedBox(height: 10),

                      // Olvidaste contraseña
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ResetPasswordPage(),
                              ),
                            );
                          },
                          child: const Text(
                            '¿Olvidaste tu contraseña?',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Botón Confirmar
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          // Acción de iniciar sesión
                        },
                        child: const Text('Confirmar'),
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

// Widget botón Iniciar sesión / Registrarse
class _LoginButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed; //Agregado

  const _LoginButton({required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.white),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      onPressed: onPressed,
      child: Text(title),
    );
  }
}

// Widget campos de texto
class _LoginTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final bool obscureText;

  const _LoginTextField({
    required this.label,
    required this.hintText,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 16)),
        const SizedBox(height: 5),
        TextField(
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ),
          ),
        ),
      ],
    );
  }
}
