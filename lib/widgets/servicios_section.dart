import 'package:flutter/material.dart';
import 'package:front/pages/service_cortestilo_page.dart';
import 'package:front/pages/service_barba_page.dart';
import 'package:front/pages/service_estilostratamiento_page.dart';

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
          Positioned.fill(
            child: ClipRect(
              child: CustomPaint(
                painter: LineasDiagonalesCruzadasPainter(),
              ),
            ),
          ),
          Column(
  children: [
    Container(
      color: Colors.black, // Fondo negro
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: const Text(
        'Nuestros servicios',
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Colors.white, // Texto blanco
          fontFamily: 'Georgia',
        ),
      ),
    ),
    
    Container(
      color: Colors.black, // Fondo negro
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: const Text(
        'Todos nuestros servicios se realizan en cabinas privadas y son exclusivos para hombre.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
          color: Colors.white70, // Texto blanco
          height: 1,
          fontFamily: 'Georgia',
        ),
      ),
    ),

              const SizedBox(height: 50),
              Center(
                child: Wrap(
                  spacing: 40,
                  runSpacing: 40,
                  alignment: WrapAlignment.center,
                  children: [
                    _ServicioCard(
                      imagePath: 'assets/imag/estilos.jpg',
                      title: 'Corte & Estilo',
                      description:
                          'Cortes clásicos, modernos y ejecutivos adaptados a tu personalidad. Precisión, técnica y estilo en cada visita.',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ServiceCorteEstiloPage(),
                          ),
                        );
                      },
                    ),
                    _ServicioCard(
                      imagePath: 'assets/imag/barba.jpg',
                      title: 'Barba & Afeitado',
                      description:
                          'Perfilado, diseño y afeitado tradicional con toalla caliente. Cuida tu barba con detalle y estilo.',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ServiceBarbaPage(),
                          ),
                        );
                      },
                    ),
                    _ServicioCard(
                      imagePath: 'assets/imag/tratamiento.jpg',
                      title: 'Tratamientos & Cuidado Especial',
                      description:
                          'Faciales y tratamientos capilares que revitalizan tu piel y cabello. Bienestar y frescura en cada sesión.',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ServiceEstilosTratamientoPage(),
                          ),
                        );
                      },
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
      ..strokeWidth = 1.5;

    canvas.drawLine(Offset(0, size.height * 0.9), Offset(size.width * 0.3, 0), paint);
    canvas.drawLine(Offset(0, size.height * 0.6), Offset(size.width * 0.5, 0), paint);
    canvas.drawLine(Offset(size.width * 0.2, size.height), Offset(size.width * 0.65, 0), paint);
    canvas.drawLine(Offset(size.width * 0.5, size.height), Offset(size.width * 0.9, 0), paint);
    canvas.drawLine(Offset(size.width, size.height * 0.5), Offset(size.width * 0.7, 0), paint);
    canvas.drawLine(Offset(size.width, size.height * 0.9), Offset(size.width * 0.9, 0), paint);

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
  final VoidCallback? onTap;

  const _ServicioCard({
    required this.imagePath,
    required this.title,
    required this.description,
    this.onTap,
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
                height: 260,
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
                GestureDetector(
                  onTap: onTap,
                  child: const Text(
                    'Ver más >',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Georgia',
                    ),
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
