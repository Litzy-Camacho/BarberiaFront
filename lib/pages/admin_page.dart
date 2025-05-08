import 'package:flutter/material.dart';
import 'home_page.dart';


class PantallaAdministrador extends StatefulWidget {
  const PantallaAdministrador({super.key});

  @override
  _PantallaAdministradorState createState() => _PantallaAdministradorState();
}

class _PantallaAdministradorState extends State<PantallaAdministrador> {
  TextEditingController nombreController = TextEditingController();
  TextEditingController correoController = TextEditingController(text: 'admin@ejemplo.com');

  List<Map<String, dynamic>> usuarios = [];
  List<Map<String, dynamic>> barberos = [];

  List<DataRow> _buildUsuarioRows() {
  return usuarios.asMap().entries.map((entry) {
    final index = entry.key;
    final usuario = entry.value;
    return DataRow(cells: [
      DataCell(Text(usuario['nombre'])),
      DataCell(Text(usuario['correo'])),
      DataCell(_buildActionButtons(index, true)),
    ]);
  }).toList();
}

List<DataRow> _buildBarberoRows() {
  return barberos.asMap().entries.map((entry) {
    final index = entry.key;
    final barbero = entry.value;
    return DataRow(cells: [
      DataCell(Text(barbero['nombre'])),
      DataCell(Text(barbero['correo'])),
      DataCell(Text('\$${barbero['salario']}')),
      DataCell(Text(barbero['status'])),
      DataCell(_buildActionButtons(index, false)), // Enlazado correctamente con el índice y el tipo de entidad
    ]);
  }).toList();
}

  int usuarioCount = 4;
  int barberoCount = 4;

  Color _buttonColor = Colors.white;
  Color _textColor = Colors.black;

  @override
void initState() {
  super.initState();
  usuarios = List.generate(usuarioCount, (index) {
    return {
      'nombre': 'Usuario ${index + 1}',
      'correo': 'usuario${index + 1}@mail.com',
    };
  });

  barberos = List.generate(barberoCount, (index) {
    return {
      'nombre': 'Barbero ${index + 1}',
      'correo': 'barbero${index + 1}@mail.com',
      'salario': 1000 + index * 100,
      'status': index % 2 == 0 ? 'Activo' : 'Inactivo',
    };
  });
}

  @override
  void dispose() {
    nombreController.dispose();
    correoController.dispose();
    super.dispose();
  }

  void _mostrarDialogoAgregarUsuario() {
  final TextEditingController nuevoNombreController = TextEditingController();
  final TextEditingController nuevoCorreoController = TextEditingController();
  String? errorNombre;
  String? errorCorreo;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, setStateDialog) {
          return _buildDialogoFormulario(
            titulo: "Ingresa los siguientes datos",
            nombreController: nuevoNombreController,
            correoController: nuevoCorreoController,
            errorNombre: errorNombre,
            errorCorreo: errorCorreo,
            onChangedNombre: (value) {
              setStateDialog(() {
                errorNombre = _validarNombre(value);
              });
            },
            onChangedCorreo: (value) {
              setStateDialog(() {
                errorCorreo = _validarCorreo(value);
              });
            },
            onPressedAceptar: () {
              final nombre = nuevoNombreController.text;
              final correo = nuevoCorreoController.text;

              setStateDialog(() {
                errorNombre = _validarNombre(nombre);
                errorCorreo = _validarCorreo(correo);
              });

              if (errorNombre == null && errorCorreo == null) {
                setState(() {
                  usuarioCount++;
                  usuarios.add({
                    'nombre': nombre,
                    'correo': correo,
                  });
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Usuario añadido correctamente'), backgroundColor: Colors.green),
                );
                Navigator.of(context).pop();
              }
            },
          );
        },
      );
    },
  );
}

void _mostrarDialogoEditarUsuario(int index) {
  final TextEditingController nombreController = TextEditingController(text: usuarios[index]['nombre']);
  final TextEditingController correoController = TextEditingController(text: usuarios[index]['correo']);
  String? errorNombre;
  String? errorCorreo;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, setStateDialog) {
          return _buildDialogoFormulario(
            titulo: "Editar Usuario",
            nombreController: nombreController,
            correoController: correoController,
            errorNombre: errorNombre,
            errorCorreo: errorCorreo,
            onChangedNombre: (value) {
              setStateDialog(() {
                errorNombre = _validarNombre(value);
              });
            },
            onChangedCorreo: (value) {
              setStateDialog(() {
                errorCorreo = _validarCorreo(value);
              });
            },
            onPressedAceptar: () {
              final nombre = nombreController.text;
              final correo = correoController.text;

              setStateDialog(() {
                errorNombre = _validarNombre(nombre);
                errorCorreo = _validarCorreo(correo);
              });

              if (errorNombre == null && errorCorreo == null) {
                setState(() {
                  usuarios[index] = {
                    'nombre': nombre,
                    'correo': correo,
                  };
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Usuario editado correctamente'), backgroundColor: Colors.green),
                );
                Navigator.of(context).pop();
              }
            },
          );
        },
      );
    },
  );
}

