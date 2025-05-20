import 'package:flutter/material.dart';
import '../Login/login.dart';
import '../Components/navbar_home.dart';
import '../Home/home_page.dart';
import '../Reservation/reservation_data.dart';
import '../Components/contacto_section.dart';
import 'package:flutter/services.dart'; 

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

class ServicesScreenAdmin extends StatefulWidget {
  const ServicesScreenAdmin({super.key});

  @override
  _ServicesScreenAdminState createState() => _ServicesScreenAdminState();
}

class _ServicesScreenAdminState extends State<ServicesScreenAdmin> {
  final GlobalKey contactoKey = GlobalKey();
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
      body: OrientationBuilder(
        builder: (context, orientation) {
          final isPortrait = orientation == Orientation.portrait;
          final crossAxisCount = isPortrait ? 2 : 3;
          final spacing = 12.0;

          return LayoutBuilder(
            builder: (context, constraints) {
              double idealItemWidth =
                  (constraints.maxWidth - spacing * (crossAxisCount + 1)) / crossAxisCount;
              double itemHeight = isPortrait ? idealItemWidth * 1.2 : idealItemWidth * 0.9;

              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _buildCategoryBar(),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
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
                                  onEdit: () => _showEditDialog(service),
                                  onDelete: () => _showDeleteDialog(service),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                  ContactoSection(keyContacto: contactoKey),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildCategoryBar() {
    final categories = [
      'Corte & Estilo',
      'Barba & Afeitado',
      'Tratamiento & Cuidado'
    ];

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



void _showEditDialog(Map<String, dynamic> service) {
  final nameController = TextEditingController(text: service['name']);
  final descriptionController = TextEditingController(text: service['description']);
  final priceController = TextEditingController(text: service['price']);
  final durationController = TextEditingController(
    text: service['duration'].toString().replaceAll(' min', ''),
  );

  bool isValid = true;

  bool isNameValid(String text) {
    return RegExp(r'^[a-zA-Z\s]+$').hasMatch(text) && text.isNotEmpty;
  }

  bool isDescriptionValid(String text) {
    return text.isNotEmpty;
  }

  bool isPriceValid(String text) {
    return RegExp(r'^\d+(\.\d{0,2})?$').hasMatch(text);
  }

  bool isDurationValid(String text) {
    return RegExp(r'^\d{2}$').hasMatch(text);
  }

  void validateForm() {
    final name = nameController.text.trim();
    final description = descriptionController.text.trim();
    final price = priceController.text.trim();
    final duration = durationController.text.trim();

    final valid = isNameValid(name) &&
        isDescriptionValid(description) &&
        isPriceValid(price) &&
        isDurationValid(duration);

    if (valid != isValid) {
      setState(() {
        isValid = valid;
      });
    }
  }

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(builder: (context, setState) {
        final nameText = nameController.text.trim();
        final descriptionText = descriptionController.text.trim();
        final priceText = priceController.text.trim();
        final durationText = durationController.text.trim();

        Color nameColor() {
          if (nameText.isEmpty) return Colors.black;
          return isNameValid(nameText) ? Colors.green : Colors.red;
        }

        Color descriptionColor() {
          if (descriptionText.isEmpty) return Colors.black;
          return isDescriptionValid(descriptionText) ? Colors.green : Colors.red;
        }

        Color priceColor() {
          if (priceText.isEmpty) return Colors.black;
          return isPriceValid(priceText) ? Colors.green : Colors.red;
        }

        Color durationColor() {
          if (durationText.isEmpty) return Colors.black;
          return isDurationValid(durationText) ? Colors.green : Colors.red;
        }

        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Editar Servicio'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Nombre
                TextField(
                  controller: nameController,
                  cursorColor: nameColor(),
                  onChanged: (value) {
                    validateForm();
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    labelText: 'Nombre',
                    labelStyle: TextStyle(color: nameColor()),
                    errorText: nameText.isNotEmpty && !isNameValid(nameText)
                        ? 'Solo letras permitidas'
                        : null,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: nameColor()),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: nameColor()),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Descripción
                TextField(
                  controller: descriptionController,
                  cursorColor: descriptionColor(),
                  onChanged: (value) {
                    validateForm();
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    labelText: 'Descripción',
                    labelStyle: TextStyle(color: descriptionColor()),
                    errorText: descriptionText.isNotEmpty && !isDescriptionValid(descriptionText)
                        ? 'Descripción requerida'
                        : null,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: descriptionColor()),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: descriptionColor()),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Precio
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  cursorColor: priceColor(),
                  onChanged: (value) {
                    validateForm();
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    labelText: 'Precio',
                    labelStyle: TextStyle(color: priceColor()),
                    errorText: priceText.isNotEmpty && !isPriceValid(priceText)
                        ? 'Máximo 2 decimales permitidos'
                        : null,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: priceColor()),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: priceColor()),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Duración
                TextField(
                  controller: durationController,
                  keyboardType: TextInputType.number,
                  maxLength: 2,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(2),
                  ],
                  cursorColor: durationColor(),
                  onChanged: (value) {
                    validateForm();
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    labelText: 'Duración (en minutos)',
                    counterText: "",
                    labelStyle: TextStyle(color: durationColor()),
                    errorText: durationText.isNotEmpty && !isDurationValid(durationText)
                        ? 'Tiempo inválido (2 dígitos)'
                        : null,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: durationColor()),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: durationColor()),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  onPressed: isValid
                      ? () {
                          final durationValue = durationController.text.trim();
                          final durationFinal = durationValue.endsWith('min')
                              ? durationValue
                              : '$durationValue min';

                          setState(() {
                            service['name'] = nameController.text.trim();
                            service['description'] = descriptionController.text.trim();
                            service['price'] = priceController.text.trim();
                            service['duration'] = durationFinal;
                          });

                          Navigator.of(context).pop();

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Servicio actualizado'),
                              backgroundColor: Colors.green,
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      : null,
                  child: const Text('Guardar', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        );
      });
    },
  );
}

  void _showDeleteDialog(Map<String, dynamic> service) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white, // Fondo blanco del cuadro de diálogo
        title: const Text('Confirmar eliminación'),
        content: Text('¿Estás seguro de que deseas eliminar el servicio "${service['name']}"?'),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancelar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    servicesJson.remove(service);
                  });
                  Navigator.pop(context);

                  // Mostrar SnackBar
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Servicio eliminado'),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                child: const Text(
                  'Aceptar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}
}

class _ServiceCard extends StatelessWidget {
  final String imagePath, title, description, price, duration;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ServiceCard({
    required this.imagePath,
    required this.title,
    required this.description,
    required this.price,
    required this.duration,
    required this.onEdit,
    required this.onDelete,
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
                  const SizedBox(height: 8),
                  Text(
                    'Duración: $duration',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$$price',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: const Divider(
                      color: Colors.white,
                      thickness: 1,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: onEdit,
                        icon: const Icon(Icons.edit, color: Colors.white),
                        tooltip: 'Editar',
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: onDelete,
                        icon: const Icon(Icons.delete, color: Colors.white),
                        tooltip: 'Eliminar',
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
