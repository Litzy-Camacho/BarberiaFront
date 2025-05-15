import 'package:flutter/material.dart';
import 'package:front/pages/Login/login.dart';
import 'package:front/pages/Reservation/reservation_data.dart';
import 'package:front/pages/Services/service_nav_bar.dart';

class ServiceEstilosTratamientoPage extends StatelessWidget {
  const ServiceEstilosTratamientoPage({Key? key}) : super(key: key);

  final List<Map<String, String>> _services = const [
    {
      'image': 'assets/imag/tratamientocuidado.jpg',
      'title': 'Facial Revitalizante',
      'description':
          'Limpieza facial profunda con mascarillas naturales y vapor.',
      'price': '220',
    },
    {
      'image': 'assets/imag/tratamientocuidado.jpg',
      'title': 'Tratamiento Capilar',
      'description':
          'Nutrición intensa para cuero cabelludo y cabello con aceites naturales.',
      'price': '210',
    },
    {
      'image': 'assets/imag/tratamientocuidado.jpg',
      'title': 'Cuidado Total',
      'description':
          'Combinación de limpieza facial, masaje y tratamiento capilar.',
      'price': '300',
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
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                ),
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
          // Pestaña activa = 2
          const ServiceNavBar(currentIndex: 2),
          const SizedBox(height: 40),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.count(
                crossAxisCount: 4,
                mainAxisSpacing: 50,
                crossAxisSpacing: 50,
                childAspectRatio: 250 / 180,
                children:
                    _services
                        .followedBy(_services)
                        .take(9)
                        .map(
                          (svc) => _ServiceCard(
                            imagePath: svc['image']!,
                            title: svc['title']!,
                            description: svc['description']!,
                            price: svc['price']!,
                          ),
                        )
                        .toList(),
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

