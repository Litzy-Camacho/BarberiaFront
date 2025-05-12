import 'package:flutter/material.dart';
import 'package:front/pages/login_page.dart';
import 'package:front/pages/appointment_form_page.dart';
import 'package:front/widgets/service_nav_bar.dart';

class ServiceBarbaPage extends StatelessWidget {
  const ServiceBarbaPage({Key? key}) : super(key: key);

  final List<Map<String, String>> _services = const [
    {
      'image': 'assets/imag/barbaafeitado.jpg',
      'title': 'Perfilado de Barba',
      'description':
          'Diseño de barba con navaja, toalla caliente y aceites esenciales.',
      'price': '180',
    },
    {
      'image': 'assets/imag/barbaafeitado.jpg',
      'title': 'Afeitado Clásico',
      'description':
          'Afeitado con espuma caliente, técnica tradicional y productos relajantes.',
      'price': '160',
    },
    {
      'image': 'assets/imag/barbaafeitado.jpg',
      'title': 'Barba & Facial',
      'description':
          'Servicio combinado de arreglo de barba y limpieza facial profunda.',
      'price': '220',
    },
  ];

  void _goHome(BuildContext context) {
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () => _goHome(context),
              child: const Text(
                'Nosotros',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 20),
            TextButton(
              onPressed: () => _goHome(context),
              child: const Text(
                'Servicios',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 20),
            TextButton(
              onPressed: () => _goHome(context),
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
                MaterialPageRoute(builder: (_) => const LoginPage()),
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
      body: Column(
        children: [
          const SizedBox(height: 30),
          const ServiceNavBar(currentIndex: 1),
          const SizedBox(height: 40),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.count(
                crossAxisCount: 4,
                mainAxisSpacing: 50,
                crossAxisSpacing: 50,
                childAspectRatio: 250 / 180,
                children: _services.followedBy(_services).take(9).map((svc) {
                  return _ServiceCard(
                    imagePath: svc['image']!,
                    title: svc['title']!,
                    description: svc['description']!,
                    price: svc['price']!,
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final String imagePath, title, description, price;

  const _ServiceCard({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.8), blurRadius: 6),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            Image.asset(
              imagePath,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.8), // Mucho más oscuro en la parte superior
                    Colors.black.withOpacity(0.5), // Menos opacidad en la parte inferior
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(34), // Aumentar el padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'Georgia',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Text(
                      description,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$$price',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Georgia',
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          textStyle: const TextStyle(fontSize: 12),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  AppointmentFormPage(service: title),
                            ),
                          );
                        },
                        child: const Text('Reservar cita'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

