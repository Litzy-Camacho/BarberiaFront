import 'package:flutter/material.dart';
import 'home_page.dart';

class PantallaBarbero extends StatefulWidget {
  const PantallaBarbero({super.key});

  @override
  _PantallaBarberoState createState() => _PantallaBarberoState();
}

class _PantallaBarberoState extends State<PantallaBarbero> {
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController(text: 'barbero@ejemplo.com');
  TextEditingController controller3 = TextEditingController(text: 'Activo');

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    controller3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       backgroundColor: Colors.black,
  elevation: 0,
  title: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      _buildNavButton('Nosotros', 'nosotros'),
      const SizedBox(width: 20),
      _buildNavButton('Servicios', 'servicios'),
      const SizedBox(width: 20),
      _buildNavButton('Contacto', 'contacto'),
    ],
  ),
  actions: [
    _buildNavButton('Iniciar Sesión', 'inicio'), // Aquí puedes decidir qué hacer
    const SizedBox(width: 10),
  ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sección de datos personales
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Datos personales",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    const Text("Nombre"),
                    const SizedBox(height: 5),
                    SizedBox(
                      width: 300,
                      child: TextField(
                        controller: controller1,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          filled: true,
                          fillColor: Colors.black,
                          suffixIcon: const Icon(Icons.edit, color: Colors.white),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text("Correo"),
                    const SizedBox(height: 5),
                    SizedBox(
                      width: 300,
                      child: TextField(
                        controller: controller2,
                        readOnly: true,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          filled: true,
                          fillColor: Colors.black,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text("Status"),
                    const SizedBox(height: 5),
                    SizedBox(
                      width: 300,
                      child: TextField(
                        controller: controller3,
                        readOnly: true,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          filled: true,
                          fillColor: Colors.black,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 60),
              // Sección de tabla
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 15.0, right: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Citas Pendientes", // Actualizado
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      const SizedBox(height: 20),
                      ClipRRect(
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
                                  columnSpacing: 150, // Aumentar espacio para las columnas
                                  headingTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  dataTextStyle: const TextStyle(color: Colors.white),
                                  border: TableBorder(
                                    horizontalInside: const BorderSide(color: Colors.white),
                                  ),
                                  columns: const [
                                    DataColumn(label: Text('Fecha')),
                                    DataColumn(label: Text('Hora')),
                                    DataColumn(label: Text('Servicio')),
                                    DataColumn(label: Text('Cliente')),
                                    DataColumn(label: Text('Aceptar/Rechazar')), // Nueva columna
                                  ],
                                  rows: List.generate(5, (index) {
                                    return DataRow(cells: [
                                      DataCell(Text('2025-05-${index + 1}')),
                                      DataCell(Text('10:00 AM')),
                                      DataCell(Text('Corte de cabello')),
                                      DataCell(Text('Cliente ${index + 1}')),
                                      DataCell(Row(
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              // Acción para aceptar
                                              print('Cita aceptada');
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.green,
                                              shape: const CircleBorder(),
                                              padding: const EdgeInsets.all(10),
                                            ),
                                            child: const Icon(Icons.check, color: Colors.white),
                                          ),
                                          const SizedBox(width: 10),
                                          ElevatedButton(
                                            onPressed: () {
                                              // Acción para rechazar
                                              print('Cita rechazada');
                                            },
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
                      ),
                      const SizedBox(height: 20),
                      // Segunda tabla
                      const Text(
                        "Citas Proximas", // Actualizado
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      const SizedBox(height: 20),
                      ClipRRect(
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
                                  columnSpacing: 150, // Aumentar espacio para las columnas
                                  headingTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  dataTextStyle: const TextStyle(color: Colors.white),
                                  border: TableBorder(
                                    horizontalInside: const BorderSide(color: Colors.white),
                                  ),
                                  columns: const [
                                    DataColumn(label: Text('Fecha')),
                                    DataColumn(label: Text('Hora')),
                                    DataColumn(label: Text('Servicio')),
                                    DataColumn(label: Text('Cliente')),
                                    DataColumn(label: Text('Aceptar/Rechazar')), // Nueva columna
                                  ],
                                  rows: List.generate(5, (index) {
                                    return DataRow(cells: [
                                      DataCell(Text('2025-05-${index + 6}')),
                                      DataCell(Text('11:00 AM')),
                                      DataCell(Text('Corte de barba')),
                                      DataCell(Text('Cliente ${index + 6}')),
                                      DataCell(Row(
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              // Acción para aceptar
                                              print('Cita aceptada');
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.green,
                                              shape: const CircleBorder(),
                                              padding: const EdgeInsets.all(10),
                                            ),
                                            child: const Icon(Icons.check, color: Colors.white),
                                          ),
                                          const SizedBox(width: 10),
                                          ElevatedButton(
                                            onPressed: () {
                                              // Acción para rechazar
                                              print('Cita rechazada');
                                            },
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

  TextButton _buildNavButton(String text, String scrollTo) {
  return TextButton(
    onPressed: () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(scrollTo: scrollTo), // Pasamos el parámetro 'scrollTo'
        ),
      );
    },
    child: Text(text, style: const TextStyle(color: Colors.white)),
  );
}

}
