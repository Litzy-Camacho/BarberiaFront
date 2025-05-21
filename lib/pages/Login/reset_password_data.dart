import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'login.dart';

class ResetPasswordPage3 extends StatefulWidget {
  const ResetPasswordPage3({super.key});

  @override
  State<ResetPasswordPage3> createState() => _ResetPasswordPage3State();
}

class _ResetPasswordPage3State extends State<ResetPasswordPage3> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _showErrors = false;

  bool get doPasswordsMatch => _passwordController.text == _confirmPasswordController.text;
  bool get isPasswordValid =>
      _passwordController.text.isNotEmpty &&
      _passwordController.text.length >= 8 &&
      RegExp(r'[A-Z]').hasMatch(_passwordController.text) &&
      RegExp(r'[a-z]').hasMatch(_passwordController.text) &&
      RegExp(r'\d').hasMatch(_passwordController.text) &&
      RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(_passwordController.text);

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    body: Stack(
      children: [
        SizedBox.expand(
          child: Image.asset(
            'assets/imag/fondovertical.png',
            fit: BoxFit.cover,
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                // Fila con flecha y texto "Regresar"
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPage()),
                        );
                      },
                    ),
                    const Text(
                      'Regresar',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Contenido centrado
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _RegisterTextField(
                            label: 'Contraseña',
                            hintText: 'Ingresa una contraseña',
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            onChanged: (_) => setState(() {}),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          PasswordCriteriaWidget(password: _passwordController.text),
                          if (_showErrors && !isPasswordValid)
                            const Padding(
                              padding: EdgeInsets.only(top: 4),
                              child: Text(
                                'La contraseña no cumple con los requisitos.',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          const SizedBox(height: 20),

                          _RegisterTextField(
                            label: 'Confirmar Contraseña',
                            hintText: 'Confirma tu contraseña',
                            controller: _confirmPasswordController,
                            obscureText: _obscureConfirmPassword,
                            onChanged: (_) => setState(() {}),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmPassword = !_obscureConfirmPassword;
                                });
                              },
                            ),
                          ),
                          if (_showErrors && !doPasswordsMatch)
                            const Padding(
                              padding: EdgeInsets.only(top: 4),
                              child: Text(
                                'Las contraseñas no coinciden.',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          const SizedBox(height: 30),

                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            ),
                            onPressed: () {
                              setState(() => _showErrors = true);

                              if (isPasswordValid && doPasswordsMatch) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Contraseña cambiada'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => const LoginPage()),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Por favor corrige los campos marcados.'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                            child: const Text('Cambiar Contraseña'),
                          ),
                        ],
                      ),
                    ),
                  ),
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

class _RegisterTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final Widget? suffixIcon;

  const _RegisterTextField({
    required this.label,
    required this.hintText,
    required this.controller,
    this.obscureText = false,
    this.onChanged,
    this.suffixIcon,
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
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          ),
        ),
      ],
    );
  }
}

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
        Icon(met ? Icons.check_circle : Icons.cancel, color: met ? Colors.green : Colors.grey, size: 18),
        const SizedBox(width: 8),
        Text(text, style: TextStyle(color: met ? Colors.green : Colors.white, fontSize: 14)),
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
