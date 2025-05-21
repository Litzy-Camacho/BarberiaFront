import 'package:flutter/material.dart';
import '../Services/services_screen.dart';

class ServiciosSection extends StatefulWidget {
  final GlobalKey keyServicios;

  const ServiciosSection({super.key, required this.keyServicios});

  @override
  State<ServiciosSection> createState() => _ServiciosSectionState();
}

class _ServiciosSectionState extends State<ServiciosSection> {
  final PageController _pageController = PageController(viewportFraction: 1.0);
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      int page = _pageController.page!.round();
      if (page != _currentPage) {
        setState(() {
          _currentPage = page;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: widget.keyServicios,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/imag/fondovertical.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
        child: Column(
          children: [
            const Text(
              'Nuestros servicios',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Georgia',
              ),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'Todos nuestros servicios se realizan en cabinas privadas y son exclusivos para hombre.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                  height: 1.5,
                  fontFamily: 'Georgia',
                ),
              ),
            ),
            const SizedBox(height: 50),
            SizedBox(
              height: 450,
              child: PageView(
                controller: _pageController,
                children: [
                  _ServicioCard(
                    imagePath: 'assets/imag/estilos.jpg',
                    title: 'Corte & Estilo',
                    description:
                        'Cortes clásicos, modernos y ejecutivos adaptados a tu personalidad. Precisión, técnica y estilo en cada visita.',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ServicesScreen(initialCategory: 1),
                        ),
                      );
                    },
                  ),
                  _ServicioCard(
                    imagePath: 'assets/imag/barba.jpg',
                    title: 'Barba & Afeitado',
                    description:
                        'Perfilado, diseño y afeitado tradicional con toalla caliente. Cuida tu barba con detalle y estilo.',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ServicesScreen(initialCategory: 2),
                        ),
                      );
                    },
                  ),
                  _ServicioCard(
                    imagePath: 'assets/imag/tratamiento.jpg',
                    title: 'Tratamientos & Cuidado Especial',
                    description:
                        'Faciales y tratamientos capilares que revitalizan tu piel y cabello. Bienestar y frescura en cada sesión.',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ServicesScreen(initialCategory: 3),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  width: _currentPage == index ? 12 : 8,
                  height: _currentPage == index ? 12 : 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index ? Colors.white : Colors.white38,
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _ServicioCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final VoidCallback? onTap;

  const _ServicioCard({
    required this.imagePath,
    required this.title,
    required this.description,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 420,
        width: 320,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
              child: Image.asset(
                imagePath,
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Georgia',
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Text(
                        description,
                        textAlign: TextAlign.center,
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          fontFamily: 'Georgia',
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Divider(
                      color: Colors.black.withOpacity(0.2),
                      thickness: 1,
                    ),
                    const SizedBox(height: 5),
                    GestureDetector(
                      onTap: onTap,
                      child: const Text(
                        'Ver más >',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Georgia',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
