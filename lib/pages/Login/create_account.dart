import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'login.dart';
import 'reset_password_code.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _showErrors = false;

  bool get isNameValid => RegExp(r'^[a-zA-Z\s]+$').hasMatch(_nameController.text);
  bool get isPhoneValid => RegExp(r'^\d{10}$').hasMatch(_phoneController.text);
  bool get isEmailValid => RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(_emailController.text);
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
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Botón de regreso
                    Row(
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

                    _RegisterTextField(
                      label: 'Nombre',
                      hintText: 'Ingresa tu nombre completo',
                      controller: _nameController,
                      onChanged: (_) => setState(() {}),
                    ),
                    if (_showErrors && !isNameValid)
                      const Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Text(
                          'El nombre solo debe contener letras.',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),

                    const SizedBox(height: 20),

                    _RegisterTextField(
                      label: 'Teléfono',
                      hintText: 'Ingresa tu número de teléfono',
                      controller: _phoneController,
                      onChanged: (_) => setState(() {}),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                    ),
                    if (_showErrors && !isPhoneValid)
                      const Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Text(
                          'El teléfono debe tener 10 dígitos.',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),

                    const SizedBox(height: 20),

                    _RegisterTextField(
                      label: 'Correo',
                      hintText: 'Ingresa un correo',
                      controller: _emailController,
                      onChanged: (_) => setState(() {}),
                    ),
                    if (_showErrors && !isEmailValid)
                      const Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Text(
                          'El correo no es válido.',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),

                    const SizedBox(height: 20),

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
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: PasswordCriteriaWidget(password: _passwordController.text),
                    ),
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

                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        onPressed: () {
                          setState(() {
                            _showErrors = true;
                          });

                          if (isNameValid && isPhoneValid && isEmailValid && isPasswordValid && doPasswordsMatch) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('¡Registro exitoso!'),
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
                        child: const Text('Crear Cuenta'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget campo de texto
class _RegisterTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  const _RegisterTextField({
    required this.label,
    required this.hintText,
    required this.controller,
    this.obscureText = false,
    this.onChanged,
    this.suffixIcon,
    this.keyboardType,
    this.inputFormatters,
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
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
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

// Widget criterios de contraseña
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
