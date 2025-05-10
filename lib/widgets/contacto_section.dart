import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ContactoSection extends StatefulWidget {
  final GlobalKey keyContacto;

  const ContactoSection({super.key, required this.keyContacto});

  @override
  State<ContactoSection> createState() => _ContactoSectionState();
}

class _ContactoSectionState extends State<ContactoSection> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: widget.keyContacto,
      color: Colors.white, // Fondo blanco
      child: VisibilityDetector(
        key: const Key('contacto-section'),
        onVisibilityChanged: (info) {
          if (info.visibleFraction > 0.3 && !_isVisible) {
            setState(() {
              _isVisible = true;
            });
          }
        },
        child: AnimatedOpacity(
          opacity: _isVisible ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              const Text(
                '¿Por qué elegirnos?',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Georgia',
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),

              // Contenido principal
              Padding(
  padding: const EdgeInsets.symmetric(horizontal: 20),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      // IZQUIERDA: Características
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.3, // Ajusta según sea necesario
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            ContactoItem(
              icon: Icons.lightbulb_outline,
              title: 'Experiencia\nPersonalizada',
            ),
            SizedBox(height: 20),
            ContactoItem(
              icon: Icons.verified,
              title: 'Calidad &\nProfesionalismo',
            ),
            SizedBox(height: 20),
            ContactoItem(
              icon: Icons.spa,
              title: 'Un Espacio\nCómodo Para Ti',
            ),
          ],
        ),
      ),
      const SizedBox(width: 30),

      // DERECHA: Imagen + Cuadro con texto debajo
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.4,
        child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center, // Centrado horizontal
                        children: [
                          // Imagen sin bordes redondeados
                          Container(
                            width: MediaQuery.of(context).size.width * 0.4, // 80% del ancho de la pantalla
                            child: Image.asset(
                              'assets/imag/4.png', // Imagen sección Contacto
                              fit: BoxFit.cover,
                              height: 280,
                            ),
                          ),
                          
                          Container(
                            width: MediaQuery.of(context).size.width * 0.4, // 80% del ancho de la pantalla
                            padding: const EdgeInsets.all(16),
                            color: Colors.black,
                            child: const Text(
                              'En Essense, cada cliente recibe atención personalizada en un ambiente privado y cómodo.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'Georgia',
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 80),

              // SECCIÓN FINAL: Dirección con líneas diagonales
Container(
  color: Colors.black,
  padding: const EdgeInsets.symmetric(
    vertical: 30,
    horizontal: 10,
  ),
  child: Stack(
    children: [
      // Fondo con líneas diagonales cruzadas
      Positioned.fill(
        child: ClipRect(
          child: CustomPaint(
            painter: LineasDecorativasLateralesPainter(),
          ),
        ),
      ),
      // Contenido de la sección de contacto
      Column(
        children: [
          ContactInfoRow(
            icon: Icons.email,
            text: 'correo@essense.com',
          ),
          const SizedBox(height: 15),
          ContactInfoRow(
            icon: Icons.location_on,
            text: 'Dirección #34, Colonia, Ciudad',
          ),
          const SizedBox(height: 15),
          ContactInfoRow(icon: Icons.phone, text: '+52 123 456 7890'),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(FontAwesomeIcons.facebook, color: Colors.white),
              SizedBox(width: 15),
              Icon(
                FontAwesomeIcons.instagram,
                color: Colors.pinkAccent,
              ),
            ],
          ),
        ],
      ),
    ],
  ),
),
            ],
          ),
        ),
      ),
    );
  }
}

class LineasDecorativasLateralesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1;

    // === LADO IZQUIERDO ===
    canvas.drawLine(
      Offset(-size.width * 0.1, size.height * 0.02),
      Offset(size.width * 0.4, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(-size.width * 0.1, size.height),
      Offset(size.width * 0.4, 0),
      paint,
    );

    // Líneas adicionales en el lado izquierdo
    canvas.drawLine(
      Offset(-size.width * 0.2, size.height * 0.1),
      Offset(size.width * 0.3, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(-size.width * 0.2, size.height),
      Offset(size.width * 0.3, 0),
      paint,
    );

    // === LADO DERECHO ===
    canvas.drawLine(
      Offset(size.width * 1.1, size.height * 0.02),
      Offset(size.width * 0.6, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 1.1, size.height),
      Offset(size.width * 0.6, 0),
      paint,
    );

    // Líneas adicionales en el lado derecho
    canvas.drawLine(
      Offset(size.width * 1.2, size.height * 0.1),
      Offset(size.width * 0.7, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 1.2, size.height),
      Offset(size.width * 0.7, 0),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}



// Widget de cada beneficio (ícono + texto)
// Widget de cada beneficio (ícono + texto)
class ContactoItem extends StatelessWidget {
  final IconData icon;
  final String title;

  const ContactoItem({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center, // Asegura que estén alineados en el eje vertical
      children: [
        // Ícono más grande y línea debajo
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.black), // Aumentado el tamaño del ícono
            const SizedBox(height: 8), // Espaciado entre el ícono y la línea
            // Línea vertical más larga debajo del ícono
            Container(
              width: 2,
              height: 40, // Alargada la línea vertical
              color: Colors.black,
            ),
          ],
        ),
        const SizedBox(width: 12), // Espacio entre el ícono+línea y el texto
        // Texto alineado con el ícono sobre el mismo eje horizontal
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontFamily: 'Georgia',
          ),
        ),
      ],
    );
  }
}


// Widget de cada fila de contacto (ícono + texto)
class ContactInfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const ContactInfoRow({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.white),
        const SizedBox(width: 10),
        Text(text, style: TextStyle(color: Colors.white, fontSize: 16)),
      ],
    );
  }
}