void _mostrarDialogoEditarBarbero(int index) {
  final TextEditingController nombreController = TextEditingController(text: barberos[index]['nombre']);
  final TextEditingController correoController = TextEditingController(text: barberos[index]['correo']);
  final TextEditingController salarioController = TextEditingController(text: barberos[index]['salario'].toString());
  String? errorNombre;
  String? errorCorreo;
  String? errorSalario;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, setStateDialog) {
          return Align(
            alignment: Alignment.center,
            child: AlertDialog(
              backgroundColor: Colors.white,
              title: const Center(child: Text("Editar Barbero")),
              content: SizedBox(
                width: 400,
                height: 300,
                child: Column(
                  children: [
                    _buildTextField(
                      label: 'Nombre',
                      controller: nombreController,
                      errorText: errorNombre,
                      onChanged: (value) {
                        setStateDialog(() {
                          errorNombre = _validarNombre(value);
                        });
                      },
                    ),
                    const SizedBox(height: 15),
                    _buildTextField(
                      label: 'Correo',
                      controller: correoController,
                      errorText: errorCorreo,
                      onChanged: (value) {
                        setStateDialog(() {
                          errorCorreo = _validarCorreo(value);
                        });
                      },
                    ),
                    const SizedBox(height: 15),
                    _buildTextField(
                      label: 'Salario',
                      controller: salarioController,
                      keyboardType: TextInputType.number,
                      errorText: errorSalario,
                      onChanged: (value) {
                        setStateDialog(() {
                          errorSalario = _validarSalario(value);
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildBotonDialogo(() {
                      final nombre = nombreController.text;
                      final correo = correoController.text;
                      final salario = salarioController.text;

                      setStateDialog(() {
                        errorNombre = _validarNombre(nombre);
                        errorCorreo = _validarCorreo(correo);
                        errorSalario = _validarSalario(salario);
                      });

                      if (errorNombre == null && errorCorreo == null && errorSalario == null) {
                        setState(() {
                          barberos[index] = {
                            'nombre': nombre,
                            'correo': correo,
                            'salario': double.parse(salario),
                            'status': barberos[index]['status'], // No cambiar el estado
                          };
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Barbero editado correctamente'), backgroundColor: Colors.green),
                        );
                        Navigator.of(context).pop();
                      }
                    }),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}


 void _mostrarDialogoAgregarBarbero() {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController correoController = TextEditingController();
  final TextEditingController salarioController = TextEditingController();

  String? errorNombre;
  String? errorCorreo;
  String? errorSalario;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, setStateDialog) {
          return Align(
            alignment: Alignment.center,
            child: AlertDialog(
              backgroundColor: Colors.white,
              title: const Center(child: Text("Agregar Barbero")),
              content: SizedBox(
                width: 400,
                height: 300,
                child: Column(
                  children: [
                    _buildTextField(
                      label: 'Nombre',
                      controller: nombreController,
                      errorText: errorNombre,
                      onChanged: (value) {
                        setStateDialog(() {
                          errorNombre = _validarNombre(value);
                        });
                      },
                    ),
                    const SizedBox(height: 15),
                    _buildTextField(
                      label: 'Correo',
                      controller: correoController,
                      errorText: errorCorreo,
                      onChanged: (value) {
                        setStateDialog(() {
                          errorCorreo = _validarCorreo(value);
                        });
                      },
                    ),
                    const SizedBox(height: 15),
                    _buildTextField(
                      label: 'Salario',
                      controller: salarioController,
                      keyboardType: TextInputType.number,
                      errorText: errorSalario,
                      onChanged: (value) {
                        setStateDialog(() {
                          errorSalario = _validarSalario(value);
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildBotonDialogo(() {
                      final nombre = nombreController.text;
                      final correo = correoController.text;
                      final salario = salarioController.text;

                      setStateDialog(() {
                        errorNombre = _validarNombre(nombre);
                        errorCorreo = _validarCorreo(correo);
                        errorSalario = _validarSalario(salario);
                      });

                      if (errorNombre == null && errorCorreo == null && errorSalario == null) {
                        setState(() {
                          barberoCount++;
                          barberos.add({
                            'nombre': nombre,
                            'correo': correo,
                            'salario': double.parse(salario),
                            'status': 'Activo',
                          });
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Barbero añadido correctamente'), backgroundColor: Colors.green),
                        );
                        Navigator.of(context).pop();
                      }
                    }),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}


  String? _validarNombre(String nombre) {
    if (nombre.isEmpty) return 'El nombre no puede estar vacío';
    if (RegExp(r'\d').hasMatch(nombre)) return 'El nombre no puede contener números';
    return null;
  }

  String? _validarCorreo(String correo) {
    if (correo.isEmpty) return 'El correo no puede estar vacío';
    if (!RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$').hasMatch(correo)) return 'El correo no es válido';
    return null;
  }

  String? _validarSalario(String salario) {
    if (salario.isEmpty) return 'El salario no puede estar vacío';
    if (!RegExp(r'^\d+$').hasMatch(salario)) return 'Solo se permiten números';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF3FF),
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
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Datos Personales", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    const Text("Nombre"),
                    const SizedBox(height: 5),
                    SizedBox(
                      width: 300,
                      child: TextField(
                        controller: nombreController,
                        style: const TextStyle(color: Colors.white),
                        decoration: _inputDecoration(Icons.edit),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text("Correo"),
                    const SizedBox(height: 5),
                    SizedBox(
                      width: 300,
                      child: TextField(
                        controller: correoController,
                        readOnly: true,
                        style: const TextStyle(color: Colors.white),
                        decoration: _inputDecoration(null),
                      ),
                    ),
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
                      _buildResponsiveTableSection(
                        title: "Control de los Usuarios",
                        columns: const [
                          DataColumn(label: Text('Nombre')),
                          DataColumn(label: Text('Correo')),
                          DataColumn(label: Text('Editar/Borrar')),
                        ],
                        rows: _buildUsuarioRows(),
                        onAddRow: _mostrarDialogoAgregarUsuario,
                      ),
                      const SizedBox(height: 20),
                      _buildResponsiveTableSection(
                        title: "Control de los Barberos",
                        columns: const [
                          DataColumn(label: Text('Nombre')),
                          DataColumn(label: Text('Correo')),
                          DataColumn(label: Text('Salario')),
                          DataColumn(label: Text('Status')),
                          DataColumn(label: Text('Editar/Borrar')),
                        ],
                        rows: _buildBarberoRows(),
                        onAddRow: _mostrarDialogoAgregarBarbero,
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

  Widget _buildResponsiveTableSection({
    required String title,
    required List<DataColumn> columns,
    required List<DataRow> rows,
    required VoidCallback onAddRow,
  }) {
    final columnCount = columns.length;
    final columnSpacing = (900 - 40) / columnCount - 70;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 900,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
              ElevatedButton.icon(
                onPressed: onAddRow,
                icon: const Icon(Icons.add),
                label: const Text('Añadir'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            color: Colors.black,
            height: 250,
            width: 900,
            padding: const EdgeInsets.all(10),
            child: Scrollbar(
              thumbVisibility: true,
              trackVisibility: true,
              thickness: 6,
              radius: const Radius.circular(6),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  columnSpacing: columnSpacing,
                  headingTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  dataTextStyle: const TextStyle(color: Colors.white),
                  border: TableBorder(horizontalInside: const BorderSide(color: Colors.white)),
                  columns: columns,
                  rows: rows,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(int index, bool esUsuario) {
  return Row(
    children: [
      ElevatedButton(
        onPressed: () {
          // Editar
          print('Editar ${esUsuario ? 'usuario' : 'barbero'} en índice $index');
          if (esUsuario) {
            _mostrarDialogoEditarUsuario(index);
          } else {
            _mostrarDialogoEditarBarbero(index);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(10),
        ),
        child: const Icon(Icons.edit, color: Colors.white),
      ),
      const SizedBox(width: 10),
      ElevatedButton(
        onPressed: () {
          setState(() {
            if (esUsuario) {
              usuarios.removeAt(index);
            } else {
              barberos.removeAt(index);
            }
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(10),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
    ],
  );
}



  InputDecoration _inputDecoration(IconData? icon) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      filled: true,
      fillColor: Colors.black,
      suffixIcon: icon != null ? Icon(icon, color: Colors.white) : null,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required void Function(String) onChanged,
    String? errorText,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.black),
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black),
        errorText: errorText,
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: errorText == null ? Colors.green : Colors.black)),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: errorText == null ? Colors.green : Colors.grey)),
      ),
      onChanged: onChanged,
    );
  }

  Widget _buildBotonDialogo(VoidCallback onPressed) {
  return Center(
    child: ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.hovered)) {
            return Colors.black;
          }
          return Colors.white;
        }),
        foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.hovered)) {
            return Colors.white;
          }
          return Colors.black;
        }),
        padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 12, horizontal: 40)),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: Colors.grey),
          ),
        ),
      ),
      onPressed: onPressed,
      child: const Text('Añadir'),
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


  Widget _buildDialogoFormulario({
    required String titulo,
    required TextEditingController nombreController,
    required TextEditingController correoController,
    required String? errorNombre,
    required String? errorCorreo,
    required void Function(String) onChangedNombre,
    required void Function(String) onChangedCorreo,
    required VoidCallback onPressedAceptar,
  }) {
    return Align(
      alignment: Alignment.center,
      child: AlertDialog(
        backgroundColor: Colors.white,
        title: Center(child: Text(titulo)),
        content: SizedBox(
          width: 400,
          height: 200,
          child: Column(
            children: [
              _buildTextField(
                label: 'Nombre',
                controller: nombreController,
                errorText: errorNombre,
                onChanged: onChangedNombre,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                label: 'Correo',
                controller: correoController,
                errorText: errorCorreo,
                onChanged: onChangedCorreo,
              ),
              const SizedBox(height: 20),
              _buildBotonDialogo(onPressedAceptar),
            ],
          ),
        ),
      ),
    );
  }
}
