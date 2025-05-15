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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      key: widget.keyContacto,
      color: Colors.white,
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    color: Colors.black,
                    padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.04,
                      horizontal: screenWidth * 0.05,
                    ),
                    child: Column(
                      children: [
                        const ContactInfoRow(
                          icon: Icons.email,
                          text: 'essence_barber@gmail.com',
                        ),
                        const ContactInfoRow(
                          icon: Icons.location_on,
                          text:
                              '20 de Noviembre #34\nCentro Histórico, Morelia',
                        ),
                        const ContactInfoRow(
                          icon: Icons.phone,
                          text: '443 4632 2732',
                        ),
                        Container(
                          color: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            spacing: screenWidth * 0.06,
                            children: const [
                              Icon(FontAwesomeIcons.facebook,
                                  color: Colors.white),
                              Icon(FontAwesomeIcons.instagram,
                                  color: Colors.white),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class ContactoItem extends StatelessWidget {
  final IconData icon;
  final String title;

  const ContactoItem({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.black),
            const SizedBox(height: 8),
            Container(
              width: 2,
              height: 40,
              color: Colors.black,
            ),
          ],
        ),
        const SizedBox(width: 12),
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

class ContactInfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const ContactInfoRow({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
