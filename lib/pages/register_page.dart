import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // IZQUIERDA: Imagen
          Expanded(
            flex: 1,
            child: Image.asset(
              'assets/imag/1.png', //Imagen izquierda para el registro
              fit: BoxFit.cover,
            ),
          ),

          // DERECHA: Formulario de Registro
          Expanded(
            flex: 1,
            child: Container(
              color: const Color(0xFF1C1C1C),
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
                          _HeaderButton(
                            title: 'Iniciar Sesión',
                            onPressed: () {
                              Navigator.pop(context); //Volver al login
                            },
                          ),
                          const SizedBox(width: 20),
                          _HeaderButton(title: 'Registrarse', onPressed: () {}),
                        ],
                      ),
                      const SizedBox(height: 40),

                      // Campos de Registro
                      _RegisterTextField(
                        label: 'Nombre',
                        hintText: 'Ingresa tu nombre completo',
                      ),
                      const SizedBox(height: 20),
                      _RegisterTextField(
                        label: 'Correo',
                        hintText: 'Ingresa un correo',
                      ),
                      const SizedBox(height: 20),
                      _RegisterTextField(
                        label: 'Contraseña',
                        hintText: 'Ingresa una contraseña',
                        obscureText: true,
                      ),
                      const SizedBox(height: 20),
                      _RegisterTextField(
                        label: 'Confirmar Contraseña',
                        hintText: 'Confirma tu contraseña',
                        obscureText: true,
                      ),
                      const SizedBox(height: 30),

                      // Botón Confirmar Registro
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
                          // Acción de registrar aquí
                        },
                        child: const Text('Confirmar'),
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

// Botones superiores
class _HeaderButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const _HeaderButton({required this.title, required this.onPressed});

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

// Campos de texto
class _RegisterTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final bool obscureText;

  const _RegisterTextField({
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
