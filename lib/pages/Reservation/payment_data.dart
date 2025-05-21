import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../Clients/user_profile.dart';
import 'resume_reservation.dart';  // Asegúrate de importar la página de resumen
import 'reservation_data.dart';

class PaymentPage extends StatefulWidget {
  final String name;
  final String phone;
  final DateTime date;
  final String time;
  final String barber;
  final String service;

  const PaymentPage({
    Key? key,
    required this.name,
    required this.phone,
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
  final _cardNumberCtrl = TextEditingController();
  final _cvvCtrl = TextEditingController();
  final _expiryMonthCtrl = TextEditingController();
  final _expiryYearCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameCtrl.addListener(() => setState(() {}));
    _cardNumberCtrl.addListener(() => setState(() {}));
    _cvvCtrl.addListener(() => setState(() {}));
    _expiryMonthCtrl.addListener(() => setState(() {}));
    _expiryYearCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _cardNumberCtrl.dispose();
    _cvvCtrl.dispose();
    _expiryMonthCtrl.dispose();
    _expiryYearCtrl.dispose();
    super.dispose();
  }

  bool get isFormValid => _formKey.currentState?.validate() ?? false;

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final paymentJson = {
        "name": _nameCtrl.text,
        "cardNumber": _cardNumberCtrl.text.replaceAll(' ', ''),
        "cvv": _cvvCtrl.text,
        "expiryMonth": _expiryMonthCtrl.text,
        "expiryYear": _expiryYearCtrl.text,
      };
      print("JSON enviado: $paymentJson");

      // Redirigir a la página ResumeReservationPage con los datos de la reserva y pago
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResumeReservationPage(
            name: widget.name,
            phone:widget.phone,
            date: widget.date,
            time: widget.time,
            barber: widget.barber,
            service: widget.service,
            cardholderName: _nameCtrl.text,
            cardNumber: _cardNumberCtrl.text,
            expiryMonth: _expiryMonthCtrl.text,
            expiryYear: _expiryYearCtrl.text,
          ),
        ),
      );
    }
  }

  String? _nameValidator(String? value) {
    if (value == null || value.isEmpty) return 'Requerido';
    if (!RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$').hasMatch(value)) {
      return 'Solo se permiten letras';
    }
    return null;
  }

  String? _cardNumberValidator(String? value) {
    if (value == null || value.isEmpty) return 'Requerido';
    final cleaned = value.replaceAll(' ', '');
    if (!RegExp(r'^\d+$').hasMatch(cleaned)) {
      return 'Número no válido';
    }
    if (cleaned.length != 16) return 'Debe contener 16 dígitos';
    return null;
  }

  String? _cvvValidator(String? value) {
    if (value == null || value.isEmpty) return 'Requerido';
    if (!RegExp(r'^\d{3}$').hasMatch(value)) return 'El CVV debe tener 3 dígitos';
    return null;
  }

  String? _expiryMonthValidator(String? value) {
    if (value == null || value.isEmpty) return 'Requerido';
    final month = int.tryParse(value);
    if (month == null || month < 1 || month > 12) return 'Mes inválido';
    return null;
  }

  String? _expiryYearValidator(String? value) {
    if (value == null || value.isEmpty) return 'Requerido';
    final year = int.tryParse(value);
    if (year == null || year < DateTime.now().year % 100) return 'Año inválido';
    return null;
  }

  String _formatCardNumber(String cardNumber) {
    return cardNumber.replaceAllMapped(
      RegExp(r'(\d{4})(?=\d)'),
      (match) => '${match.group(1)} ',
    ).trim();
  }

  @override
  
      Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.black,
    body: Stack(
      children: [
        // Imagen de fondo
        SizedBox.expand(
          child: Image.asset(
            'assets/imag/fondo.jpg',
            fit: BoxFit.cover,
          ),
        ),

        // Capa de opacidad negra
        Container(
          color: Colors.black.withOpacity(0.1),
        ),

        // Contenido principal
        SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Form(
              key: _formKey,
              onChanged: () => setState(() {}),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AppointmentFormPage(
                                service: widget.service,
                              ),
                            ),
                          );
                        },
                      ),
                      const Text(
                        'Regresar',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                  const Text(
                    'Vista previa del pago',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  // Tarjeta visual
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(color: Colors.black38, blurRadius: 10, spreadRadius: 2)
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('TARJETA DE CRÉDITO',
                            style: TextStyle(color: Colors.white, fontSize: 14)),
                        const SizedBox(height: 10),
                        Text(
                          _formatCardNumber(
                              _cardNumberCtrl.text.isEmpty ? '**** **** **** ****' : _cardNumberCtrl.text),
                          style: const TextStyle(color: Colors.white, fontSize: 24, letterSpacing: 2),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Exp: ${_expiryMonthCtrl.text}/${_expiryYearCtrl.text}',
                              style: const TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            const Text(
                              'CVV: ***',
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

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
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _cardNumberCtrl,
                    keyboardType: TextInputType.number,
                    maxLength: 19,
                    validator: _cardNumberValidator,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(16),
                      CardNumberInputFormatter(),
                    ],
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: 'XXXX XXXX XXXX XXXX',
                      filled: true,
                      fillColor: Colors.white,
                      counterText: '',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  const Text('CVV',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _cvvCtrl,
                    keyboardType: TextInputType.number,
                    maxLength: 3,
                    validator: _cvvValidator,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: 'CVV',
                      filled: true,
                      fillColor: Colors.white,
                      counterText: '',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Text('Fecha de expiración',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: _styledTextField(
                          controller: _expiryMonthCtrl,
                          hint: 'MM',
                          validator: _expiryMonthValidator,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('/', style: TextStyle(color: Colors.white, fontSize: 20)),
                      ),
                      Expanded(
                        child: _styledTextField(
                          controller: _expiryYearCtrl,
                          hint: 'AA',
                          validator: _expiryYearValidator,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      onPressed: isFormValid ? _submit : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isFormValid ? Colors.white : Colors.grey.shade700,
                        foregroundColor: isFormValid ? Colors.black : Colors.white,
                        disabledBackgroundColor: Colors.grey.shade700,
                        disabledForegroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: isFormValid ? 5 : 0,
                      ),
                      child: const Text('Pagar', style: TextStyle(fontSize: 16)),
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

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');
    final buffer = StringBuffer();
    for (int i = 0; i < digitsOnly.length; i++) {
      if (i == 4 || i == 8 || i == 12) buffer.write(' ');
      buffer.write(digitsOnly[i]);
    }
    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}
