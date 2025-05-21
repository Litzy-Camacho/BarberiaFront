import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'reset_password_email.dart';
import 'create_account.dart';
import '../Clients/user_profile.dart';
import '../Login/session.dart';
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
  bool isButtonEnabled = false;
  bool _emailTouched = false;
bool _passwordTouched = false;


  @override
  void initState() {
    super.initState();
    emailController.addListener(_validateInputs);
    passwordController.addListener(_validateInputs);
  }

  void _validateInputs() {
  final email = emailController.text.trim();
  final password = passwordController.text;

  setState(() {
    emailError = (!_emailTouched || email.isEmpty || isValidEmail(email))
        ? ''
        : 'Correo inválido';
  });
}


  bool isValidEmail(String email) {
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');
    return regex.hasMatch(email);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: Stack(
      children: [
        // Imagen de fondo
        SizedBox.expand(
          child: Image.asset(
            'assets/imag/fondovertical.png',
            fit: BoxFit.cover,
          ),
        ),
        SafeArea(
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
  onTap: () {
    if (!_emailTouched) {
      setState(() {
        _emailTouched = true;
      });
    }
  },
),

                  const SizedBox(height: 20),
                  _LoginTextField(
  controller: passwordController,
  label: 'Contraseña',
  hintText: 'Ingresa tu contraseña',
  obscureText: true,
  onTap: () {
    if (!_passwordTouched) {
      setState(() {
        _passwordTouched = true;
      });
    }
  },
),

                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ResetPasswordPage(),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        child: const Text(
                          'Recuperar Contraseña',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      const Text(
                        ' / ',
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
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        child: const Text(
                          'Crear Cuenta',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  ),
  onPressed: () {
    setState(() {
      _emailTouched = true;
      _passwordTouched = true;
      _validateInputs(); // Para mostrar errores si los hay
    });

    String email = emailController.text.trim().toLowerCase();
    String password = passwordController.text;

    if (!isValidEmail(email) || password.isEmpty) return;

    Widget destination;
    String userRole;

    if (email == 'admin@gmail.com') {
      destination = const HomePage();
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
  final VoidCallback? onTap;

  const _LoginTextField({
    required this.label,
    required this.hintText,
    this.obscureText = false,
    required this.controller,
    this.errorText,
    this.onTap, 

  });

  @override
  _LoginTextFieldState createState() => _LoginTextFieldState();
}

class _LoginTextFieldState extends State<_LoginTextField> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
  }

  void _toggleVisibility() {
    setState(() {
      _obscure = !_obscure;
    });
  }

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
            obscureText: _obscure,
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
              suffixIcon: widget.obscureText
                  ? IconButton(
                      icon: Icon(
                        _obscure ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: _toggleVisibility,
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}


