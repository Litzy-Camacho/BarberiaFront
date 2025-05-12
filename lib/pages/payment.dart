import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home_page.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _expiryDateCtrl = TextEditingController();

  List<TextEditingController> _cardDigitsControllers = List.generate(16, (_) => TextEditingController());

  @override
  void dispose() {
    _nameCtrl.dispose();
    _expiryDateCtrl.dispose();
    for (var controller in _cardDigitsControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // Mostrar notificación en la parte inferior
      final messenger = ScaffoldMessenger.of(context);
      messenger.showSnackBar(
        SnackBar(
          content: const Text(
            'Pago procesado con éxito!',
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
      
      // Redirigir a la página de inicio
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      });
    }
  }

  // Función para el comportamiento automático de pasar al siguiente campo
  void _onCardDigitChanged(int index, String value) {
    if (value.isNotEmpty && index < 15) {
      FocusScope.of(context).nextFocus();
    }
  }

  // Validación para la fecha de expiración MM/AA
  String? _expiryDateValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Requerido';
    }

    // Asegurarse que sea el formato MM/AA
    RegExp regExp = RegExp(r'^(0[1-9]|1[0-2])\/(25|26|27|28|29|30|31|32|33|34|35|36|37|38|39|40)$');
    if (!regExp.hasMatch(value)) {
      return 'Fecha no válida. Usa el formato MM/AA';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // Verifica si algún campo está vacío
    bool isButtonDisabled = _nameCtrl.text.isEmpty ||
        _expiryDateCtrl.text.isEmpty ||
        _cardDigitsControllers.any((controller) => controller.text.isEmpty);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Row(
        children: [
          // Imagen izquierda
          Expanded(
            flex: 1,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/imag/reservar.jpg',
                  fit: BoxFit.cover,
                ),
                Container(
                  color: Colors.black.withOpacity(0.5),
                ),
              ],
            ),
          ),
          // Formulario derecha
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
              color: Colors.black,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Nombre', style: TextStyle(color: Colors.white)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _nameCtrl,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'Ingresa tu nombre completo',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[a-zA-Z\\s]')),
                      ],
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'Requerido';
                        }
                        if (RegExp(r'[0-9]').hasMatch(v)) {
                          return 'No se permiten números';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text('Número de tarjeta', style: TextStyle(color: Colors.white)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(16, (index) {
                        return SizedBox(
                          width: 35,
                          child: TextFormField(
                            controller: _cardDigitsControllers[index],
                            style: const TextStyle(color: Colors.black),
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onChanged: (value) => _onCardDigitChanged(index, value),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 20),
                    const Text('Fecha de expiración', style: TextStyle(color: Colors.white)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _expiryDateCtrl,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'MM/AA',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: _expiryDateValidator,
                    ),
                    const SizedBox(height: 40),

                    Center(
                      child: ElevatedButton(
                        onPressed: isButtonDisabled ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isButtonDisabled ? Colors.grey.shade700 : Colors.white,
                          foregroundColor: isButtonDisabled ? Colors.white : Colors.black,
                          disabledBackgroundColor: Colors.grey.shade700,
                          disabledForegroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text('Pagar'),
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

