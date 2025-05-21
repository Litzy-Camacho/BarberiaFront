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

Widget build(BuildContext context) {
  final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  final iconSize = isLandscape ? 18.0 : 24.0;
  final textSize = isLandscape ? 13.0 : 16.0;
  final socialIconSize = isLandscape ? 18.0 : 28.0;

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
        child: Stack(
          children: [
            // Imagen de fondo
            Positioned.fill(
              child: Image.asset(
                'assets/imag/fondo.jpg', // Asegúrate de tener esta imagen en tu proyecto
                fit: BoxFit.cover,
              ),
            ),
            // Capa con contenido
            Container(
              padding: EdgeInsets.symmetric(
                vertical: screenHeight * 0.04,
                horizontal: screenWidth * 0.05,
              ),
              // Capa oscura semitransparente sobre la imagen
              child: isLandscape
                  ? Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Flexible(
                              flex: 3,
                              child: ContactInfoRow(
                                icon: Icons.email,
                                text: 'barbercode@gmail.com',
                                isClickable: false,
                                iconSize: iconSize,
                                textSize: textSize,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Flexible(
                              flex: 4,
                              child: ContactInfoRow(
                                icon: Icons.location_on,
                                text: '20 de Noviembre #34\nCentro Histórico, Morelia',
                                isClickable: true,
                                iconSize: iconSize,
                                textSize: textSize,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Flexible(
                              flex: 3,
                              child: Column(
                                children: [
                                  ContactInfoRow(
                                    icon: Icons.phone,
                                    text: '443 4632 2732',
                                    isClickable: true,
                                    iconSize: iconSize,
                                    textSize: textSize,
                                    textAlign: TextAlign.center,
                                  ),
                                  SocialIconsRow(
                                    iconSize: socialIconSize,
                                    isCentered: true,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ContactInfoRow(
                          icon: Icons.email,
                          text: 'barbercode@gmail.com',
                          isClickable: false,
                          iconSize: iconSize,
                          textSize: textSize,
                          textAlign: TextAlign.center,
                        ),
                        ContactInfoRow(
                          icon: Icons.location_on,
                          text: '20 de Noviembre #34\nCentro Histórico, Morelia',
                          isClickable: true,
                          iconSize: iconSize,
                          textSize: textSize,
                          textAlign: TextAlign.center,
                        ),
                        ContactInfoRow(
                          icon: Icons.phone,
                          text: '443 4632 2732',
                          isClickable: true,
                          iconSize: iconSize,
                          textSize: textSize,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        SocialIconsRow(iconSize: socialIconSize, isCentered: true),
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

class ContactInfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isClickable;
  final double iconSize;
  final double textSize;
  final TextAlign textAlign;

  const ContactInfoRow({
    super.key,
    required this.icon,
    required this.text,
    this.isClickable = true,
    required this.iconSize,
    required this.textSize,
    this.textAlign = TextAlign.center,
  });

  Future<void> _handleTap(String text) async {
    if (text.contains('@')) return;

    if (text == '443 4632 2732') {
      final phone = text.replaceAll(RegExp(r'\s+'), '');
      final uri = Uri(scheme: 'tel', path: phone);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    } else {
      final uri = Uri.parse('https://maps.app.goo.gl/Hp9RMw4Jc6jW8wCw6');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final content = Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: iconSize),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              textAlign: textAlign,
              softWrap: true,
              style: TextStyle(
                color: Colors.white,
                fontSize: textSize,
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
  final double iconSize;
  final bool isCentered;

  const SocialIconsRow({
    super.key,
    this.iconSize = 28.0,
    this.isCentered = true,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: isCentered ? WrapAlignment.center : WrapAlignment.end,
      spacing: 20,
      children: [
        Icon(FontAwesomeIcons.facebook, color: Colors.white, size: iconSize),
        Icon(FontAwesomeIcons.instagram, color: Colors.white, size: iconSize),
      ],
    );
  }
}
