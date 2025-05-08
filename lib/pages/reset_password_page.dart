import 'package:flutter/material.dart';

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // IZQUIERDA: Imagen
          Expanded(
            flex: 1,
            child: Image.asset(
              'assets/imag/1.png', // Imagen de lado izquierdo Recuperar Contraseña
              fit: BoxFit.cover,
            ),
          ),

          // DERECHA: Formulario
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
                      _ResetPasswordTextField(
                        label: 'Contraseña',
                        hintText: 'Ingresa una contraseña',
                        obscureText: true,
                      ),
                      const SizedBox(height: 20),
                      _ResetPasswordTextField(
                        label: 'Confirma tu contraseña',
                        hintText: 'Confirma una contraseña',
                        obscureText: true,
                      ),
                      const SizedBox(height: 20),
                      _ResetPasswordTextField(
                        label: 'Código',
                        hintText: 'Ingresa el código',
                      ),
                      const SizedBox(height: 40),

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
                          // Acción al confirmar (agregar validaciones)
                          Navigator.pop(
                            context,
                          ); // Regresar a LoginPage después
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

// Widget campos de texto para Reset Password
class _ResetPasswordTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final bool obscureText;

  const _ResetPasswordTextField({
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
