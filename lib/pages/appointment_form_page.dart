import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';

import 'user.dart'; // Página de HomePageUser
import 'payment.dart'; // Página de MethodPayment

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

  void _submit() {
    if (_formKey.currentState!.validate() &&
        _selectedDate != null &&
        _selectedTime != null &&
        _selectedBarber != null &&
        _paymentMethod != null) {
      final messenger = ScaffoldMessenger.of(context);

      if (_paymentMethod == 'Efectivo') {
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: const Text('¡Cita confirmada!'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.all(20),
            ),
          );

        Future.delayed(const Duration(seconds: 3), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePageUser()),
          );
        });
      } else if (_paymentMethod == 'Tarjeta') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PaymentPage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final hours = List<TimeOfDay>.generate(9, (i) => TimeOfDay(hour: 10 + i, minute: 0));
    final times = hours.map((t) => t.format(context)).toList();

    bool isButtonDisabled = _nameCtrl.text.isEmpty ||
        _selectedDate == null ||
        _selectedTime == null ||
        _selectedBarber == null ||
        _paymentMethod == null;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Row(
        children: [
          // Izquierda: imagen
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

          // Derecha: Formulario
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
              color: Colors.black,
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nombre', style: TextStyle(color: Colors.white)),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _nameCtrl,
                        style: TextStyle(color: Colors.black),
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
                          FilteringTextInputFormatter.allow(RegExp('[a-zA-Z\s]')),
                        ],
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Requerido';
                          if (RegExp(r'[0-9]').hasMatch(v)) return 'No se permiten números';
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Fecha', style: TextStyle(color: Colors.white)),
                                const SizedBox(height: 8),
                                TextFormField(
                                  readOnly: true,
                                  style: TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                    hintText: _selectedDate == null
                                        ? 'Selecciona fecha'
                                        : DateFormat.yMMMd().format(_selectedDate!),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
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
                                      setState(() {
                                        _selectedDate = picked;
                                      });
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
                                Text('Hora', style: TextStyle(color: Colors.white)),
                                const SizedBox(height: 8),
                                DropdownButtonFormField<String>(
                                  value: _selectedTime,
                                  hint: const Text('Selecciona hora'),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  items: times
                                      .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                                      .toList(),
                                  onChanged: (v) => setState(() => _selectedTime = v),
                                  validator: (v) => v == null ? 'Requerido' : null,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      Text('Servicio', style: TextStyle(color: Colors.white)),
                      const SizedBox(height: 8),
                      TextFormField(
                        initialValue: widget.service,
                        enabled: false,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      Text('Barbero', style: TextStyle(color: Colors.white)),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedBarber,
                        hint: const Text('Elegir'),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        items: _barbers
                            .map((b) => DropdownMenuItem(value: b, child: Text(b)))
                            .toList(),
                        onChanged: (v) => setState(() => _selectedBarber = v),
                        validator: (v) => v == null ? 'Requerido' : null,
                      ),
                      const SizedBox(height: 20),

                      Text('Forma de Pago', style: TextStyle(color: Colors.white)),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _paymentMethod,
                        hint: const Text('Selecciona una opción'),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'Efectivo', child: Text('Efectivo')),
                          DropdownMenuItem(value: 'Tarjeta', child: Text('Tarjeta')),
                        ],
                        onChanged: (v) => setState(() => _paymentMethod = v),
                        validator: (v) => v == null ? 'Requerido' : null,
                      ),
                      const SizedBox(height: 40),

                      Center(
                        child: ElevatedButton(
                          onPressed: isButtonDisabled ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isButtonDisabled
                                ? Colors.grey.shade700
                                : Colors.white,
                            foregroundColor: isButtonDisabled ? Colors.white : Colors.black,
                            disabledBackgroundColor: Colors.grey.shade700,
                            disabledForegroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text('Confirmar'),
                        ),
                      ),
                    ],
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
