import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:lottie/lottie.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter login web',
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        primarySwatch: Colors.deepPurple,
      ),
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 8,
        ),
        children: [Menu(), Body()],
      ),
    );
  }
}

//Navegación Superior
class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  String? _hoveredItem;
  bool _hoveredRegister = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              _menuItem('Inicio'),
              _menuItem('Sobre Nosotros'),
              _menuItem('Contáctanos'),
            ],
          ),
          Spacer(),
          Row(
            children: [
              _menuItem('Inicia Sesión', isActive: true),
              SizedBox(width: 32),
              _registerButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _menuItem(String title, {bool isActive = false}) {
    final bool isHover = _hoveredItem == title;
    final Color baseColor =
        isActive
            ? Colors.deepPurple
            : (isHover ? Colors.deepPurple : Colors.grey);

    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredItem = title),
      onExit: (_) => setState(() => _hoveredItem = null),
      cursor: SystemMouseCursors.click,
      child: Padding(
        padding: EdgeInsets.only(right: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, color: baseColor),
            ),
            SizedBox(height: 6),
            if (isActive)
              Container(
                height: 3,
                width: 24,
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _registerButton() {
    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredRegister = true),
      onExit: (_) => setState(() => _hoveredRegister = false),
      cursor: SystemMouseCursors.click,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[200]!,
              spreadRadius: 10,
              blurRadius: 12,
            ),
          ],
        ),
        child: Text(
          'Registrate',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: _hoveredRegister ? Colors.deepPurple : Colors.black54,
          ),
        ),
      ),
    );
  }
}

//Contenido Pricipal
class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          //Bloque de Texto
          width: 360,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Inicia Sesión\nBarbería',
                style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),
              Text(
                "No tienes una cuenta",
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    'Puedes',
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 15),
                  Text(
                    'Registrate aquí',
                    style: TextStyle(
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Image.asset('imag/hombre.png', width: 300), //Imagen Central
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height / 10,
          ),
          child: Container(width: 280, child: _formLogin()),
        ),
      ],
    );
  }

  Widget _formLogin() {
    //Formulario de Login
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: 'Ingresa e-mail o número de teléfono',
            filled: true,
            labelStyle: TextStyle(fontSize: 10),
            contentPadding: EdgeInsets.only(left: 30),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueGrey[50]!),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueGrey[50]!),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),

        SizedBox(height: 30),
        TextField(
          decoration: InputDecoration(
            hintText: 'Ingresa Contraseña',
            counterText: '¿Olvidó Contraseña?',
            suffixIcon: Icon(Icons.visibility_off_outlined, color: Colors.grey),
            fillColor: Colors.blueGrey[50],
            filled: true,
            labelStyle: TextStyle(fontSize: 10),
            contentPadding: EdgeInsets.only(left: 30),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueGrey[50]!),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueGrey[50]!),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        SizedBox(height: 40),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurple[100]!,
                spreadRadius: 10,
                blurRadius: 20,
              ),
            ],
          ),
          child: ElevatedButton(
            child: Container(
              width: double.infinity,
              height: 50,
              child: Center(child: Text('Continuar')),
            ),
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
        SizedBox(height: 40),
        Row(
          children: [
            Expanded(child: Divider(height: 50, color: Colors.grey[300])),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text('O continuar con'),
            ),
            Expanded(child: Divider(height: 50, color: Colors.grey[300])),
          ],
        ),
        SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _loginWithButton(image: 'imag/google.png'),
            _loginWithButton(image: 'imag/github.png', isActive: true),
            _loginWithButton(image: 'imag/facebook.png'),
          ],
        ),
      ],
    );
  }

  Widget _loginWithButton({String? image, bool isActive = false}) {
    return Container(
      width: 90,
      height: 70,
      decoration:
          isActive
              ? BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[400]!,
                    spreadRadius: 2,
                    blurRadius: 15,
                  ),
                ],
              )
              : BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey[400]!),
              ),
      child: Center(
        child: Container(
          decoration:
              isActive
                  ? BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(35),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[400]!,
                        spreadRadius: 2,
                        blurRadius: 15,
                      ),
                    ],
                  )
                  : BoxDecoration(),
          child: Image.asset('$image', width: 35),
        ),
      ),
    );
  }
}
