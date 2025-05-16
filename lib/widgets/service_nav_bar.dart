import 'package:flutter/material.dart';
import 'services_screen.dart'; // Ajusta el path según tu estructura

class ServiceNavBar extends StatelessWidget {
  final int currentIndex;

  const ServiceNavBar({super.key, required this.currentIndex});

  final List<Map<String, dynamic>> categories = const [
    {'id': 1, 'label': 'Corte & Estilo'},
    {'id': 2, 'label': 'Barba & Afeitado'},
    {'id': 3, 'label': 'Tratamientos & Cuidado Especial'},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(categories.length, (index) {
          final category = categories[index];
          final isSelected = index == currentIndex;

          return GestureDetector(
            onTap: () {
              if (!isSelected) {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) =>
                        ServicesScreen(categoryId: category['id'] as int),
                    transitionDuration: const Duration(milliseconds: 200),
                    transitionsBuilder: (_, animation, __, child) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                  ),
                );
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.black : Colors.grey[300],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                category['label']!,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
