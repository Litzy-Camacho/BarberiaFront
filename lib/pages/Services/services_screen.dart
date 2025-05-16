import 'package:flutter/material.dart';
import '../Login/login.dart';
import '../Components/navbar_home.dart';
import '../Home/home_page.dart';
import '../Reservation/reservation_data.dart';

// Simulación de JSON local con campo de duración
final List<Map<String, dynamic>> servicesJson = [
  {
    "id": 1,
    "categoryId": 1,
    "name": "Corte de Cabello",
    "description": "Un corte moderno y a tu estilo.",
    "price": "150.00",
    "duration": "30 min"
  },
  {
    "id": 2,
    "categoryId": 2,
    "name": "Afeitado Clásico",
    "description": "Afeitado con navaja y toalla caliente.",
    "price": "100.00",
    "duration": "20 min"
  },
  {
    "id": 3,
    "categoryId": 3,
    "name": "Tratamiento Capilar",
    "description": "Nutre y fortalece tu cabello.",
    "price": "200.00",
    "duration": "45 min"
  },
  {
    "id": 4,
    "categoryId": 1,
    "name": "Corte con Estilo",
    "description": "Corte premium personalizado.",
    "price": "180.00",
    "duration": "35 min"
  },
];

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  _ServicesScreenState createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  int selectedCategory = 1;

  @override
  Widget build(BuildContext context) {
    final filteredServices = servicesJson
        .where((service) => service['categoryId'] == selectedCategory)
        .toList();
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: CustomAppBar(
              onNavigateToSection: (seccion) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HomePage(scrollTo: seccion.toLowerCase()),
                  ),
                );
              },
              scrollToTop: () {},
            ),
            body: Column(
              children: [
                _buildCategoryBar(),
                Expanded(
        child: OrientationBuilder(
          builder: (context, orientation) {
            final isPortrait = orientation == Orientation.portrait;
            final crossAxisCount = isPortrait ? 2 : 3;
            final spacing = 12.0;

            return LayoutBuilder(
              builder: (context, constraints) {
                double idealItemWidth = (constraints.maxWidth - spacing * (crossAxisCount + 1)) / crossAxisCount;
                // En vertical, cards más altas; en horizontal, cards menos altas:
                double itemHeight = isPortrait ? idealItemWidth * 1.2 : idealItemWidth * 0.9;

                return GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: spacing,
                    crossAxisSpacing: spacing,
                    childAspectRatio: idealItemWidth / itemHeight,
                  ),
                  itemCount: filteredServices.length,
                  itemBuilder: (context, index) {
                    final service = filteredServices[index];
                    return _ServiceCard(
                      title: service['name'],
                      description: service['description'],
                      price: service['price'],
                      duration: service['duration'],
                      imagePath: _getImageForCategory(service['categoryId']),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
        ],
      ),
    );
  }

  Widget _buildCategoryBar() {
    final categories = ['Corte & Estilo', 'Barba & Afeitado', 'Tratamiento & Cuidado'];

    return Column(
      children: [
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final itemWidth = constraints.maxWidth / categories.length;
            return Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(categories.length, (index) {
                    final isSelected = selectedCategory == index + 1;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategory = index + 1;
                        });
                      },
                      child: SizedBox(
                        width: itemWidth,
                        child: Center(
                          child: Text(
                            categories[index],
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? Colors.black : Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  bottom: 0,
                  left: itemWidth * (selectedCategory - 1),
                  child: Container(
                    width: itemWidth,
                    height: 3,
                    color: Colors.black,
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  String _getImageForCategory(int category) {
    switch (category) {
      case 1:
        return 'assets/imag/corteestilo.jpg';
      case 2:
        return 'assets/imag/barbaafeitado.jpg';
      case 3:
        return 'assets/imag/tratamiento.jpg';
      default:
        return 'assets/imag/default.jpg';
    }
  }
}

class _ServiceCard extends StatelessWidget {
  final String imagePath, title, description, price, duration;

  const _ServiceCard({
    required this.imagePath,
    required this.title,
    required this.description,
    required this.price,
    required this.duration,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 6),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
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
                    Colors.black.withOpacity(0.75),
                    Colors.black.withOpacity(0.3),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      height: 1.3,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Text(
                    'Duración: $duration',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$$price',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          textStyle: const TextStyle(fontSize: 12),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AppointmentFormPage(service: title),
                            ),
                          );
                        },
                        child: const Text('Reservar'),
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
