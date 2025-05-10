import 'package:flutter/material.dart';

class ServiciosSection extends StatelessWidget {
  final GlobalKey keyServicios;

  const ServiciosSection({super.key, required this.keyServicios});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: keyServicios,
      width: double.infinity,
      color: Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      child: Stack(
        children: [
          // Fondo con líneas diagonales cruzadas solo en el contenedor
          Positioned.fill(
            child: ClipRect(
              child: CustomPaint(
                painter: LineasDiagonalesCruzadasPainter(),
              ),
            ),
          ),
          // Contenido principal
          Column(
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
              // Asegurar que las tarjetas estén centradas correctamente
              Center(
                child: Wrap(
                  spacing: 40,
                  runSpacing: 40,
                  alignment: WrapAlignment.center, // Esto asegura que las tarjetas estén centradas
                  children: [
                    _ServicioCard(
                      imagePath: 'assets/imag/estilos.jpg',
                      title: 'Corte & Estilo',
                      description:
                          'Cortes clásicos, modernos y ejecutivos adaptados a tu personalidad. Precisión, técnica y estilo en cada visita.',
                    ),
                    _ServicioCard(
                      imagePath: 'assets/imag/barba.jpg',
                      title: 'Barba & Afeitado',
                      description:
                          'Perfilado, diseño y afeitado tradicional con toalla caliente. Cuida tu barba con detalle y estilo.',
                    ),
                    _ServicioCard(
                      imagePath: 'assets/imag/tratamiento.jpg',
                      title: 'Tratamientos & Cuidado Especial',
                      description:
                          'Faciales y tratamientos capilares que revitalizan tu piel y cabello. Bienestar y frescura en cada sesión.',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class LineasDiagonalesCruzadasPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..strokeWidth = 1;

    // ==== LÍNEAS SUPERIORES ====
    canvas.drawLine(Offset(0, size.height * 0.9), Offset(size.width * 0.3, 0), paint);
    canvas.drawLine(Offset(0, size.height * 0.6), Offset(size.width * 0.5, 0), paint);
    canvas.drawLine(Offset(size.width * 0.2, size.height), Offset(size.width * 0.65, 0), paint);
    canvas.drawLine(Offset(size.width * 0.5, size.height), Offset(size.width * 0.9, 0), paint);
    canvas.drawLine(Offset(size.width, size.height * 0.5), Offset(size.width * 0.7, 0), paint);
    canvas.drawLine(Offset(size.width, size.height * 0.9), Offset(size.width * 0.9, 0), paint);

    // ==== LÍNEAS INFERIORES ====
    canvas.drawLine(Offset(0, size.height * 0.8), Offset(size.width * 0.5, size.height), paint);
    canvas.drawLine(Offset(0, size.height), Offset(size.width * 0.6, size.height * 0.95), paint);
    canvas.drawLine(Offset(size.width, size.height * 0.8), Offset(size.width * 0.5, size.height), paint);
    canvas.drawLine(Offset(size.width, size.height), Offset(size.width * 0.4, size.height * 0.95), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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
      width: 400,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: ClipRRect(
              child: Image.asset(
                imagePath,
                width: double.infinity,
                height: 280,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Georgia',
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    fontFamily: 'Georgia',
                  ),
                ),
                const SizedBox(height: 20),
                Divider(
                  color: Colors.black.withOpacity(0.2),
                  thickness: 1,
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
