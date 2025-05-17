import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Home/home_page.dart';
import '../Components/navbar_home.dart';

class PantallaBarbero extends StatefulWidget {
  const PantallaBarbero({super.key});

  @override
  _PantallaBarberoState createState() => _PantallaBarberoState();
}

class _PantallaBarberoState extends State<PantallaBarbero> {
  final TextEditingController controllerNombre = TextEditingController(text: 'Jorge');
  final TextEditingController controllerTelefono = TextEditingController(text: '1234567890');
  final TextEditingController controllerCorreo = TextEditingController(text: 'barber@gmail.com');
  final TextEditingController controllerStatus = TextEditingController(text: 'Activo');

  List<Map<String, String>> citasPendientes = [];
  List<Map<String, String>> citasProximas = [];

  // En datosCitasJson, agrega el campo 'telefono' a cada cita:
final Map<String, dynamic> datosCitasJson = {
  "citasPendientes": [
    {
      "fecha": "2025-05-01",
      "hora": "10:00 AM",
      "servicio": "Corte de cabello",
      "cliente": "Cliente 1",
      "telefono": "1234567890"
    },
    {
      "fecha": "2025-05-02",
      "hora": "11:00 AM",
      "servicio": "Barba",
      "cliente": "Cliente 2",
      "telefono": "0987654321"
    }
  ],
  "citasProximas": [
    {
      "fecha": "2025-05-05",
      "hora": "2:00 PM",
      "servicio": "Tinte",
      "cliente": "Cliente 3",
      "telefono": "1122334455"
    }
  ]
};

  bool showCitasPendientes = true;
  bool showCitasProximas = false;

  @override
  void initState() {
    super.initState();
    citasPendientes = List<Map<String, String>>.from(datosCitasJson['citasPendientes']);
    citasProximas = List<Map<String, String>>.from(datosCitasJson['citasProximas']);
  }

  @override
  void dispose() {
    controllerNombre.dispose();
    controllerTelefono.dispose();
    controllerCorreo.dispose();
    controllerStatus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Datos personales", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                _buildEditableTextField(
                  controller: controllerNombre,
                  label: "Nombre",
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))],
                ),
                const SizedBox(height: 10),
                _buildEditableTextField(
                  controller: controllerTelefono,
                  label: "Teléfono",
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                const Text("Correo"),
                _buildReadOnlyField(controllerCorreo),
                const SizedBox(height: 10),
                const Text("Status"),
                _buildReadOnlyField(controllerStatus),
                const SizedBox(height: 20),
                const Divider(color: Colors.grey),
                const Center(
  child: Text(
    "Control de Citas",
    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  ),
),
const SizedBox(height: 20),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTabOption('Pendientes', showCitasPendientes, () {
                        setState(() {
                          showCitasPendientes = true;
                          showCitasProximas = false;
                        });
                      }),
                      const SizedBox(width: 30),
                      _buildTabOption('Próximas', showCitasProximas, () {
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
                    onAceptar: completarCitaProxima,
                    onRechazar: eliminarCitaProxima,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEditableTextField({
  required TextEditingController controller,
  required String label,
  required List<TextInputFormatter> inputFormatters,
  TextInputType keyboardType = TextInputType.text,
}) {
  final focusNode = FocusNode();
  bool isEditing = false;
  bool showWarning = false;
  String lastValidValue = controller.text;  // Guardamos el último valor válido

  return StatefulBuilder(
    builder: (context, setInnerState) {
      return GestureDetector(
        onTap: () {
          focusNode.requestFocus();
          setInnerState(() => isEditing = true);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label),
            const SizedBox(height: 5),
            TextField(
              controller: controller,
              focusNode: focusNode,
              inputFormatters: inputFormatters,
              keyboardType: keyboardType,
              maxLength: label == "Teléfono" ? 10 : null,
              style: const TextStyle(color: Colors.white),
              cursorColor: Colors.green,
              onChanged: (value) {
                if (label == "Nombre") {
                  // Revisamos si el texto contiene números
                  if (RegExp(r'\d').hasMatch(value)) {
                    setInnerState(() {
                      showWarning = true;
                      // Revertimos al último valor válido
                      controller.text = lastValidValue;
                      controller.selection = TextSelection.fromPosition(
                        TextPosition(offset: lastValidValue.length),
                      );
                    });
                  } else {
                    setInnerState(() {
                      showWarning = false;
                      lastValidValue = value; // Actualizamos el último valor válido
                    });
                  }
                } else if (label == "Teléfono") {
                  setInnerState(() {
                    showWarning = value.length != 10;
                  });
                } else {
                  setInnerState(() {
                    showWarning = false;
                  });
                }
              },
              onEditingComplete: () {
                setInnerState(() => isEditing = false);
                focusNode.unfocus();
              },
              decoration: InputDecoration(
                counterText: "",
                suffixIcon: const Icon(Icons.edit, color: Colors.white),
                filled: true,
                fillColor: Colors.black,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: showWarning ? Colors.red : Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: showWarning ? Colors.red : Colors.green, width: 2),
                ),
              ),
            ),
            if (showWarning)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  label == "Nombre"
                      ? "No se permiten números en el nombre"
                      : "El teléfono debe tener exactamente 10 dígitos",
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
          ],
        ),
      );
    },
  );
}

  Widget _buildReadOnlyField(TextEditingController controller) {
    return SizedBox(
      width: double.infinity,
      child: TextField(
        controller: controller,
        readOnly: true,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          filled: true,
          fillColor: Colors.black,
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
              DataColumn(label: Text('Cliente')),
              DataColumn(label: Text('Teléfono')),
              DataColumn(label: Text('Completado/Cancelar')),
            ],
            rows: List.generate(citas.length, (index) {
              final cita = citas[index];
              return DataRow(cells: [
                DataCell(Text(cita['fecha']!)),
                DataCell(Text(cita['hora']!)),
                DataCell(Text(cita['servicio']!)),
                DataCell(Text(cita['cliente']!)),
                DataCell(Text(cita['telefono'] ?? '')),
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
                      onPressed: () => confirmarCancelacion(context, index, onRechazar),
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

// Función para mostrar el diálogo de confirmación
void confirmarCancelacion(BuildContext context, int index, Function(int) onRechazar) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.white, 
      title: const Text('Confirmar cancelación'),
      content: const Text('¿Estás seguro que deseas cancelar esta cita?'),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black, // Fondo gris para "No"
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'No',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
              ),
              onPressed: () {
                onRechazar(index);
                Navigator.of(context).pop();
              },
              child: const Text(
                'Sí',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    ),
  );
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

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Cita cancelada'),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 2),
    ),
  );
}

void eliminarCitaProxima(int index) {
  setState(() {
    citasProximas.removeAt(index);
  });

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Cita cancelada'),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 2),
    ),
  );
}

void completarCitaProxima(int index) {
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

  Widget _buildTabOption(String title, bool isSelected, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: isSelected ? Colors.black : Colors.transparent,
            width: 2,
          ),
          bottom: BorderSide(
            color: isSelected ? Colors.black : Colors.transparent,
            width: 2,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
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
            color: Colors.transparent, // Ya no se necesita esta línea
          ),
        ],
      ),
    ),
  );
}
}
