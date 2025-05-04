import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppointmentFormPage extends StatefulWidget {
  final String service;
  const AppointmentFormPage({Key? key, required this.service})
    : super(key: key);

  @override
  State<AppointmentFormPage> createState() => _AppointmentFormPageState();
}

class _AppointmentFormPageState extends State<AppointmentFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();

  DateTime? _selectedDate;
  String? _selectedTime;
  String? _selectedBarber;

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
        _selectedBarber != null) {
      final messenger = ScaffoldMessenger.of(context);

      // Mostrar banner en la parte superior
      messenger
        ..hideCurrentMaterialBanner()
        ..showMaterialBanner(
          MaterialBanner(
            backgroundColor: Colors.green,
            content: Row(
              children: const [
                FaIcon(FontAwesomeIcons.dove, color: Colors.white),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Cita confirmada!',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  messenger.hideCurrentMaterialBanner();
                  Navigator.pop(context);
                },
                child: const Text('OK', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );

      // Oculta el banner y luego cierra la página después de 3 segundos
      Future.delayed(const Duration(seconds: 3), () {
        messenger.hideCurrentMaterialBanner();
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Genera horas de 10:00 AM a 6:00 PM
    final hours = List<TimeOfDay>.generate(
      9,
      (i) => TimeOfDay(hour: 10 + i, minute: 0),
    );
    final times = hours.map((t) => t.format(context)).toList();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Row(
        children: [
          // Izquierda: imagen
          Expanded(
            flex: 1,
            child: Image.asset('assets/imag/4.png', fit: BoxFit.cover),
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
                      Center(
                        child: Text(
                          'HAZ TU CITA',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontFamily: 'Georgia',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Nombre
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
                        validator:
                            (v) => v == null || v.isEmpty ? 'Requerido' : null,
                      ),
                      const SizedBox(height: 20),

                      // Fecha & Hora
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Fecha',
                                  style: TextStyle(color: Colors.white),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  readOnly: true,
                                  style: TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                    hintText:
                                        _selectedDate == null
                                            ? 'Selecciona fecha'
                                            : DateFormat.yMMMd().format(
                                              _selectedDate!,
                                            ),
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
                                      lastDate: now.add(
                                        const Duration(days: 60),
                                      ),
                                    );
                                    if (picked != null) {
                                      setState(() {
                                        _selectedDate = picked;
                                      });
                                    }
                                  },
                                  validator:
                                      (_) =>
                                          _selectedDate == null
                                              ? 'Requerido'
                                              : null,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hora',
                                  style: TextStyle(color: Colors.white),
                                ),
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
                                  items:
                                      times
                                          .map(
                                            (t) => DropdownMenuItem(
                                              value: t,
                                              child: Text(t),
                                            ),
                                          )
                                          .toList(),
                                  onChanged:
                                      (v) => setState(() => _selectedTime = v),
                                  validator:
                                      (v) => v == null ? 'Requerido' : null,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Servicio
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

                      // Barbero
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
                        items:
                            _barbers
                                .map(
                                  (b) => DropdownMenuItem(
                                    value: b,
                                    child: Text(b),
                                  ),
                                )
                                .toList(),
                        onChanged: (v) => setState(() => _selectedBarber = v),
                        validator: (v) => v == null ? 'Requerido' : null,
                      ),
                      const SizedBox(height: 40),

                      // Botón Confirmar
                      Center(
                        child: ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 15,
                            ),
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
