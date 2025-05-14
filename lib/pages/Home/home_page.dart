import 'package:flutter/material.dart';
import 'package:front/widgets/servicios_section.dart'; // Importación servicios para el App Bar (Barra Navegación HomePage)
import 'package:front/widgets/contacto_section.dart'; // Importa contacto para el App Bar (Barra Navegación HomePage)
import '../Login/login.dart'; // Importa la página de Login
import '../Clients/user_profile.dart';
import '../Barber/barber_profile.dart';
import '../Administrator/admin_profile.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class HomePage extends StatefulWidget {
  final String? scrollTo; // 'nosotros', 'servicios', 'contacto'

  const HomePage({Key? key, this.scrollTo}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _nosotrosKey = GlobalKey();
  final GlobalKey _serviciosKey = GlobalKey();
  final GlobalKey _contactoKey = GlobalKey();

  void _scrollToNosotros() {
    final context = _nosotrosKey.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _scrollToServicios() {
    final context = _serviciosKey.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _scrollToContacto() {
    final context = _contactoKey.currentContext;
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
        _scrollToNosotros();
      } else if (widget.scrollTo == 'servicios') {
        _scrollToServicios();
      } else if (widget.scrollTo == 'contacto') {
        _scrollToContacto();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF0D0D0D), // Negro muy oscuro
                Color(0xFF1A1A1A), // Gris oscuro
                Color(0xFF2A2A2A), // Gris más claro, puedes ajustar
              ],
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.black,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: SizedBox(
                width: 80,
                height: 80,
                child: Image.asset(
                  'assets/imag/logo.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: _scrollToNosotros,
                  child: const Text('Nosotros', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 20),
                TextButton(
                  onPressed: _scrollToServicios,
                  child: const Text('Servicios', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 20),
                TextButton(
                  onPressed: _scrollToContacto,
                  child: const Text('Contacto', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                },
                child: const Text('Iniciar Sesión', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(width: 10),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
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
                  fit: BoxFit.cover, // Usa BoxFit.contain si quieres que se vea toda sin recorte
                  alignment: Alignment.center,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 80),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: DefaultTextStyle(
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 40, // Tamaño del texto
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
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 60),
                    child: Text(
                      'En una era donde el bienestar y la autenticidad toman protagonismo, '
                      'nace Essense, un espacio pensado para quienes buscan reconectar con '
                      'su esencia a través del cuidado personal. Más que un lugar, Essense es '
                      'una experiencia diseñada para elevar el ritual del autocuidado masculino.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        height: 1.5,
                        fontFamily: 'Georgia',
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    height: 600,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          left: 150,
                          child: Container(
                            width: 700,
                            height: 450,
                            child: Image.asset(
                              'assets/imag/nosotros.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 700,
                          top: 200,
                          child: Container(
                            width: 700,
                            height: 300,
                            color: Colors.black,
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
                    ),
                  ),
                ],
              ),
            ),
            // SECCIÓN SERVICIOS
            ServiciosSection(keyServicios: _serviciosKey),

            Container(
  color: Colors.white, // Fondo blanco para todo el bloque
  child: Column(
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

      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // IZQUIERDA: Características
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
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

            // DERECHA: Imagen + Cuadro de texto
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Image.asset(
                      'assets/imag/extra.jpg',
                      fit: BoxFit.cover,
                      height: 280,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
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
      const SizedBox(height: 50),
    ],
  ),
),

            // SECCIÓN CONTACTO
            ContactoSection(keyContacto: _contactoKey),
          ],
        ),
      ),
    );
  }
}
