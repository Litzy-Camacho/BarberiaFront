import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'reset_password_data.dart';

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
    for (var controller in _controllers) {
      controller.addListener(_validateCode);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C),  // Color de fondo del Scaffold
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Si el ancho es mayor a 600, se muestra el formulario de lado a lado
          if (constraints.maxWidth > 600) {
            return Row(
              children: [
                // DERECHA: Formulario
                Expanded(
                  child: _buildForm(),
                ),
              ],
            );
          } else {
            // Si el ancho es menor o igual a 600, se muestra solo el formulario
            return _buildForm();
          }
        },
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
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ResetPasswordPage3(),
                          ),
                        );
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

// Widget con 5 cuadros de entrada numérica
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
              }
            },
          ),
        );
      }),
    );
  }
}
