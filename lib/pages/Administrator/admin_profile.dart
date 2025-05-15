import 'package:flutter/material.dart';
import '../Home/home_page.dart';

class PantallaAdministrador extends StatefulWidget {
  const PantallaAdministrador({super.key});

  @override
  _PantallaAdministradorState createState() => _PantallaAdministradorState();
}

class _PantallaAdministradorState extends State<PantallaAdministrador> {

  TextEditingController controller1 = TextEditingController(text: 'Jorge');
  TextEditingController controller2 = TextEditingController(text: 'barber@gmail.com');

List<Map<String, dynamic>> usuariosJson = [
  {
    "nombre": "Juan Pérez",
    "correo": "juan@example.com",
  },
  {
    "nombre": "Ana Gómez",
    "correo": "ana@example.com",
  },
];

List<Map<String, dynamic>> barberosJson = [
  {
    "nombre": "Carlos Ruiz",
    "correo": "carlos@example.com",
    "salario": 1200.50,
    "status": "Activo",
  },
  {
    "nombre": "Luis Martínez",
    "correo": "luis@example.com",
    "salario": 1100,
    "status": "Activo",
  },
];


  bool showUsuarios = true;
  bool showBarberos = false;

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    super.dispose();
  }

//METODOS

void _confirmarEliminacion(BuildContext context, {
  required String nombre,
  required VoidCallback onConfirmar,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text('¿Estás seguro que quieres eliminar a $nombre?'),
        actions: [
          TextButton(
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text(
              'Aceptar',
              style: TextStyle(color: Colors.black),
            ),
            style: TextButton.styleFrom(
              
            ),
            onPressed: () {
              Navigator.of(context).pop();
              onConfirmar();
            },
          ),
        ],
      );
    },
  );
}

void _mostrarDialogoAnadirUsuario() {
  final nombreController = TextEditingController();
  final correoController = TextEditingController();

  bool isValid = false;

  bool isNombreValido(String texto) {
    return RegExp(r'^[a-zA-Z\s]+$').hasMatch(texto) && texto.isNotEmpty;
  }

  bool isCorreoValido(String texto) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(texto) && texto.isNotEmpty;
  }

  void validarFormulario() {
    final nombre = nombreController.text.trim();
    final correo = correoController.text.trim();

    final valido = isNombreValido(nombre) && isCorreoValido(correo);

    if (valido != isValid) {
      setState(() {
        isValid = valido;
      });
    }
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, setState) {
        final nombreTexto = nombreController.text.trim();
        final correoTexto = correoController.text.trim();

        Color colorNombre() {
          if (nombreTexto.isEmpty) return Colors.black;
          return isNombreValido(nombreTexto) ? Colors.green : Colors.red;
        }

        Color colorCorreo() {
          if (correoTexto.isEmpty) return Colors.black;
          return isCorreoValido(correoTexto) ? Colors.green : Colors.red;
        }

        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Añadir Usuario'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nombreController,
                  cursorColor: colorNombre(),
                  onChanged: (value) {
                    validarFormulario();
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    labelText: 'Nombre',
                    labelStyle: TextStyle(color: colorNombre()),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: colorNombre()),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: colorNombre(), width: 2.0),
                    ),
                    errorText: nombreTexto.isNotEmpty && !isNombreValido(nombreTexto) ? 'Solo letras permitidas' : null,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: correoController,
                  cursorColor: colorCorreo(),
                  onChanged: (value) {
                    validarFormulario();
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    labelText: 'Correo',
                    labelStyle: TextStyle(color: colorCorreo()),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: colorCorreo()),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: colorCorreo(), width: 2.0),
                    ),
                    errorText: correoTexto.isNotEmpty && !isCorreoValido(correoTexto) ? 'Correo inválido' : null,
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
                          final nombre = nombreController.text.trim();
                          final correo = correoController.text.trim();

                          setState(() {
                            usuariosJson.add({
                              "nombre": nombre,
                              "correo": correo,
                            });
                          });

                          Navigator.of(context).pop();

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Usuario añadido'),
                              backgroundColor: Colors.green,
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      : null,
                  child: const Text('Añadir', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        );
      });
    },
  );
}

