import 'package:flutter/material.dart';
import 'package:front/pages/Services/service_cortestilo.dart';
import 'package:front/pages/Services/service_barba.dart';
import 'package:front/pages/Services/service_tratamiento_.dart';

/// Widget de navegación entre secciones de servicios sin apilar rutas.
class ServiceNavBar extends StatelessWidget {
  /// Índice de la pestaña activa: 0=Corte, 1=Barba, 2=Tratamiento
  final int currentIndex;
  const ServiceNavBar({Key? key, required this.currentIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Wrap(
        spacing: 20,
        children: [
          _buildNavItem(
            context,
            label: 'Corte & Estilo',
            index: 0,
            destination: const ServiceCorteEstiloPage(),
          ),
          const Text('|', style: TextStyle(color: Colors.white54)),
          _buildNavItem(
            context,
            label: 'Barba & Afeitado',
            index: 1,
            destination: const ServiceBarbaPage(),
          ),
          const Text('|', style: TextStyle(color: Colors.white54)),
          _buildNavItem(
            context,
            label: 'Tratamientos & Cuidado especial',
            index: 2,
            destination: const ServiceEstilosTratamientoPage(),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required String label,
    required int index,
    required Widget destination,
  }) {
    final bool isActive = index == currentIndex;
    return GestureDetector(
      onTap: () {
        if (!isActive) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => destination),
          );
        }
      },
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          decoration: isActive ? TextDecoration.underline : TextDecoration.none,
        ),
      ),
    );
  }
}
