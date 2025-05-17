import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'payment_data.dart';
import 'resume_reservation.dart';

class AppointmentFormPage extends StatefulWidget {
  final String service;
  const AppointmentFormPage({Key? key, required this.service}) : super(key: key);

  @override
  State<AppointmentFormPage> createState() => _AppointmentFormPageState();
}

class _AppointmentFormPageState extends State<AppointmentFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedTime;
  String? _selectedBarber;
  String? _paymentMethod;

  final List<String> _barbers = ['Ricardo', 'Andrea', 'Litzy'];

  bool _showServiceDropdown = false;
  late String _selectedService;
  final List<String> _availableServices = ['Corte de cabello', 'Barba', 'Color', 'Afeitado'];

  bool get isNameValid => RegExp(r'^[a-zA-Z\s]+$').hasMatch(_nameCtrl.text);
  bool get isPhoneValid => RegExp(r'^\d{10}$').hasMatch(_phoneCtrl.text);
  bool get isDateValid => _selectedDate != null;
  bool get isTimeValid => _selectedTime != null;
  bool get isBarberValid => _selectedBarber != null;
  bool get isPaymentValid => _paymentMethod != null;

  bool get isFormValid =>
      isNameValid && isPhoneValid && isDateValid && isTimeValid && isBarberValid && isPaymentValid ;

  @override
  void initState() {
    super.initState();
    _selectedService = widget.service; // Servicio inicial
    _nameCtrl.addListener(() {
      setState(() {});
    });
    _phoneCtrl.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
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

  Future<void> _saveAppointment() async {
    final prefs = await SharedPreferences.getInstance();

    if (_selectedDate != null && _selectedTime != null) {
      final timeParts = _selectedTime!.split(':');
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);

      final combinedDateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        hour,
        minute,
      );

      final Map<String, dynamic> appointmentData = {
        'name': _nameCtrl.text,
        'phone': _phoneCtrl.text,
        'dateTime': combinedDateTime.toIso8601String(),
        'barber': _selectedBarber,
        'paymentMethod': _paymentMethod,
        'service': _selectedService,
      };

      final jsonString = jsonEncode(appointmentData);
      await prefs.setString('appointment', jsonString);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hours = List<TimeOfDay>.generate(9, (i) => TimeOfDay(hour: 10 + i, minute: 0));
    final times = hours.map((t) => t.format(context)).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Form(
                key: _formKey,
                onChanged: () {
                  setState(() {});
                },
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Requerido';
                          } else if (RegExp(r'[0-9]').hasMatch(value)) {
                            return 'El nombre no debe contener números';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                     const Text('Telefono'),
const SizedBox(height: 8),
TextFormField(
  controller: _phoneCtrl,
  style: const TextStyle(color: Colors.black),
  decoration: _customInputDecoration('Ingresa tu número de teléfono'),
  keyboardType: TextInputType.number,
  inputFormatters: [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(10),
  ],
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Requerido';
    } else if (!RegExp(r'^\d{10}$').hasMatch(value)) {
      return 'Debe tener exactamente 10 dígitos numéricos';
    }
    return null;
  },
),

                      const SizedBox(height: 20),
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
                      const SizedBox(height: 20),

                      const Text('Hora'),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedTime,
                        hint: const Text('Selecciona hora'),
                        decoration: _customInputDecoration(''),
                        items: times.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                        onChanged: (v) {
                          setState(() => _selectedTime = v);
                        },
                        validator: (v) => v == null ? 'Requerido' : null,
                      ),
                      const SizedBox(height: 20),

                      const Text('Servicio'),
                      const SizedBox(height: 8),
                      Row(
  children: [
    Expanded(
      child: TextFormField(
        controller: TextEditingController(text: _selectedService), // Dynamically update the service
        enabled: false,
        style: const TextStyle(color: Colors.black),
        decoration: _customInputDecoration(''),
      ),
    ),
  Container(
  
  child: IconButton(
    icon: const Icon(Icons.edit, color: Colors.white), // ícono de editar
    onPressed: () {
      setState(() {
        _showServiceDropdown = !_showServiceDropdown;
      });
    },
  ),
),

  ],
),

                      const SizedBox(height: 8),
                      if (_showServiceDropdown) ...[
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: _availableServices.contains(_selectedService)
                              ? _selectedService
                              : null,
                          decoration: _customInputDecoration('Selecciona un nuevo servicio'),
                          items: _availableServices
                              .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedService = value!;  // Update selected service
                              _showServiceDropdown = false;  // Hide the dropdown
                            });
                          },
                        ),
                      ],
                      const SizedBox(height: 20),

                      const Text('Barbero'),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedBarber,
                        hint: const Text('Elegir'),
                        decoration: _customInputDecoration(''),
                        items: _barbers.map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
                        onChanged: (v) {
                          setState(() => _selectedBarber = v);
                        },
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
                        onChanged: (v) {
                          setState(() => _paymentMethod = v);
                        },
                        validator: (v) => v == null ? 'Requerido' : null,
                      ),
                      const SizedBox(height: 40),

                      Center(
                        child: ElevatedButton(
                          onPressed: isFormValid
                              ? () {
                                  _saveAppointment();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PaymentPage(
                                        name: _nameCtrl.text,
                                        phone: _phoneCtrl.text,
                                        date: _selectedDate ?? DateTime.now(),
                                        time: _selectedTime ?? 'Hora no seleccionada',
                                        barber: _selectedBarber ?? 'Barbero no seleccionado',
                                        service: _selectedService,
                                      ),
                                    ),
                                  );
                                }
                              : null,
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
                          child: const Text('Siguiente', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