void _mostrarDialogoEditarUsuario(int index) {
  final usuario = usuariosJson[index];
  final nombreController = TextEditingController(text: usuario['nombre']);
  final correoController = TextEditingController(text: usuario['correo']);

  bool isValid = true;

  bool isNombreValido(String texto) {
    return RegExp(r'^[a-zA-Z\s]+$').hasMatch(texto) && texto.isNotEmpty;
  }

  bool isCorreoValido(String texto) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(texto) && texto.isNotEmpty;
  }

  void validarFormulario() {
    final nombre = nombreController.text.trim();
    final correo = correoController.text.trim();

    final valido = isNombreValido(nombre) && isCorreoValido(correo);

    if (valido != isValid) {
      setState(() {
        isValid = valido;
      });
    }
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, setState) {
        final nombreTexto = nombreController.text.trim();
        final correoTexto = correoController.text.trim();

        Color colorNombre() {
          if (nombreTexto.isEmpty) return Colors.black;
          return isNombreValido(nombreTexto) ? Colors.green : Colors.red;
        }

        Color colorCorreo() {
          if (correoTexto.isEmpty) return Colors.black;
          return isCorreoValido(correoTexto) ? Colors.green : Colors.red;
        }

        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Editar Usuario'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nombreController,
                  cursorColor: colorNombre(),
                  onChanged: (value) {
                    validarFormulario();
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    labelText: 'Nombre',
                    labelStyle: TextStyle(color: colorNombre()),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: colorNombre()),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: colorNombre(), width: 2.0),
                    ),
                    errorText: nombreTexto.isNotEmpty && !isNombreValido(nombreTexto) ? 'Solo letras permitidas' : null,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: correoController,
                  cursorColor: colorCorreo(),
                  onChanged: (value) {
                    validarFormulario();
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    labelText: 'Correo',
                    labelStyle: TextStyle(color: colorCorreo()),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: colorCorreo()),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: colorCorreo(), width: 2.0),
                    ),
                    errorText: correoTexto.isNotEmpty && !isCorreoValido(correoTexto) ? 'Correo inválido' : null,
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
                          final nombre = nombreController.text.trim();
                          final correo = correoController.text.trim();

                          setState(() {
                            usuariosJson[index] = {
                              "nombre": nombre,
                              "correo": correo,
                            };
                          });

                          Navigator.of(context).pop();

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Usuario actualizado'),
                              backgroundColor: Colors.green,
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      : null,
                  child: const Text('Aceptar', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        );
      });
    },
  );
}

void _mostrarDialogoAnadirBarbero() {
  final nombreController = TextEditingController();
  final correoController = TextEditingController();
  final salarioController = TextEditingController();

  bool isValid = false;

  bool isNombreValido(String texto) {
    return RegExp(r'^[a-zA-Z\s]+$').hasMatch(texto) && texto.isNotEmpty;
  }

  bool isCorreoValido(String texto) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(texto) && texto.isNotEmpty;
  }

  bool isSalarioValido(String texto) {
    return RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(texto) && texto.isNotEmpty;
  }

  void validarFormulario() {
    final nombre = nombreController.text.trim();
    final correo = correoController.text.trim();
    final salario = salarioController.text.trim();

    final valido = isNombreValido(nombre) && isCorreoValido(correo) && isSalarioValido(salario);

    if (valido != isValid) {
      setState(() {
        isValid = valido;
      });
    }
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, setState) {
        final nombreTexto = nombreController.text.trim();
        final correoTexto = correoController.text.trim();
        final salarioTexto = salarioController.text.trim();

        Color colorNombre() {
          if (nombreTexto.isEmpty) return Colors.black;
          return isNombreValido(nombreTexto) ? Colors.green : Colors.red;
        }

        Color colorCorreo() {
          if (correoTexto.isEmpty) return Colors.black;
          return isCorreoValido(correoTexto) ? Colors.green : Colors.red;
        }

        Color colorSalario() {
          if (salarioTexto.isEmpty) return Colors.black;
          return isSalarioValido(salarioTexto) ? Colors.green : Colors.red;
        }

        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Añadir Barbero'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nombreController,
                  cursorColor: colorNombre(),
                  onChanged: (value) {
                    validarFormulario();
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    labelText: 'Nombre',
                    labelStyle: TextStyle(color: colorNombre()),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: colorNombre()),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: colorNombre(), width: 2.0),
                    ),
                    errorText: nombreTexto.isNotEmpty && !isNombreValido(nombreTexto) ? 'Solo letras permitidas' : null,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: correoController,
                  cursorColor: colorCorreo(),
                  onChanged: (value) {
                    validarFormulario();
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    labelText: 'Correo',
                    labelStyle: TextStyle(color: colorCorreo()),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: colorCorreo()),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: colorCorreo(), width: 2.0),
                    ),
                    errorText: correoTexto.isNotEmpty && !isCorreoValido(correoTexto) ? 'Correo inválido' : null,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: salarioController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  cursorColor: colorSalario(),
                  onChanged: (value) {
                    validarFormulario();
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    labelText: 'Salario',
                    labelStyle: TextStyle(color: colorSalario()),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: colorSalario()),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: colorSalario(), width: 2.0),
                    ),
                    errorText: salarioTexto.isNotEmpty && !isSalarioValido(salarioTexto) ? 'Solo números con hasta 2 decimales' : null,
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
                          final nombre = nombreController.text.trim();
                          final correo = correoController.text.trim();
                          final salario = salarioController.text.trim();

                          setState(() {
                            barberosJson.add({
                              "nombre": nombre,
                              "correo": correo,
                              "salario": double.tryParse(salario) ?? 0,
                              "status": "Activo",
                            });
                          });

                          Navigator.of(context).pop();
                        }
                      : null,
                  child: const Text('Añadir', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        );
      });
    },
  );
}

