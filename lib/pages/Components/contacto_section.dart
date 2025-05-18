import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:url_launcher/url_launcher.dart';

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
                      children: const [
                        ContactInfoRow(
                          icon: Icons.email,
                          text: 'essence_barber@gmail.com',
                          isClickable: false, // No hace nada
                        ),
                        ContactInfoRow(
                          icon: Icons.location_on,
                          text:
                              '20 de Noviembre #34\nCentro Histórico, Morelia',
                          isClickable: true, // Abre Google Maps
                        ),
                        ContactInfoRow(
                          icon: Icons.phone,
                          text: '443 4632 2732',
                          isClickable: true,
                        ),
                        SizedBox(height: 10),
                        SocialIconsRow(),
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

class ContactInfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isClickable;

  const ContactInfoRow({
    super.key,
    required this.icon,
    required this.text,
    this.isClickable = true,
  });

 Future<void> _handleTap(String text) async {
  if (text.contains('@')) {
    // No hacer nada si es correo
    return;
  } else if (text == '443 4632 2732') {
    // Detecta explícitamente si es el número telefónico
    final phone = text.replaceAll(RegExp(r'\s+'), '');
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  } else {
    // Cualquier otro texto lo tratamos como dirección
    final uri = Uri.parse('https://maps.app.goo.gl/Hp9RMw4Jc6jW8wCw6');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('No se pudo abrir el enlace de Google Maps.');
    }
  }
}


  @override
  Widget build(BuildContext context) {
    final content = Container(
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
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );

    return isClickable
        ? InkWell(onTap: () => _handleTap(text), child: content)
        : content;
  }
}

class SocialIconsRow extends StatelessWidget {
  const SocialIconsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: MediaQuery.of(context).size.width * 0.06,
      children: const [
        Icon(FontAwesomeIcons.facebook, color: Colors.white),
        Icon(FontAwesomeIcons.instagram, color: Colors.white),
      ],
    );
  }
}
