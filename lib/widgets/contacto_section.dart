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
                padding: const EdgeInsets.symmetric(horizontal: 60),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // IZQUIERDA: Características
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: const [
                          ContactoItem(
                            icon: Icons.lightbulb_outline,
                            title: 'Experiencia Personalizada',
                          ),
                          SizedBox(height: 40),
                          ContactoItem(
                            icon: Icons.verified,
                            title: 'Calidad & Profesionalismo',
                          ),
                          SizedBox(height: 40),
                          ContactoItem(
                            icon: Icons.spa,
                            title: 'Ambiente Privado & Cómodo',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 40),

                    // DERECHA: Imagen + Texto Negro
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              'assets/imag/4.png', // Imagen sección Contacto
                              fit: BoxFit.cover,
                              height: 280,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
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

              // SECCIÓN FINAL: Dirección
              Container(
                color: Colors.black,
                padding: const EdgeInsets.symmetric(
                  vertical: 30,
                  horizontal: 10,
                ),
                child: Column(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget de cada beneficio (ícono + texto)
class ContactoItem extends StatelessWidget {
  final IconData icon;
  final String title;

  const ContactoItem({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Icon(icon, size: 30, color: Colors.black),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
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
