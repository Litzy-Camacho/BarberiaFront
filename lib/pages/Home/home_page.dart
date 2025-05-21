import 'package:flutter/material.dart';
import 'package:front/pages/Home/servicios_section.dart';
import 'package:front/pages/Components/contacto_section.dart';
import '../Login/login.dart';
import '../Clients/user_profile.dart';
import '../Barber/barber_profile.dart';
import '../Administrator/admin_profile.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../Components/navbar_home.dart'; // Barra de navegación personalizada
import 'dart:math';
import 'dart:async';


class HomePage extends StatefulWidget {
  final String? scrollTo;

  const HomePage({Key? key, this.scrollTo}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _nosotrosKey = GlobalKey();
  final GlobalKey _serviciosKey = GlobalKey();
  final GlobalKey _contactoKey = GlobalKey();
  int currentIndex = 0;
late Timer _timer;
  
  final List<IconData> icons = [
  Icons.lightbulb_outline,
  Icons.verified,
  Icons.spa,
];

final List<String> images = [
  'assets/imag/a.jpg',
  'assets/imag/b.jpg',
  'assets/imag/c.jpg',
];

final List<String> texts = [
  'Atención personalizada en cada visita.',
  'Comprometidos con la calidad y el profesionalismo.',
  'Ambiente relajante diseñado para ti.',
];


  String currentSection = 'Inicio';

  void _scrollTo(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  @override
void initState() {
  super.initState();
  _scrollController.addListener(_updateCurrentSection);
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (widget.scrollTo == 'nosotros') {
      _scrollTo(_nosotrosKey);
    } else if (widget.scrollTo == 'servicios') {
      _scrollTo(_serviciosKey);
    } else if (widget.scrollTo == 'contacto') {
      _scrollTo(_contactoKey);
    }
  });
  _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
    setState(() {
      currentIndex = (currentIndex + 1) % icons.length;
    });
  });
}

