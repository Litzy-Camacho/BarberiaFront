import 'package:flutter/material.dart';

class ServiciosSection extends StatelessWidget {
  final GlobalKey keyServicios;

  const ServiciosSection({Key? key, required this.keyServicios})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      key: keyServicios,
      color: Colors.black,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      child: Column(
        children: [
          const Text(
            'Nuestros servicios',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Georgia',
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Todos nuestros servicios se realizan en cabinas privadas y son exclusivos para hombre.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
              height: 1.5,
              fontFamily: 'Georgia',
            ),
          ),
          const SizedBox(height: 50),
          Wrap(
            spacing: 30,
            runSpacing: 30,
            alignment: WrapAlignment.center,
            children: [
              _ServicioCard(
                imagePath: 'assets/imag/1.png', //Imagen de opciones
                title: 'Corte & Estilo',
                description:
                    'Cortes clásicos, modernos y ejecutivos adaptados a tu personalidad. Precisión, técnica y estilo en cada visita.',
              ),
              _ServicioCard(
                imagePath: 'assets/imag/4.png', //Imagen de opciones
                title: 'Barba & Afeitado',
                description:
                    'Perfilado, diseño y afeitado tradicional con toalla caliente. Cuida tu barba con detalle y estilo.',
              ),
              _ServicioCard(
                imagePath: 'assets/imag/5.png', //Imagen de opciones
                title: 'Tratamientos & Cuidado Especial',
                description:
                    'Faciales y tratamientos capilares que revitalizan tu piel y cabello. Bienestar y frescura en cada sesión.',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ServicioCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;

  const _ServicioCard({
    required this.imagePath,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            child: Image.asset(
              imagePath,
              width: double.infinity,
              height: 180,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Georgia',
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    fontFamily: 'Georgia',
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Ver más >',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Georgia',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
