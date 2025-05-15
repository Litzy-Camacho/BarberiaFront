import 'package:flutter/material.dart';
import 'package:front/pages/Home/servicios_section.dart';
import 'package:front/pages/Home/contacto_section.dart';
import '../Login/login.dart';
import '../Clients/user_profile.dart';
import '../Barber/barber_profile.dart';
import '../Administrator/admin_profile.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../Components/navbar_home.dart'; // Barra de navegación personalizada

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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.scrollTo == 'nosotros') {
        _scrollTo(_nosotrosKey);
      } else if (widget.scrollTo == 'servicios') {
        _scrollTo(_serviciosKey);
      } else if (widget.scrollTo == 'contacto') {
        _scrollTo(_contactoKey);
      }
    });
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

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
                  Container(
                    height: 600,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/imag/home.jpg'),
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: DefaultTextStyle(
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth < 600 ? 24 : 40,
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

                  // SECCIÓN NOSOTROS
                  Container(
                    key: _nosotrosKey,
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                    child: Column(
                      children: [
                        Text(
                          'En una era donde el bienestar y la autenticidad toman protagonismo, '
                          'nace Essense, un espacio pensado para quienes buscan reconectar con '
                          'su esencia a través del cuidado personal. Más que un lugar, Essense es '
                          'una experiencia diseñada para elevar el ritual del autocuidado masculino.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: screenWidth < 600 ? 16 : 20,
                            color: Colors.black,
                            height: 1.5,
                            fontFamily: 'Georgia',
                          ),
                        ),
                        const SizedBox(height: 40),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final isMobile = constraints.maxWidth < 900;
                            if (isMobile) {
                              return Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      'assets/imag/nosotros.jpg',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.all(20),
                                    child: const Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
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
                                          'El primer centro integral de cuidado masculino en México. '
                                          'En Essense, entendemos que el hombre actual busca verse bien, '
                                          'sentirse bien y proyectar seguridad en cada aspecto de su vida. '
                                          'Ofrecemos una experiencia completa de cuidado personal, '
                                          'en un espacio cómodo, privado y diseñado especialmente para ti.',
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
                                ],
                              );
                            } else {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.asset(
                                        'assets/imag/nosotros.jpg',
                                        height: 400,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 40),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: const EdgeInsets.all(30),
                                      child: const Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Essense',
                                            style: TextStyle(
                                              fontSize: 36,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontFamily: 'Georgia',
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                          Text(
                                            'El primer centro integral de cuidado masculino en México. '
                                            'En Essense, entendemos que el hombre actual busca verse bien, '
                                            'sentirse bien y proyectar seguridad en cada aspecto de su vida. '
                                            'Ofrecemos una experiencia completa de cuidado personal, '
                                            'en un espacio cómodo, privado y diseñado especialmente para ti.',
                                            style: TextStyle(
                                              fontSize: 18,
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
                              );
                            }
                          },
                        ),
                      ],
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
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Georgia',
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final isMobile = constraints.maxWidth < 800;

                            return isMobile
                                ? Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      const ContactoItem(
                                        icon: Icons.lightbulb_outline,
                                        title: 'Experiencia\nPersonalizada',
                                      ),
                                      const SizedBox(height: 20),
                                      const ContactoItem(
                                        icon: Icons.verified,
                                        title: 'Calidad &\nProfesionalismo',
                                      ),
                                      const SizedBox(height: 20),
                                      const ContactoItem(
                                        icon: Icons.spa,
                                        title: 'Un Espacio\nCómodo Para Ti',
                                      ),
                                      const SizedBox(height: 30),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.asset(
                                          'assets/imag/extra.jpg',
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: 200,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
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
                                  )
                                : Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Column(
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
                                      const SizedBox(width: 40),
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(12),
                                              child: Image.asset(
                                                'assets/imag/extra.jpg',
                                                fit: BoxFit.cover,
                                                height: 280,
                                                width: double.infinity,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Container(
                                              padding: const EdgeInsets.all(16),
                                              decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius: BorderRadius.circular(8),
                                              ),
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
