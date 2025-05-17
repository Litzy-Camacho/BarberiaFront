import 'package:flutter/material.dart';
import '../Login/login.dart';
import '../Clients/user_profile.dart';
import '../Administrator/admin_profile.dart';
import '../Barber/barber_profile.dart'; // Ajusta si no tienes esta pantalla
import '../Login/session.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Function(String) onNavigateToSection;
  final VoidCallback? scrollToTop;

  CustomAppBar({
    Key? key,
    required this.onNavigateToSection,
    this.scrollToTop,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  String selectedOption = 'Inicio';

  void _handleSelection(String option) {
    setState(() {
      selectedOption = option;
    });

    if (option == 'Inicio') {
  widget.onNavigateToSection('inicio');
} else {
  widget.onNavigateToSection(option);
}

  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: GestureDetector(
          onTap: () {
  widget.onNavigateToSection('inicio');
},

          child: Image.asset(
            'assets/imag/logo.png',
            height: 50,
          ),
        ),
      ),
      centerTitle: true,
      title: Container(
        width: 140,
        alignment: Alignment.center,
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedOption,
            dropdownColor: Colors.black,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            icon: const SizedBox.shrink(),
            isExpanded: true,
            items: const [
              DropdownMenuItem(value: 'Inicio', child: Center(child: Text('Inicio'))),
              DropdownMenuItem(value: 'Nosotros', child: Center(child: Text('Nosotros'))),
              DropdownMenuItem(value: 'Servicios', child: Center(child: Text('Servicios'))),
              DropdownMenuItem(value: 'Contacto', child: Center(child: Text('Contacto'))),
            ],
            onChanged: (value) {
              if (value != null) {
                _handleSelection(value);
              }
            },
          ),
        ),
      ),
      actions: [
        ValueListenableBuilder<String?>(
          valueListenable: Session.email,
          builder: (context, userEmail, _) {
            if (userEmail == null) {
              // Usuario no logueado
              return PopupMenuButton<String>(
                icon: const Icon(Icons.person, color: Colors.white),
                onSelected: (value) {
                  if (value == 'login') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                    );
                  }
                },
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem<String>(
                    value: 'login',
                    child: Text('Iniciar sesión'),
                  ),
                ],
              );
            } else {
              // Usuario logueado
              return PopupMenuButton<String>(
                icon: const Icon(Icons.person, color: Colors.white),
                onSelected: (value) {
                  if (value == 'profile') {
                    Widget profilePage;

                    if (userEmail == 'admin@gmail.com') {
                      profilePage = const PantallaAdministrador();
                    } else if (userEmail == 'barber@gmail.com') {
                      profilePage = const PantallaBarbero();
                    } else {
                      profilePage = const PantallaUsuario();
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => profilePage),
                    );
                  } else if (value == 'logout') {
                    Session.email.value = null;
                    Session.role.value = null;
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                      (route) => false,
                    );
                  }
                },
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem<String>(
                    value: 'profile',
                    child: Text('Ver perfil'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'logout',
                    child: Text('Cerrar sesión'),
                  ),
                ],
              );
            }
          },
        ),
        const SizedBox(width: 10),
      ],
    );
  }
}