void _mostrarDialogoEditarBarbero(Map<String, dynamic> barbero) {
  final nombreController = TextEditingController(text: barbero['nombre']);
  final correoController = TextEditingController(text: barbero['correo']);
  final salarioController = TextEditingController(text: barbero['salario'].toString());

  bool isValid = false;

  bool isNombreValido(String texto) => RegExp(r'^[a-zA-Z\s]+$').hasMatch(texto) && texto.isNotEmpty;
  bool isCorreoValido(String texto) => RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(texto) && texto.isNotEmpty;
  bool isSalarioValido(String texto) => RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(texto) && texto.isNotEmpty;

  void validarFormulario() {
    final nombre = nombreController.text.trim();
    final correo = correoController.text.trim();
    final salario = salarioController.text.trim();

    final valido = isNombreValido(nombre) && isCorreoValido(correo) && isSalarioValido(salario);

    if (valido != isValid) {
      setState(() {
        isValid = valido;
      });
    }
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, setState) {
        final nombreTexto = nombreController.text.trim();
        final correoTexto = correoController.text.trim();
        final salarioTexto = salarioController.text.trim();

        Color colorNombre() => nombreTexto.isEmpty ? Colors.black : (isNombreValido(nombreTexto) ? Colors.green : Colors.red);
        Color colorCorreo() => correoTexto.isEmpty ? Colors.black : (isCorreoValido(correoTexto) ? Colors.green : Colors.red);
        Color colorSalario() => salarioTexto.isEmpty ? Colors.black : (isSalarioValido(salarioTexto) ? Colors.green : Colors.red);

        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Editar Barbero'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nombreController,
                  cursorColor: colorNombre(),
                  onChanged: (value) {
                    validarFormulario();
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    labelText: 'Nombre',
                    labelStyle: TextStyle(color: colorNombre()),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorNombre())),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorNombre(), width: 2.0)),
                    errorText: nombreTexto.isNotEmpty && !isNombreValido(nombreTexto) ? 'Solo letras permitidas' : null,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: correoController,
                  cursorColor: colorCorreo(),
                  onChanged: (value) {
                    validarFormulario();
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    labelText: 'Correo',
                    labelStyle: TextStyle(color: colorCorreo()),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorCorreo())),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorCorreo(), width: 2.0)),
                    errorText: correoTexto.isNotEmpty && !isCorreoValido(correoTexto) ? 'Correo inválido' : null,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: salarioController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  cursorColor: colorSalario(),
                  onChanged: (value) {
                    validarFormulario();
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    labelText: 'Salario',
                    labelStyle: TextStyle(color: colorSalario()),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorSalario())),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorSalario(), width: 2.0)),
                    errorText: salarioTexto.isNotEmpty && !isSalarioValido(salarioTexto) ? 'Solo números con hasta 2 decimales' : null,
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
                          final nuevoNombre = nombreController.text.trim();
                          final nuevoCorreo = correoController.text.trim();
                          final nuevoSalario = salarioController.text.trim();

                          setState(() {
                            barbero['nombre'] = nuevoNombre;
                            barbero['correo'] = nuevoCorreo;
                            barbero['salario'] = double.tryParse(nuevoSalario) ?? 0;
                          });

                          Navigator.of(context).pop();

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Barbero actualizado'),
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


