import 'package:flutter/material.dart';
import 'package:front/pages/Login/login.dart';
import 'package:front/pages/Reservation/reservation_data.dart';
import 'package:front/widgets/service_nav_bar.dart';

class ServiceCorteEstiloPage extends StatelessWidget {
  const ServiceCorteEstiloPage({Key? key}) : super(key: key);

  final List<Map<String, String>> _services = const [
    {
      'image': 'assets/imag/corteestilo.jpg',
      'title': 'Corte & Estilo',
      'description':
          'Corte tradicional realizado con la combinación perfecta de tijera y máquina.',
      'price': '200',
    },
    {
      'image': 'assets/imag/corteestilo.jpg',
      'title': 'Corte Clásico',
      'description':
          'Corte con técnicas modernas y personalización según tu estilo.',
      'price': '180',
    },
    {
      'image': 'assets/imag/corteestilo.jpg',
      'title': 'Corte Premium',
      'description': 'Incluye lavado, masaje capilar y estilizado profesional.',
      'price': '250',
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
            onPressed: () => Navigator.push(
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
          // Navegación interna de servicios
          const ServiceNavBar(currentIndex: 0),
          const SizedBox(height: 40),
          // Grid de tarjetas con responsividad
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10), // Reducir margen
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Determina el número de columnas basado en el ancho de la pantalla
                  int crossAxisCount = 4;
                  double aspectRatio = 250 / 180; // Aspect ratio por defecto

                  if (constraints.maxWidth < 600) {
                    crossAxisCount = 2; // Dos columnas en pantallas pequeñas
                    aspectRatio = 1.5; // Ajuste del ratio para pantallas pequeñas
                  } else if (constraints.maxWidth < 1000) {
                    crossAxisCount = 3; // Tres columnas en pantallas medianas
                  }

                  return GridView.count(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    childAspectRatio: aspectRatio,
                    children: _services
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
                  );
                },
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
              padding: const EdgeInsets.all(16), // Reduce el padding para pantallas pequeñas
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18, // Reduce el tamaño de la fuente
                      fontFamily: 'Georgia',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Text(
                      description,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12, // Reducir el tamaño de la fuente en pantallas pequeñas
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
                          fontSize: 16, // Ajuste de tamaño de texto
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
