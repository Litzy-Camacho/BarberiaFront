import 'package:flutter/material.dart';
import 'package:front/widgets/servicios_section.dart'; // Importación servicios para el App Bar (Barra Navegación HomePage)
import 'package:front/widgets/contacto_section.dart'; // Importa contacto para el App Bar (Barra Navegación HomePage)
import 'login_page.dart'; // Importa la página de Login
import 'user_page.dart';
import 'barber_page.dart';
import 'admin_page.dart';

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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 80),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Ven, siéntete único\n'
                      'y reserva tu cita\n'
                      'para vivir una\n'
                      'experiencia\n'
                      'auténtica.',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        height: 1.3,
                        fontFamily: 'Georgia',
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Image.asset(
                      'assets/imag/2.png', // Imagen Pantalla Principal
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 200),

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
                  Row(
                    children: [
                      Expanded(
                        child: Image.asset(
                          'assets/imag/3.png', // Imagen sección NOSOTROS
                          fit: BoxFit.cover,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          color: Colors.black,
                          padding: const EdgeInsets.all(40),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Essense',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: 'Georgia',
                                ),
                              ),
                              SizedBox(height: 20),
                              Text(
                                'El primer centro integral de cuidado masculino en México...',
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
                ],
              ),
            ),
            const SizedBox(height: 200),

            // SECCIÓN SERVICIOS
            ServiciosSection(keyServicios: _serviciosKey),
            const SizedBox(height: 200),

            // SECCIÓN CONTACTO
            ContactoSection(keyContacto: _contactoKey),
          ],
        ),
      ),
    );
  }
}
