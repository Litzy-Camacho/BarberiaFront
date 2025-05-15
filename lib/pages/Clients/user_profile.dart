import 'package:flutter/material.dart';
import '../Home/home_page.dart';

class PantallaUsuario extends StatefulWidget {
  const PantallaUsuario({super.key});

  @override
  _PantallaUsuarioState createState() => _PantallaUsuarioState();
}

class _PantallaUsuarioState extends State<PantallaUsuario> {
  TextEditingController controllerNombre = TextEditingController(text: 'Andrés');
  TextEditingController controllerCorreo = TextEditingController(text: 'usuario@gmail.com');
  TextEditingController controllerStatus = TextEditingController(text: 'Activo');

  List<Map<String, String>> serviciosSolicitados = [];
  List<Map<String, String>> serviciosFiltrados = [];

  String filtroSeleccionado = 'Todas';

  final List<String> opcionesFiltro = ['Todas', 'Pendiente', 'Aceptada', 'Completado', 'Cancelada'];

  final Map<String, dynamic> datosServiciosJson = {
    "serviciosSolicitados": [
      {
        "fecha": "2025-05-10",
        "hora": "9:00 AM",
        "servicio": "Corte de cabello",
        "barbero": "Carlos",
        "status": "Completado"
      },
      {
        "fecha": "2025-05-12",
        "hora": "1:00 PM",
        "servicio": "Barba",
        "barbero": "Luis",
        "status": "Pendiente"
      },
      {
        "fecha": "2025-05-15",
        "hora": "11:00 AM",
        "servicio": "Corte de cabello",
        "barbero": "Pedro",
        "status": "Aceptada"
      },
      {
        "fecha": "2025-05-17",
        "hora": "2:00 PM",
        "servicio": "Barba",
        "barbero": "Luis",
        "status": "Cancelada"
      }
    ]
  };

  @override
  void initState() {
    super.initState();
    serviciosSolicitados = List<Map<String, String>>.from(datosServiciosJson['serviciosSolicitados']);
    _aplicarFiltro();
  }

  void _aplicarFiltro() {
    setState(() {
      if (filtroSeleccionado == 'Todas') {
        serviciosFiltrados = List.from(serviciosSolicitados);
      } else {
        serviciosFiltrados = serviciosSolicitados
            .where((servicio) => servicio['status']?.toLowerCase() == filtroSeleccionado.toLowerCase())
            .toList();
      }
    });
  }

  @override
  void dispose() {
    controllerNombre.dispose();
    controllerCorreo.dispose();
    controllerStatus.dispose();
    super.dispose();
  }

  Widget filtroEstilo(String texto, bool seleccionado, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              texto,
              style: TextStyle(
                color: seleccionado ? Colors.black : Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              height: 3,
              width: 70,
              decoration: BoxDecoration(
                color: seleccionado ? Colors.black : Colors.transparent,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ],
        ),
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
                  MaterialPageRoute(builder: (context) => HomePage(scrollTo: 'inicio')),
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
                  _buildTextField(controllerNombre, editable: true),
                  const SizedBox(height: 10),
                  const Text("Correo"),
                  const SizedBox(height: 5),
                  _buildTextField(controllerCorreo),
                  const SizedBox(height: 10),
                  const Text("Status"),
                  const SizedBox(height: 5),
                  _buildTextField(controllerStatus),
                  const SizedBox(height: 20),

                  const Divider(color: Colors.grey),

                  const Center(
                    child: Text(
                      "Servicios solicitados",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Aquí el filtro con el estilo tipo pestañas de PantallaBarbero
                  Center(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: opcionesFiltro.map((opcion) {
                          return filtroEstilo(opcion, filtroSeleccionado == opcion, () {
                            setState(() {
                              filtroSeleccionado = opcion;
                              _aplicarFiltro();
                            });
                          });
                        }).toList(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  _buildTablaServicios(serviciosFiltrados),
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

  Widget _buildTablaServicios(List<Map<String, String>> servicios) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(10),
        child: Center(
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
                DataColumn(label: Text('Barbero')),
                DataColumn(label: Text('Status')),
              ],
              rows: servicios.map((servicio) {
                return DataRow(cells: [
                  DataCell(Text(servicio['fecha']!)),
                  DataCell(Text(servicio['hora']!)),
                  DataCell(Text(servicio['servicio']!)),
                  DataCell(Text(servicio['barbero']!)),
                  DataCell(Text(servicio['status']!)),
                ]);
              }).toList(),
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
}
