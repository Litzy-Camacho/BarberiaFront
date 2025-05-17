import 'package:flutter/material.dart';
import '../Home/home_page.dart';
import '../Components/navbar_home.dart';
import 'package:flutter/services.dart';

class PantallaUsuario extends StatefulWidget {
  const PantallaUsuario({super.key});

  @override
  _PantallaUsuarioState createState() => _PantallaUsuarioState();
}

class _PantallaUsuarioState extends State<PantallaUsuario> {
  TextEditingController controllerNombre = TextEditingController(text: 'Andrés');
  TextEditingController controllerTelefono = TextEditingController(text: '5551234567');
  TextEditingController controllerCorreo = TextEditingController(text: 'usuario@gmail.com');

  bool nombreValido = true;

  // Variables para controlar si el campo está en modo edición o no
  bool _editandoNombre = false;
  bool _editandoTelefono = false;

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
    controllerNombre.addListener(_validarNombre);
  }

  void _validarNombre() {
    final texto = controllerNombre.text;
    final contieneNumero = texto.contains(RegExp(r'[0-9]'));

    if (contieneNumero) {
      String nuevoTexto = texto.replaceAll(RegExp(r'[0-9]'), '');
      controllerNombre.value = controllerNombre.value.copyWith(
        text: nuevoTexto,
        selection: TextSelection.collapsed(offset: nuevoTexto.length),
      );

      setState(() => nombreValido = false);
    } else {
      if (!nombreValido) {
        setState(() => nombreValido = true);
      }
    }
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
    controllerTelefono.dispose();
    controllerCorreo.dispose();
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
            child: Padding(
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
                  const SizedBox(height: 5),
                  TextField(
                    controller: controllerCorreo,
                    readOnly: true,
                    cursorColor: Colors.green,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      filled: true,
                      fillColor: Colors.black,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.green, width: 2),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  const Divider(color: Colors.grey),
                  const Center(
                    child: Text(
                      "Servicios solicitados",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),
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
}
