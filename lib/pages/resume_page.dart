import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ResumePage extends StatelessWidget {
  final String? name;
  final DateTime? date;
  final String? time;
  final String? barber;
  final String? paymentMethod;
  final String? service;

  final String? cardHolderName;
  final String? cardNumber;
  final String? expiryDate;

  const ResumePage({
    Key? key,
    this.name,
    this.date,
    this.time,
    this.barber,
    this.paymentMethod,
    this.service,
    this.cardHolderName,
    this.cardNumber,
    this.expiryDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          // Contenido derecho
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.black,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Detalles de la cita
                  if (name != null) 
                    Text('Nombre: $name', style: const TextStyle(color: Colors.white)),
                  if (date != null) 
                    Text('Fecha: ${DateFormat.yMMMd().format(date!)}', style: const TextStyle(color: Colors.white)),
                  if (time != null) 
                    Text('Hora: $time', style: const TextStyle(color: Colors.white)),
                  if (barber != null) 
                    Text('Barbero: $barber', style: const TextStyle(color: Colors.white)),
                  if (service != null) 
                    Text('Servicio: $service', style: const TextStyle(color: Colors.white)),

                  const SizedBox(height: 20),

                  // Detalles de la forma de pago
                  if (paymentMethod != null) 
                    Text('Forma de Pago: $paymentMethod', style: const TextStyle(color: Colors.white)),

                  const SizedBox(height: 20),

                  // Detalles de la tarjeta
                  if (cardHolderName != null) 
                    Text('Titular de la Tarjeta: $cardHolderName', style: const TextStyle(color: Colors.white)),
                  if (cardNumber != null) 
                    Text('Número de Tarjeta: $cardNumber', style: const TextStyle(color: Colors.white)),
                  if (expiryDate != null) 
                    Text('Fecha de Expiración: $expiryDate', style: const TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
