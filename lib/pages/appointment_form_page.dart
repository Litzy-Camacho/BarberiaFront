import 'package:flutter/material.dart'; 
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

import 'user.dart';
import 'payment.dart';
import 'resume_page.dart';

class AppointmentFormPage extends StatefulWidget {
  final String service;
  const AppointmentFormPage({Key? key, required this.service}) : super(key: key);

  @override
  State<AppointmentFormPage> createState() => _AppointmentFormPageState();
}

class _AppointmentFormPageState extends State<AppointmentFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedTime;
  String? _selectedBarber;
  String? _paymentMethod;

  final List<String> _barbers = ['Ricardo', 'Andrea', 'Litzy'];

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  void _goToResumePage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResumePage(
          name: _nameCtrl.text,
          date: _selectedDate!,
          time: _selectedTime!,
          barber: _selectedBarber!,
          paymentMethod: _paymentMethod!,
          service: widget.service,
        ),
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate() &&
        _selectedDate != null &&
        _selectedTime != null &&
        _selectedBarber != null &&
        _paymentMethod != null) {
      if (_paymentMethod == 'Efectivo') {
        _goToResumePage();
      } else if (_paymentMethod == 'Tarjeta') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentPage(
              name: _nameCtrl.text,
              date: _selectedDate!,
              time: _selectedTime!,
              barber: _selectedBarber!,
              service: widget.service,
            ),
          ),
        );
      }
    }
  }

  InputDecoration _customInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    );
  }

  bool get _isFormValid {
    return _formKey.currentState?.validate() == true &&
        _selectedDate != null &&
        _selectedTime != null &&
        _selectedBarber != null &&
        _paymentMethod != null;
  }

  @override
  Widget build(BuildContext context) {
    final hours = List<TimeOfDay>.generate(9, (i) => TimeOfDay(hour: 10 + i, minute: 0));
    final times = hours.map((t) => t.format(context)).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C),
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
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
              color: const Color(0xFF1C1C1C),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: DefaultTextStyle(
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Nombre'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _nameCtrl,
                          style: const TextStyle(color: Colors.black),
                          decoration: _customInputDecoration('Ingresa tu nombre completo'),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s0-9]'))
                          ],
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Requerido';
                            if (RegExp(r'[0-9]').hasMatch(v)) return 'Nombre contiene números';
                            return null;
                          },
                          onChanged: (_) => setState(() {}),
                        ),
                        const SizedBox(height: 20),

                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Fecha'),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    readOnly: true,
                                    style: const TextStyle(color: Colors.black),
                                    decoration: _customInputDecoration(
                                      _selectedDate == null
                                          ? 'Selecciona fecha'
                                          : DateFormat.yMMMd().format(_selectedDate!),
                                    ),
                                    onTap: () async {
                                      final now = DateTime.now();
                                      final picked = await showDatePicker(
                                        context: context,
                                        initialDate: _selectedDate ?? now,
                                        firstDate: now,
                                        lastDate: now.add(const Duration(days: 60)),
                                      );
                                      if (picked != null) {
                                        setState(() => _selectedDate = picked);
                                      }
                                    },
                                    validator: (_) => _selectedDate == null ? 'Requerido' : null,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Hora'),
                                  const SizedBox(height: 8),
                                  DropdownButtonFormField<String>(
                                    value: _selectedTime,
                                    hint: const Text('Selecciona hora'),
                                    decoration: _customInputDecoration(''),
                                    items: times.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                                    onChanged: (v) => setState(() => _selectedTime = v),
                                    validator: (v) => v == null ? 'Requerido' : null,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        const Text('Servicio'),
                        const SizedBox(height: 8),
                        TextFormField(
                          initialValue: widget.service,
                          enabled: false,
                          style: const TextStyle(color: Colors.black),
                          decoration: _customInputDecoration(''),
                        ),
                        const SizedBox(height: 20),

                        const Text('Barbero'),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: _selectedBarber,
                          hint: const Text('Elegir'),
                          decoration: _customInputDecoration(''),
                          items: _barbers.map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
                          onChanged: (v) => setState(() => _selectedBarber = v),
                          validator: (v) => v == null ? 'Requerido' : null,
                        ),
                        const SizedBox(height: 20),

                        const Text('Forma de Pago'),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: _paymentMethod,
                          hint: const Text('Selecciona una opción'),
                          decoration: _customInputDecoration(''),
                          items: const [
                            DropdownMenuItem(value: 'Efectivo', child: Text('Efectivo')),
                            DropdownMenuItem(value: 'Tarjeta', child: Text('Tarjeta')),
                          ],
                          onChanged: (v) => setState(() => _paymentMethod = v),
                          validator: (v) => v == null ? 'Requerido' : null,
                        ),
                        const SizedBox(height: 40),

                        Center(
                          child: MouseRegion(
                            cursor: _isFormValid ? SystemMouseCursors.click : SystemMouseCursors.basic,
                            child: ElevatedButton(
                              onPressed: _isFormValid ? _submit : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _isFormValid ? Colors.white : Colors.grey.shade700,
                                foregroundColor: _isFormValid ? Colors.black : Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                elevation: 5,
                              ),
                              child: const Text('Confirmar', style: TextStyle(fontSize: 16)),
                            ),
                          ),
                        ),

                      ],
                    ),
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
