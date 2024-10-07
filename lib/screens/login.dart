import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minewatch/components/ArcClipper.dart';
import 'package:minewatch/screens/home_screen.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // FocusNodes para controlar cuándo los campos tienen foco
  final FocusNode _focusNodeUser = FocusNode();
  final FocusNode _focusNodePassword = FocusNode();

  // Variables para controlar si el labelText debe mostrarse o no
  bool _isUserFocused = true;
  bool _isPasswordFocused = true;

  @override
  void initState() {
    super.initState();
    // Añadimos listeners a los focusNodes para detectar cambios
    _focusNodeUser.addListener(() {
      setState(() {
        _isUserFocused = !_focusNodeUser.hasFocus;
      });
    });
    _focusNodePassword.addListener(() {
      setState(() {
        _isPasswordFocused = !_focusNodePassword.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNodeUser.dispose();
    _focusNodePassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          // Aquí se permite que el contenido sea desplazable
          child: Column(
            children: [
              // Logo en el centro de la pantalla
              SizedBox(
                height: MediaQuery.of(context).size.height *
                    0.4, // Para que ocupe espacio flexible
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 200,
                      height: 200, // Ajusta el tamaño del logo
                      child: Image.asset(
                        'images/logoMineWatch.png',
                        fit: BoxFit.contain,
                        color: const Color.fromARGB(255, 255, 184, 4),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Texto "Analytica"
                    Text(
                      "Analytica",
                      style: GoogleFonts.aDLaMDisplay(
                        fontSize: 50,
                        color: const Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                    SizedBox(height: 10),
                    // Texto descriptivo de la empresa
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        "Empresa Minera dedicada a la exploración, explotación y beneficios de minerales.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.aDLaMDisplay(
                          fontSize: 18,
                          color: const Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Arco en la parte inferior con los campos de texto y el botón
              ClipPath(
                clipper: ArcClipper(),
                child: Container(
                  width: double.infinity,
                  height: 600, // Ajusta la altura del arco según sea necesario
                  color: Color(0xFF800020), // Color del arco
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Campo de texto para el usuario
                        Container(
                          width: 350, // Ancho del TextField
                          child: TextField(
                            focusNode: _focusNodeUser, // Asignar FocusNode
                            decoration: InputDecoration(
                              labelText: _isUserFocused ? 'Usuario' : null,
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white, // Color de fondo blanco
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        // Campo de texto para la contraseña
                        Container(
                          width: 350,
                          child: TextField(
                            focusNode: _focusNodePassword, // Asignar FocusNode
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText:
                                  _isPasswordFocused ? 'Contraseña' : null,
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white, // Fondo blanco
                            ),
                          ),
                        ),
                        SizedBox(height: 70),
                        // Botón de inicio de sesión
                        Padding(
                          padding: const EdgeInsets.only(bottom: 30.0),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomeScreen(),
                                  ),
                                );
                              },
                              splashColor:
                                  const Color.fromARGB(255, 255, 255, 255)
                                      .withOpacity(0.5),
                              highlightColor:
                                  Colors.orangeAccent.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                              child: Ink(
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 255, 184, 4),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 50),
                                  child: Text(
                                    "INICIAR SESIÓN",
                                    style: TextStyle(
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1,
                                    ),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
