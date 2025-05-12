import 'package:flutter/material.dart';
import 'home_page.dart';

class PantallaBarbero extends StatefulWidget {
  const PantallaBarbero({super.key});

  @override
  _PantallaBarberoState createState() => _PantallaBarberoState();
}

class _PantallaBarberoState extends State<PantallaBarbero> {
  TextEditingController controller1 = TextEditingController(text: 'Jorge');
  TextEditingController controller2 = TextEditingController(text: 'barber@gmail.com');
  TextEditingController controller3 = TextEditingController(text: 'Activo');

  List<Map<String, String>> citasPendientes = List.generate(5, (index) {
    return {
      'fecha': '2025-05-${index + 1}',
      'hora': '10:00 AM',
      'servicio': 'Corte de cabello',
      'cliente': 'Cliente ${index + 1}',
    };
  });

  List<Map<String, String>> citasProximas = [];

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
        title: Stack(
          alignment: Alignment.center,
          children: [
            Row(
               mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildNavButton('Nosotros', 'nosotros'),
                const SizedBox(width: 20),
                _buildNavButton('Servicios', 'servicios'),
                const SizedBox(width: 20),
                _buildNavButton('Contacto', 'contacto'),
              ],
            ),
          ],
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
      body: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(25.0),
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
                  ],
                ),
              ),
              const SizedBox(width: 60),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 15.0, right: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Citas Pendientes", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      _buildTablaCitas(
                        citas: citasPendientes,
                        onAceptar: aceptarCita,
                        onRechazar: rechazarCitaPendiente,
                        mostrarAccion: true,
                      ),
                      const SizedBox(height: 20),
                      const Text("Citas Próximas", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      _buildTablaCitas(
                        citas: citasProximas,
                        onAceptar: null, // No hacer nada
                        onRechazar: eliminarCitaProxima,
                        mostrarAccion: true,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, {bool editable = false}) {
    return SizedBox(
      width: 300,
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
    required bool mostrarAccion,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        color: Colors.black,
        height: 250,
        padding: const EdgeInsets.all(10),
        child: Scrollbar(
          thumbVisibility: true,
          trackVisibility: true,
          thickness: 6,
          radius: const Radius.circular(6),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 150,
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
                        ElevatedButton(
                          onPressed: onAceptar != null
                              ? () => onAceptar(index)
                              : null, // Desactivado en tabla de próximas
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(10),
                          ),
                          child: const Icon(Icons.check, color: Colors.white),
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
