import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:confetti/confetti.dart'; // Importar el paquete de confeti
import '../Clients/user_profile.dart';

class ResumeReservationPage extends StatefulWidget {
  final String name;
  final DateTime date;
  final String time;
  final String barber;
  final String service;
  final String cardholderName;
  final String cardNumber;
  final String expiryMonth;
  final String expiryYear;

  const ResumeReservationPage({
    Key? key,
    required this.name,
    required this.date,
    required this.time,
    required this.barber,
    required this.service,
    required this.cardholderName,
    required this.cardNumber,
    required this.expiryMonth,
    required this.expiryYear,
  }) : super(key: key);

  @override
  _ResumeReservationPageState createState() => _ResumeReservationPageState();
}

class _ResumeReservationPageState extends State<ResumeReservationPage> {
  late ConfettiController _confettiController; // Controlador de confeti

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 5)); // Duración de la animación
  }

  @override
  void dispose() {
    _confettiController.dispose(); // Liberar el controlador cuando se destruya el widget
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack( // Usamos un Stack para superponer el confeti sobre la interfaz
          children: [
            // Confeti que se lanza desde el fondo
            ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive, // Explosión en todas direcciones
              colors: const [Colors.green, Colors.blue, Colors.red, Colors.yellow], // Colores del confeti
              
            ),
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Detalles de la reserva',
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    _buildInfo('Nombre: ', widget.name),
                    _buildInfo('Fecha: ', DateFormat.yMMMd().format(widget.date)),
                    _buildInfo('Hora: ', widget.time),
                    _buildInfo('Barbero: ', widget.barber),
                    _buildInfo('Servicio: ', widget.service),
                    const SizedBox(height: 20),

                    const Text(
                      'Detalles del pago',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    _buildInfo('Titular: ${widget.cardholderName}', ''),
                    _buildInfo('Número: ${_formatCardNumber(widget.cardNumber)}', ''),
                    _buildInfo('Expira: ${widget.expiryMonth}/${widget.expiryYear}', ''),
                    const Divider(color: Colors.white24, height: 30),

                    ElevatedButton(
                      onPressed: () {
                        // Iniciar la animación de confeti
                        _confettiController.play();

                        // Mostrar el cuadro de diálogo de confirmación
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor: Colors.green, // Fondo verde para la notificación
                              title: const Text(
                                'Cita Reservada',
                                style: TextStyle(color: Colors.white, fontSize: 18),
                              ),
                              content: const Text(
                                '¡Tu cita ha sido reservada exitosamente! 🎉',
                                style: TextStyle(color: Colors.white, fontSize: 16),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context); // Cierra el diálogo
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => const PantallaUsuario()),  // Redirige a PantallaUsuario
                                    );
                                  },
                                  child: const Text('Aceptar', style: TextStyle(color: Colors.white)),
                                ),
                              ],
                            );
                          },
                        );
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
                      child: const Text('Confirmar Reserva', style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text('$label$value', style: const TextStyle(color: Colors.white70, fontSize: 15)),
    );
  }

  String _formatCardNumber(String cardNumber) {
    return cardNumber.replaceAllMapped(
      RegExp(r'(\d{4})(?=\d)'),
      (match) => '${match.group(1)} ',
    ).trim();
  }
}
