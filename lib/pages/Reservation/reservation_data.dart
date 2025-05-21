import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'payment_data.dart';
import 'resume_reservation.dart';
import '../Services/services_screen.dart';
import '../Home/home_page.dart';

// ... imports iguales
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
  bool _submitted = false;


  final List<String> _barbers = ['Ricardo', 'Andrea', 'Litzy'];
  late String _selectedService;
  final List<String> _availableServices = ['Corte de cabello', 'Barba', 'Color', 'Afeitado'];

  bool get isNameValid => RegExp(r'^[a-zA-Z\s]+$').hasMatch(_nameCtrl.text);
  bool get isPhoneValid => RegExp(r'^\d{10}$').hasMatch(_phoneCtrl.text);
  bool get isDateValid => _selectedDate != null;
  bool get isTimeValid => _selectedTime != null;
  bool get isBarberValid => _selectedBarber != null;
  bool get isPaymentValid => _paymentMethod != null;

  bool get isFormValid =>
      isNameValid && isPhoneValid && isDateValid && isTimeValid && isBarberValid && isPaymentValid;

  @override
  void initState() {
    super.initState();
    _selectedService = widget.service;
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

  void _showServiceDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Selecciona un servicio'),
          content: SingleChildScrollView(
            child: Column(
              children: _availableServices.map((service) {
                return ListTile(
                  title: Text(service),
                  onTap: () {
                    setState(() {
                      _selectedService = service;
                    });
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
  final hours = List<TimeOfDay>.generate(9, (i) => TimeOfDay(hour: 10 + i, minute: 0));
  final times = hours.map((t) => t.format(context)).toList();

  return Scaffold(
    backgroundColor: Colors.black,
    body: Stack(
      children: [
        SizedBox.expand(
          child: Image.asset(
            'assets/imag/fondovertical.png',
            fit: BoxFit.cover,
          ),
        ),
        SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Form(
                  key: _formKey,
                  onChanged: () => setState(() {}),
                  child: DefaultTextStyle(
                    style: const TextStyle(color: Colors.white, fontSize: 16),
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
                                      builder: (context) => const ServicesScreen()),
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

                        const Text('Nombre'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _nameCtrl,
                          style: const TextStyle(color: Colors.black),
                          decoration: _customInputDecoration('Ingresa tu nombre completo'),
                          validator: (value) {
                            if (!_submitted) return null;
                            if (value == null || value.isEmpty) {
                              return 'Requerido';
                            } else if (RegExp(r'[0-9]').hasMatch(value)) {
                              return 'El nombre no debe contener números';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        const Text('Teléfono'),
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
                            if (!_submitted) return null;
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
  style: const TextStyle(color: Colors.black), // Texto en negro cuando hay contenido
  decoration: InputDecoration(
    hintText: _selectedDate == null
        ? 'Selecciona fecha'
        : DateFormat.yMMMd().format(_selectedDate!),
    hintStyle: TextStyle(
      color: _selectedDate == null ? Colors.grey : Colors.black,
      fontWeight: FontWeight.normal,
    ),
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  ),
  onTap: () async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 60)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.black, // Color negro en lugar de morado
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  },
  validator: (_) {
    if (!_submitted) return null;
    return _selectedDate == null ? 'Requerido' : null;
  },
),

                        const SizedBox(height: 20),

                        const Text('Hora'),
                        const SizedBox(height: 8),
                        Theme(
                          data: Theme.of(context).copyWith(
                            canvasColor: Colors.white,
                          ),
                          child: DropdownButtonFormField<String>(
                            value: _selectedTime,
                            hint: const Text(
    'Selecciona hora',
    style: TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.normal,
    ),
                            ),
                            decoration: _customInputDecoration(''),
                            items: times.map((t) => DropdownMenuItem(
                              value: t,
                              child: Text(t, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.normal))

                            )).toList(),
                            onChanged: (v) {
                              setState(() => _selectedTime = v);
                            },
                            validator: (v) {
                              if (!_submitted) return null;
                              return v == null ? 'Requerido' : null;
                            },
                          ),
                        ),
                        const SizedBox(height: 20),

                        const Text('Servicio'),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: TextEditingController(text: _selectedService),
                                enabled: false,
                                style: const TextStyle(color: Colors.black),
                                decoration: _customInputDecoration(''),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.white),
                              onPressed: _showServiceDialog,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        const Text('Barbero'),
                        const SizedBox(height: 8),
                        Theme(
                          data: Theme.of(context).copyWith(
                            canvasColor: Colors.white,
                          ),
                          child: DropdownButtonFormField<String>(
                            value: _selectedBarber,
                            hint: const Text(
    'Selecciona el barbero',
    style: TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.normal,
    ),
  ),

                            decoration: _customInputDecoration(''),
                            items: _barbers
                                .map((b) => DropdownMenuItem(
                                      value: b,
                                      child: Text(b, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.normal))

                                    ))
                                .toList(),
                            onChanged: (v) {
                              setState(() => _selectedBarber = v);
                            },
                            validator: (v) {
                              if (!_submitted) return null;
                              return v == null ? 'Requerido' : null;
                            },
                          ),
                        ),
                        const SizedBox(height: 20),

                        const Text('Forma de Pago'),
                        const SizedBox(height: 8),
                        Theme(
                          data: Theme.of(context).copyWith(
                            canvasColor: Colors.white,
                          ),
                          child: DropdownButtonFormField<String>(
                            value: _paymentMethod,
                            hint: const Text(
    'Selecciona la forma de pago',
    style: TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.normal,
    ),
  ),

                            decoration: _customInputDecoration(''),
                            items: const [
                              DropdownMenuItem(
                                  value: 'Efectivo',
                                  child: Text('Efectivo', style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal))),
                              DropdownMenuItem(
                                  value: 'Tarjeta',
                                  child: Text('Tarjeta', style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal))),
                            ],
                            onChanged: (v) {
                              setState(() => _paymentMethod = v);
                            },
                            validator: (v) {
                              if (!_submitted) return null;
                              return v == null ? 'Requerido' : null;
                            },
                          ),
                        ),
                        const SizedBox(height: 40),

                        Center(
                          child: ElevatedButton(
                            onPressed: () async {
                              setState(() => _submitted = true);

                              if (_formKey.currentState!.validate()) {
                                _saveAppointment();

                                if (_paymentMethod == 'Efectivo') {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Reservación hecha con éxito',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      backgroundColor: Colors.green,
                                      behavior: SnackBarBehavior.fixed,
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                  await Future.delayed(const Duration(seconds: 2));
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(builder: (context) => const HomePage()),
                                    (route) => false,
                                  );
                                } else {
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
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 5,
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
      ],
    ),
  );
}


}
