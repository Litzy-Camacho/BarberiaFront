import 'package:flutter/material.dart';
import 'package:front/widgets/servicios_section.dart'; // Importación servicios para el App Bar (Barra Navegación HomePage)
import 'package:front/widgets/contacto_section.dart'; // Importa contacto para el App Bar (Barra Navegación HomePage)
import 'login_page.dart'; // Importa la página de Login
import 'user_page.dart';
import 'barber_page.dart';
import 'admin_page.dart';
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
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: _scrollToNosotros,
              child: const Text(
                'Nosotros',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 20),
            TextButton(
              onPressed: _scrollToServicios,
              child: const Text(
                'Servicios',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 20),
            TextButton(
              onPressed: _scrollToContacto,
              child: const Text(
                'Contacto',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
            child: const Text(
              'Iniciar Sesión',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            // SECCIÓN HOME
            // SECCIÓN HOME
Container(
  height: 600,
  width: double.infinity,
  decoration: const BoxDecoration(
    image: DecorationImage(
      image: AssetImage('assets/imag/10.jpg'),
      fit: BoxFit.cover,
    ),
  ),
  child: Container(
    color: Colors.black.withOpacity(0.8),
    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 80),
    alignment: Alignment.centerLeft,
    child: DefaultTextStyle(
      style: const TextStyle(
        color: Colors.white,
        fontSize: 40, // Tamaño aumentado
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

      // Estructura con imagen y cuadro negro desplazado más abajo en el eje Y
      SizedBox(
        height: 600, // Altura mayor para contener los elementos más grandes
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Imagen más grande
            Positioned(
              left: 150,
              child: Container(
                width: 700, // Aumento del ancho
                height: 450, // Aumento de la altura
                child: Image.asset(
                  'assets/imag/10.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Cuadro negro más grande
            Positioned(
              left: 700, // Se mantiene el mismo desplazamiento a la izquierda
              top: 200,  // Mantiene la misma distancia en el eje Y
              child: Container(
                width: 700, // Aumento del ancho
                height: 450,
                color: Colors.black,
                padding: const EdgeInsets.all(30), // Aumento del padding
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Essense',
                      style: TextStyle(
                        fontSize: 36, // Aumento del tamaño del título
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
                        fontSize: 18, // Aumento del tamaño del texto
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
      const SizedBox(height: 150),
    ],
  ),
),

// SECCIÓN SERVICIOS
ServiciosSection(keyServicios: _serviciosKey),


// SECCIÓN CONTACTO
ContactoSection(keyContacto: _contactoKey),

          ],
        ),
      ),
    );
  }
}
