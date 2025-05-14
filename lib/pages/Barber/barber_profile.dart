import 'package:flutter/material.dart';
import '../Home/home_page.dart';

class PantallaBarbero extends StatefulWidget {
  const PantallaBarbero({super.key});

  @override
  _PantallaBarberoState createState() => _PantallaBarberoState();
}

class _PantallaBarberoState extends State<PantallaBarbero> {
  TextEditingController controller1 = TextEditingController(text: 'Jorge');
  TextEditingController controller2 = TextEditingController(text: 'barber@gmail.com');
  TextEditingController controller3 = TextEditingController(text: 'Activo');

  List<Map<String, String>> citasPendientes = [];
  List<Map<String, String>> citasProximas = [];

  final Map<String, dynamic> datosCitasJson = {
    "citasPendientes": [
      {
        "fecha": "2025-05-01",
        "hora": "10:00 AM",
        "servicio": "Corte de cabello",
        "cliente": "Cliente 1"
      },
      {
        "fecha": "2025-05-02",
        "hora": "11:00 AM",
        "servicio": "Barba",
        "cliente": "Cliente 2"
      }
    ],
    "citasProximas": [
      {
        "fecha": "2025-05-05",
        "hora": "2:00 PM",
        "servicio": "Tinte",
        "cliente": "Cliente 3"
      }
    ]
  };

  bool showCitasPendientes = true;
  bool showCitasProximas = false;

  @override
  void initState() {
    super.initState();
    // Cargar los datos desde el JSON definido
    citasPendientes = List<Map<String, String>>.from(datosCitasJson['citasPendientes']);
    citasProximas = List<Map<String, String>>.from(datosCitasJson['citasProximas']);
  }

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    controller3.dispose();
    super.dispose();
  }

  void aceptarCita(int index) {
    setState(() {
      citasProximas.add(citasPendientes[index]);
      citasPendientes.removeAt(index);
    });
  }

  void rechazarCitaPendiente(int index) {
    setState(() {
      citasPendientes.removeAt(index);
    });
  }

  void eliminarCitaProxima(int index) {
    setState(() {
      citasProximas.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cita completada'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/imag/logo.png'),
        ),
        title: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 600) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildNavButton('Nosotros', 'nosotros'),
                  const SizedBox(width: 20),
                  _buildNavButton('Servicios', 'servicios'),
                  const SizedBox(width: 20),
                  _buildNavButton('Contacto', 'contacto'),
                ],
              );
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildNavButton('Nosotros', 'nosotros'),
                  _buildNavButton('Servicios', 'servicios'),
                  _buildNavButton('Contacto', 'contacto'),
                ],
              );
            }
          },
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.account_circle, color: Colors.white),
            onSelected: (value) {
              if (value == 'logout') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(scrollTo: 'inicio'),
                  ),
                );
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text('Cerrar Sesión'),
              ),
            ],
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Datos personales", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  const Text("Nombre"),
                  const SizedBox(height: 5),
                  _buildTextField(controller1, editable: true),
                  const SizedBox(height: 10),
                  const Text("Correo"),
                  const SizedBox(height: 5),
                  _buildTextField(controller2),
                  const SizedBox(height: 10),
                  const Text("Status"),
                  const SizedBox(height: 5),
                  _buildTextField(controller3),
                  const SizedBox(height: 20),

                  // Línea divisoria
                  const Divider(color: Colors.grey),

                  // Selector tipo pestañas centrado
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildTabOption('Citas Pendientes', showCitasPendientes, () {
                          setState(() {
                            showCitasPendientes = true;
                            showCitasProximas = false;
                          });
                        }),
                        const SizedBox(width: 30),
                        _buildTabOption('Citas Próximas', showCitasProximas, () {
                          setState(() {
                            showCitasPendientes = false;
                            showCitasProximas = true;
                          });
                        }),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  if (showCitasPendientes)
                    _buildTablaCitas(
                      citas: citasPendientes,
                      onAceptar: aceptarCita,
                      onRechazar: rechazarCitaPendiente,
                    ),
                  if (showCitasProximas)
                    _buildTablaCitas(
                      citas: citasProximas,
                      onAceptar: null,
                      onRechazar: eliminarCitaProxima,
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, {bool editable = false}) {
    return SizedBox(
      width: double.infinity,
      child: TextField(
        controller: controller,
        readOnly: !editable,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          filled: true,
          fillColor: Colors.black,
          suffixIcon: editable ? const Icon(Icons.edit, color: Colors.white) : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.grey),
          ),
        ),
      ),
    );
  }

  Widget _buildTablaCitas({
    required List<Map<String, String>> citas,
    required Function(int)? onAceptar,
    required Function(int) onRechazar,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(10),
        child: Center( // <-- Este Center centra horizontalmente
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 30,
              headingTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              dataTextStyle: const TextStyle(color: Colors.white),
              border: TableBorder(horizontalInside: const BorderSide(color: Colors.white)),
              columns: const [
                DataColumn(label: Text('Fecha')),
                DataColumn(label: Text('Hora')),
                DataColumn(label: Text('Servicio')),
                DataColumn(label: Text('Cliente')),
                DataColumn(label: Text('Completado/Cancelar')),
              ],
              rows: List.generate(citas.length, (index) {
                final cita = citas[index];
                return DataRow(cells: [
                  DataCell(Text(cita['fecha']!)),
                  DataCell(Text(cita['hora']!)),
                  DataCell(Text(cita['servicio']!)),
                  DataCell(Text(cita['cliente']!)),
                  DataCell(Row(
                    children: [
                      onAceptar != null
                          ? ElevatedButton(
                              onPressed: () => onAceptar(index),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(10),
                              ),
                              child: const Icon(Icons.check, color: Colors.white),
                            )
                          : IgnorePointer(
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(10),
                                ),
                                child: const Icon(Icons.check, color: Colors.white),
                              ),
                            ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () => onRechazar(index),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(10),
                        ),
                        child: const Icon(Icons.close, color: Colors.white),
                      ),
                    ],
                  )),
                ]);
              }),
            ),
          ),
        ),
      ),
    );
  }

  TextButton _buildNavButton(String text, String scrollTo) {
    return TextButton(
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage(scrollTo: scrollTo)),
        );
      },
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }

  Widget _buildTabOption(String title, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 2,
            width: 80,
            color: isSelected ? Colors.black : Colors.transparent,
          )
        ],
      ),
    );
  }

  Widget _buildOptionButton(String text, VoidCallback onPressed, {required bool seleccionado}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: seleccionado ? Colors.grey : Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        foregroundColor: Colors.white,
      ),
      child: Text(text),
    );
  }
}
