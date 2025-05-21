import 'package:flutter/material.dart';
import 'login.dart';
import 'reset_password_code.dart'; // Asegúrate de tener esta importación

class ResetPasswordPage3 extends StatefulWidget {
  const ResetPasswordPage3({super.key});

  @override
  _ResetPasswordPage3State createState() => _ResetPasswordPage3State();
}

class _ResetPasswordPage3State extends State<ResetPasswordPage3> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    String newPassword = _newPasswordController.text;
    String confirmPassword = _confirmPasswordController.text;

    bool isPasswordValid = newPassword == confirmPassword && newPassword.isNotEmpty;
    bool showMismatchError = confirmPassword.isNotEmpty && newPassword != confirmPassword;

    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C),
      body: Stack(
        children: [
          SizedBox.expand(
          child: Image.asset(
            'assets/imag/fondovertical.png',
            fit: BoxFit.cover,
          ),
        ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),

                  // Campo Nueva Contraseña
                  _ResetPasswordTextField(
                    controller: _newPasswordController,
                    label: 'Ingresa tu Nueva Contraseña',
                    hintText: 'Nueva Contraseña',
                    obscureText: _obscureNewPassword,
                    onTap: () {
                      setState(() {
                        _obscureNewPassword = !_obscureNewPassword;
                      });
                    },
                    onChanged: (text) {
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 10),
                  PasswordCriteriaWidget(password: newPassword),
                  const SizedBox(height: 40),

                  // Campo Confirmar Contraseña
                  _ResetPasswordTextField(
                    controller: _confirmPasswordController,
                    label: 'Confirma tu Contraseña',
                    hintText: 'Confirmar Contraseña',
                    obscureText: _obscureConfirmPassword,
                    onTap: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                    onChanged: (text) {
                      setState(() {});
                    },
                  ),

                  if (showMismatchError)
                    const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Las contraseñas no coinciden',
                          style: TextStyle(color: Colors.red, fontSize: 14),
                        ),
                      ),
                    ),

                  const SizedBox(height: 40),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isPasswordValid ? Colors.white : Colors.grey.shade700,
                      foregroundColor: isPasswordValid ? Colors.black : Colors.white,
                      disabledBackgroundColor: Colors.grey.shade700,
                      disabledForegroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: isPasswordValid
                        ? () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Contraseña cambiada exitosamente'),
                                backgroundColor: Colors.green,
                              ),
                            );
                            Future.delayed(const Duration(seconds: 2), () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => const LoginPage()),
                              );
                            });
                          }
                        : null,
                    child: const Text('Enviar'),
                  ),
                ],
              ),
            ),
          ),

          // Flecha de regreso
          // Flecha de regreso con texto "Regresar"
Positioned(
  top: 40,
  left: 10,
  child: GestureDetector(
    onTap: () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ResetPasswordPage2()),
      );
    },
    child: Row(
      children: const [
        Icon(Icons.arrow_back, color: Colors.white),
        SizedBox(width: 5),
        Text(
          'Regresar',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ],
    ),
  ),
),

        ],
      ),
    );
  }
}

// Widget personalizado para el campo de contraseña
class _ResetPasswordTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final bool obscureText;
  final VoidCallback onTap;
  final ValueChanged<String> onChanged;

  const _ResetPasswordTextField({
    required this.controller,
    required this.label,
    required this.hintText,
    this.obscureText = false,
    required this.onTap,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 16)),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          obscureText: obscureText,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            suffixIcon: IconButton(
              icon: Icon(
                obscureText ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
              ),
              onPressed: onTap,
            ),
          ),
        ),
      ],
    );
  }
}

// Widget para mostrar los criterios de la contraseña
class PasswordCriteriaWidget extends StatelessWidget {
  final String password;

  const PasswordCriteriaWidget({super.key, required this.password});

  bool get hasMinLength => password.length >= 8;
  bool get hasUppercase => password.contains(RegExp(r'[A-Z]'));
  bool get hasLowercase => password.contains(RegExp(r'[a-z]'));
  bool get hasNumber => password.contains(RegExp(r'\d'));
  bool get hasSpecial => password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

  Widget _buildCriteriaRow(String text, bool met) {
    return Row(
      children: [
        Icon(
          met ? Icons.check_circle : Icons.cancel,
          color: met ? Colors.green : Colors.grey,
          size: 18,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(color: met ? Colors.green : Colors.white, fontSize: 14),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCriteriaRow("Mínimo 8 caracteres", hasMinLength),
        _buildCriteriaRow("Mayúsculas", hasUppercase),
        _buildCriteriaRow("Minúsculas", hasLowercase),
        _buildCriteriaRow("Números", hasNumber),
        _buildCriteriaRow("Caracteres especiales", hasSpecial),
      ],
    );
  }
}
