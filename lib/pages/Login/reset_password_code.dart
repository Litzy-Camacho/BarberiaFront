import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'reset_password_data.dart';
import 'reset_password_email.dart'; // Asegúrate de tener esta importación

class ResetPasswordPage2 extends StatefulWidget {
  const ResetPasswordPage2({super.key});

  @override
  State<ResetPasswordPage2> createState() => _ResetPasswordPage2State();
}

class _ResetPasswordPage2State extends State<ResetPasswordPage2> {
  final List<TextEditingController> _controllers =
      List.generate(5, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(5, (_) => FocusNode());
  bool _isCodeComplete = false;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < _controllers.length; i++) {
      _controllers[i].addListener(_validateCode);
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _validateCode() {
    final isComplete = _controllers.every((c) => c.text.trim().isNotEmpty);
    setState(() {
      _isCodeComplete = isComplete;
    });
  }

  void _showSuccessSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Código correcto'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 600) {
                return Row(
                  children: [
                    Expanded(
                      child: _buildForm(),
                    ),
                  ],
                );
              } else {
                return _buildForm();
              }
            },
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 16.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ResetPasswordPage()),
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
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Código de Seguridad',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 10),
              _SecurityCodeInput(
                controllers: _controllers,
                focusNodes: _focusNodes,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isCodeComplete
                      ? Colors.white
                      : Colors.grey.shade700,
                  foregroundColor:
                      _isCodeComplete ? Colors.black : Colors.white,
                  disabledBackgroundColor: Colors.grey.shade700,
                  disabledForegroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: _isCodeComplete
                    ? () {
                        _showSuccessSnackbar();
                        Future.delayed(const Duration(seconds: 2), () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const ResetPasswordPage3(),
                            ),
                          );
                        });
                      }
                    : null,
                child: const Text('Siguiente'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SecurityCodeInput extends StatelessWidget {
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;

  const _SecurityCodeInput({
    required this.controllers,
    required this.focusNodes,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return Container(
          width: 45,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          child: TextField(
            controller: controllers[index],
            focusNode: focusNodes[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            style: const TextStyle(fontSize: 20),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: InputDecoration(
              counterText: '',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (value) {
              if (value.isNotEmpty && index < 4) {
                FocusScope.of(context).requestFocus(focusNodes[index + 1]);
              } else if (value.isEmpty && index > 0) {
                FocusScope.of(context).requestFocus(focusNodes[index - 1]);
              }
            },
          ),
        );
      }),
    );
  }
}