@override
void dispose() {
  _scrollController.removeListener(_updateCurrentSection);
  _scrollController.dispose();
  _timer.cancel();
  super.dispose();
}

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _onNavigateToSection(String section) {
    switch (section.toLowerCase()) {
      case 'nosotros':
        _scrollTo(_nosotrosKey);
        break;
      case 'servicios':
        _scrollTo(_serviciosKey);
        break;
      case 'contacto':
        _scrollTo(_contactoKey);
        break;
      case 'inicio':
        _scrollToTop();
        break;
      default:
        break;
    }
  }

  void _updateCurrentSection() {
  final RenderBox? nosotrosBox = _nosotrosKey.currentContext?.findRenderObject() as RenderBox?;
  final RenderBox? serviciosBox = _serviciosKey.currentContext?.findRenderObject() as RenderBox?;
  final RenderBox? contactoBox = _contactoKey.currentContext?.findRenderObject() as RenderBox?;

  final offset = _scrollController.offset;

  String newSection = 'Inicio';

  if (contactoBox != null && offset >= contactoBox.localToGlobal(Offset.zero).dy - 200) {
    newSection = 'Contacto';
  } else if (serviciosBox != null && offset >= serviciosBox.localToGlobal(Offset.zero).dy - 200) {
    newSection = 'Servicios';
  } else if (nosotrosBox != null && offset >= nosotrosBox.localToGlobal(Offset.zero).dy - 200) {
    newSection = 'Nosotros';
  }

  if (newSection != currentSection) {
    setState(() {
      currentSection = newSection;
    });
  }
}

  @override
  Widget build(BuildContext context) {
 
final screenSize = MediaQuery.of(context).size;
final screenWidth = screenSize.width;
final screenHeight = screenSize.height;
final orientation = MediaQuery.of(context).orientation;

// Altura dinámica
final imageHeight = orientation == Orientation.landscape
    ? screenHeight * 0.8 // 🔽 Disminuye más la altura en horizontal
    : screenWidth < 600
        ? screenHeight * 0.5
        : 600.0;

// Imagen según orientación
final backgroundImage = orientation == Orientation.landscape
    ? 'assets/imag/homehorizontal.jpg'
    : 'assets/imag/homevertical.jpg';

// Tamaño del texto según orientación y ancho
final textFontSize = orientation == Orientation.landscape
    ? 20.0
    : screenWidth < 600
        ? 24.0
        : 40.0;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // Barra de navegación personalizada
          CustomAppBar(
            onNavigateToSection: _onNavigateToSection,
            scrollToTop: _scrollToTop,
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  // SECCIÓN HOME
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: imageHeight,
                          width: double.infinity,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(backgroundImage),
                                fit: BoxFit.cover,
                                alignment: Alignment.center,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: imageHeight,
                          width: double.infinity,
                          color: Colors.black.withOpacity(0.5),
                        ),
                        Container(
                          height: imageHeight,
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: DefaultTextStyle(
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: textFontSize,
                                  height: 1.3,
                                  fontFamily: 'Georgia',
                                ),
                                child: AnimatedTextKit(
                                  isRepeatingAnimation: false,
                                  animatedTexts: [
                                    TypewriterAnimatedText(
                                      'Ven, siéntete único\ny reserva tu cita\npara vivir una\nexperiencia\nauténtica.',
                                      speed: const Duration(milliseconds: 80),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
  // SECCIÓN NOSOTROS
Container(
  key: _nosotrosKey,
  color: Colors.white,
  padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(8),
    child: Stack(
      children: [
        // Imagen de fondo
        Image.asset(
          'assets/imag/nosotros.jpg',
          fit: BoxFit.cover,
          width: double.infinity,
        ),

        // Degradado más oscuro
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.95), // más oscuro
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // Texto arriba
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Essense',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Georgia',
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  
                  'Entendemos que el hombre actual busca verse bien, '
                  'sentirse bien y proyectar seguridad en cada aspecto de su vida. ',
                  
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    height: 1.6,
                    fontFamily: 'Georgia',
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  ),
),
                  // SECCIÓN SERVICIOS
                  ServiciosSection(keyServicios: _serviciosKey),
// SECCIÓN ¿Por qué elegirnos?
                  Container(
  color: Colors.white,
  padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
  child: Column(
    children: [
      const Text(
        '¿Por qué elegirnos?',
        style: TextStyle(
          fontSize: 24, // Tamaño reducido
          fontWeight: FontWeight.bold,
          fontFamily: 'Georgia',
          color: Colors.black,
        ),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 40),
      LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(icons.length, (index) {
              final isActive = index == currentIndex;
              return Row(
                children: [
                  AnimatedScale(
                    scale: isActive ? 1.5 : 1.0,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      icons[index],
                      size: 50,
                      color: Colors.black,
                    ),
                  ),
                  if (index < icons.length - 1) ...[
                    const SizedBox(width: 20),
                    Container(width: 30, height: 2, color: Colors.black),
                    const SizedBox(width: 20),
                  ],
                ],
              );
            }),
          );
        },
      ),
      const SizedBox(height: 30),
      LayoutBuilder(
        builder: (context, constraints) {
          double size = constraints.maxWidth;
          return ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: size,
              height: size, // Para que sea cuadrada
              child: Stack(
                children: [
                  Image.asset(
                    images[currentIndex],
                    fit: BoxFit.cover,
                    width: size,
                    height: size,
                  ),
                  Container(
                    width: size,
                    height: size,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black87, // más oscuro
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Text(
                      texts[currentIndex],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Georgia',
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ],
  ),
),

                  // SECCIÓN CONTACTO
                  ContactoSection(keyContacto: _contactoKey),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DividerLine extends StatelessWidget {
  const DividerLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30, // Longitud de la línea
      height: 2, // Grosor de la línea
      color: Colors.black,
    );
  }
}


class ContactoItem extends StatelessWidget {
  final IconData icon;
  final String title;

  const ContactoItem({Key? key, required this.icon, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 60, color: Colors.black),
        const SizedBox(height: 20),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Georgia',
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
