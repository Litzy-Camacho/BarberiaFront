import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'home_page.dart';
import 'user_page.dart';

class PaymentPage extends StatefulWidget {
  final String name;
  final DateTime date;
  final String time;
  final String barber;
  final String service;

  const PaymentPage({
    Key? key,
    required this.name,
    required this.date,
    required this.time,
    required this.barber,
    required this.service,
  }) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _expiryDateCtrl = TextEditingController();
  late List<TextEditingController> _cardDigitsControllers;
  late List<FocusNode> _cardFocusNodes;

  @override
  void initState() {
    super.initState();
    _cardDigitsControllers = List.generate(16, (_) => TextEditingController());
    _cardFocusNodes = List.generate(16, (_) => FocusNode());

    for (int i = 0; i < 16; i++) {
      _cardDigitsControllers[i].addListener(() {
        if (_cardDigitsControllers[i].text.length == 1 && i < 15) {
          _cardFocusNodes[i + 1].requestFocus();
        }
        setState(() {});
      });
    }

    _nameCtrl.addListener(() => setState(() {}));
    _expiryDateCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _expiryDateCtrl.dispose();
    for (var controller in _cardDigitsControllers) {
      controller.dispose();
    }
    for (var focus in _cardFocusNodes) {
      focus.dispose();
    }
    super.dispose();
  }

  bool get isFormValid {
    return _formKey.currentState?.validate() ?? false;
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
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

      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PantallaUsuario()),
        );
      });
    }
  }

  // VALIDACIONES PERSONALIZADAS

  String? _nameValidator(String? value) {
    if (value == null || value.isEmpty) return 'Requerido';
    if (!RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$').hasMatch(value)) {
      return 'Solo se permiten letras';
    }
    return null;
  }

  String? _expiryDateValidator(String? value) {
    if (value == null || value.isEmpty) return 'Requerido';
    RegExp regExp = RegExp(r'^(0[1-9]|1[0-2])\/(2[5-9]|[3-9][0-9])$');
    if (!regExp.hasMatch(value)) return 'Fecha no válida';
    return null;
  }

  String? _cardDigitValidator(String? value) {
    if (value == null || value.isEmpty) return '';
    if (!RegExp(r'^\d$').hasMatch(value)) return 'Sólo números';
    return null;
  }

  String get formattedCardNumber {
    final digits = _cardDigitsControllers.map((c) => c.text).join();
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      buffer.write(digits[i]);
      if ((i + 1) % 4 == 0 && i != digits.length - 1) buffer.write(' ');
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset('assets/imag/reservar.jpg', fit: BoxFit.cover),
                Container(color: Colors.black.withOpacity(0.5)),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
              color: const Color(0xFF1C1C1C),
              child: Form(
                key: _formKey,
                onChanged: () => setState(() {}),
                child: ListView(
                  children: [
                    const Text(
                      'Detalles de la reserva',
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    _buildInfo('Nombre', widget.name),
                    _buildInfo('Fecha', DateFormat.yMMMd().format(widget.date)),
                    _buildInfo('Hora', widget.time),
                    _buildInfo('Barbero', widget.barber),
                    _buildInfo('Servicio', widget.service),

                    const SizedBox(height: 20),
                    const Text(
                      'Vista previa del pago',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Titular: ${_nameCtrl.text}',
                      style: const TextStyle(color: Colors.white70, fontSize: 15),
                    ),
                    Text(
                      'Número: $formattedCardNumber',
                      style: const TextStyle(color: Colors.white70, fontSize: 15),
                    ),
                    Text(
                      'Expira: ${_expiryDateCtrl.text}',
                      style: const TextStyle(color: Colors.white70, fontSize: 15),
                    ),

                    const Divider(color: Colors.white24, height: 30),

                    const Text('Nombre del titular',
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                    const SizedBox(height: 6),
                    _styledTextField(
                      controller: _nameCtrl,
                      hint: 'Ej. Juan Pérez',
                      validator: _nameValidator,
                    ),

                    const SizedBox(height: 16),
                    const Text('Número de tarjeta',
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 5,
                      runSpacing: 10,
                      children: List.generate(16, (index) {
                        return SizedBox(
                          width: 35,
                          child: TextFormField(
                            controller: _cardDigitsControllers[index],
                            focusNode: _cardFocusNodes[index],
                            style: const TextStyle(color: Colors.black),
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            validator: _cardDigitValidator,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
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
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 20),
                    const Text('Fecha de expiración',
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                    const SizedBox(height: 6),
                    _styledTextField(
                      controller: _expiryDateCtrl,
                      hint: 'MM/AA',
                      validator: _expiryDateValidator,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'\d|/'))
                      ],
                      keyboardType: TextInputType.number,
                    ),

                    const SizedBox(height: 30),
                    Center(
                      child: ElevatedButton(
                        onPressed: isFormValid ? _submit : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isFormValid ? Colors.white : Colors.grey.shade700,
                          foregroundColor: isFormValid ? Colors.black : Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: isFormValid ? 4 : 0,
                        ),
                        child: const Text(
                          'Pagar',
                          style: TextStyle(fontSize: 16),
                        ),
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

  Widget _buildInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        '$label: $value',
        style: const TextStyle(color: Colors.white70, fontSize: 15),
      ),
    );
  }

  Widget _styledTextField({
    required TextEditingController controller,
    String? hint,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.black),
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