//WIDGETS

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
                  const SizedBox(height: 20),
                  const Divider(color: Colors.grey),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildTabOption('Usuarios', showUsuarios, () {
                          setState(() {
                            showUsuarios = true;
                            showBarberos = false;
                          });
                        }),
                        const SizedBox(width: 30),
                        _buildTabOption('Barberos', showBarberos, () {
                          setState(() {
                            showUsuarios = false;
                            showBarberos = true;
                          });
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (showUsuarios) _buildTablaUsuarios(),
                  if (showBarberos) _buildTablaBarberos(),
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
 
  Widget _buildTablaUsuarios() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Align(
        alignment: Alignment.centerRight,
        child: ElevatedButton(
          onPressed: _mostrarDialogoAnadirUsuario,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
          ),
          child: const Text('Añadir Usuario'),
        ),
      ),
      const SizedBox(height: 10),
      _buildTablaGenerica(
        columnas: const [
          DataColumn(label: Text('Nombre')),
          DataColumn(label: Text('Correo')),
          DataColumn(label: Text('Editar/Borrar')),
        ],
        filas: usuariosJson.map((usuario) {
          return DataRow(cells: [
            DataCell(Text(usuario['nombre'] ?? '')),
            DataCell(Text(usuario['correo'] ?? '')),
            DataCell(Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.yellow),
                 onPressed: () {
                  final index = usuariosJson.indexOf(usuario);
                  _mostrarDialogoEditarUsuario(index);
                },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    _confirmarEliminacion(
                      context,
                      nombre: usuario['nombre'] ?? '',
                      onConfirmar: () {
                        setState(() {
                          usuariosJson.remove(usuario);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Usuario eliminado'),
                            backgroundColor: Colors.green,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            )),
          ]);
        }).toList(),
      ),
    ],
  );
}

  Widget _buildTablaBarberos() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Align(
        alignment: Alignment.centerRight,
        child: ElevatedButton(
          onPressed: _mostrarDialogoAnadirBarbero,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
          ),
          child: const Text('Añadir Barbero'),
        ),
      ),
      const SizedBox(height: 10),
      _buildTablaGenerica(
        columnas: const [
          DataColumn(label: Text('Nombre')),
          DataColumn(label: Text('Correo')),
          DataColumn(label: Text('Salario')),
          DataColumn(label: Text('Status')),
          DataColumn(label: Text('Editar/Borrar')),
        ],
        filas: barberosJson.map((barbero) {
          return DataRow(cells: [
            DataCell(Text(barbero['nombre'] ?? '')),
            DataCell(Text(barbero['correo'] ?? '')),
            DataCell(Text('\$${barbero['salario']}')),
            DataCell(Text(barbero['status'] ?? '')),
            DataCell(Row(
  children: [
    IconButton(
      icon: const Icon(Icons.edit, color: Colors.yellow),
      onPressed: () {
        _mostrarDialogoEditarBarbero(barbero);
      },
    ),
    IconButton(
      icon: const Icon(Icons.delete, color: Colors.red),
      onPressed: () {
        _confirmarEliminacion(
          context,
          nombre: barbero['nombre'] ?? '',
          onConfirmar: () {
            setState(() {
              barberosJson.remove(barbero);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Barbero eliminado'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );
          },
        );
      },
    ),
  ],
)),

          ]);
        }).toList(),
      ),
    ],
  );
}

  Widget _buildTablaGenerica({
    required List<DataColumn> columnas,
    required List<DataRow> filas,
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
              columns: columnas,
              rows: filas,
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

