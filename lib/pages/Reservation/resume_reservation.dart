import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:confetti/confetti.dart';
import '../Clients/user_profile.dart';
import 'payment_data.dart';

class ResumeReservationPage extends StatefulWidget {
  final String name;
  final String phone;
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
    required this.phone,
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
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 5));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.black,
    body: SafeArea(
      child: Stack(
        children: [
          // Fondo
          SizedBox.expand(
            child: Image.asset(
              'assets/imag/fondovertical.png',
              fit: BoxFit.cover,
            ),
          ),

          // Confetti
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            colors: const [Colors.green, Colors.blue, Colors.red, Colors.yellow],
          ),

          // Botón de regresar arriba a la izquierda
          Positioned(
            top: 10,
            left: 10,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentPage(
                          name: widget.name,
                          phone: widget.phone,
                          date: widget.date,
                          time: widget.time,
                          barber: widget.barber,
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
          ),

          // Contenido principal centrado
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 60), // Espacio superior para evitar que se solape con "Regresar"
                  const Text(
                    'Detalles de la reserva',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildInfo('Nombre: ', widget.name),
                  _buildInfo('Telefono: ', widget.phone),
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
                  _buildInfo('Titular: ', widget.cardholderName),
                  _buildInfo('Número: ', _formatCardNumber(widget.cardNumber)),
                  _buildInfo('Expira: ', '${widget.expiryMonth}/${widget.expiryYear}'),
                  const Divider(color: Colors.white24, height: 30),
                  ElevatedButton(
                    onPressed: () {
                      _confettiController.play();
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: Colors.green,
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
                                  Navigator.pop(context);
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => const PantallaUsuario()),
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
    // Elimina espacios si vienen incluidos
    String cleanNumber = cardNumber.replaceAll(' ', '');
    if (cleanNumber.length < 4) return cardNumber;

    String lastFour = cleanNumber.substring(cleanNumber.length - 4);
    return '**** **** **** $lastFour';
  }
}
