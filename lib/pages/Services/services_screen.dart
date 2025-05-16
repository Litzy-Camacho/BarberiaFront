import 'package:flutter/material.dart';
import 'package:front/pages/Services/service_card.dart';
import 'package:front/pages/Services/service_nav_bar.dart';
import 'package:front/pages/Login/login.dart';  // Importación del login

class ServicesScreen extends StatelessWidget {
  final int categoryId;

  const ServicesScreen({super.key, required this.categoryId});

  // Simulación de inicio de sesión pruebas
  final bool isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    final allServices = [
      {
        'title': 'Corte Clásico',
        'description': 'Un corte tradicional con estilo limpio.',
        'image': 'assets/imag/corteestilo.jpg',
        'price': '\$10',
        'category': 1,
      },
      {
        'title': 'Fade Moderno',
        'description': 'Estilo moderno con degradado preciso.',
        'image': 'assets/imag/corteestilo.jpg',
        'price': '\$12',
        'category': 1,
      },
      {
        'title': 'Afeitado Clásico',
        'description': 'Afeitado con toalla caliente y navaja.',
        'image': 'assets/imag/barbaafeitado.jpg',
        'price': '\$8',
        'category': 2,
      },
      {
        'title': 'Perfilado de Barba',
        'description': 'Define y cuida el contorno de tu barba.',
        'image': 'assets/imag/barbaafeitado.jpg',
        'price': '\$9',
        'category': 2,
      },
      {
        'title': 'Tratamiento Capilar',
        'description': 'Hidratación y nutrición profunda para tu cabello.',
        'image': 'assets/imag/tratamiento.jpg',
        'price': '\$15',
        'category': 3,
      },
      {
        'title': 'Masaje Relajante',
        'description': 'Alivia el estrés y mejora la circulación.',
        'image': 'assets/imag/tratamiento.jpg',
        'price': '\$18',
        'category': 3,
      },
    ];

    final filteredServices =
        allServices.where((s) => s['category'] == categoryId).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Servicios'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          ServiceNavBar(currentIndex: categoryId - 1),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: GridView.builder(
                itemCount: filteredServices.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  final service = filteredServices[index];
                  return ServiceCard(
                    title: service['title'] as String,
                    description: service['description'] as String,
                    imageUrl: service['image'] as String,
                    price: service['price'] as String,
                    onReserve: () {
                      if (isLoggedIn) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Reservación realizada')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).clearMaterialBanners();
                        ScaffoldMessenger.of(context).showMaterialBanner(
                          MaterialBanner(
                            content: const Text('Debes iniciar sesión para reservar.'),
                            leading: const Icon(Icons.info, color: Colors.black),
                            backgroundColor: Colors.white,
                            actions: [
                              TextButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).clearMaterialBanners();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const LoginPage()),
                                  );
                                },
                                child: const Text('Iniciar sesión'),
                              ),
                              TextButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).clearMaterialBanners();
                                },
                                child: const Text('Cerrar'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
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
