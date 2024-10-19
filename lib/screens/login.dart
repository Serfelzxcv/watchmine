import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minewatch/components/ArcClipper.dart';
import 'package:minewatch/screens/home_screen.dart';
import 'package:minewatch/services/login_service.dart'; // Importamos el servicio de login

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FocusNode _focusNodeUser = FocusNode();
  final FocusNode _focusNodePassword = FocusNode();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isUserFocused = true;
  bool _isPasswordFocused = true;
  bool _passwordVisible = false; // Controla si la contraseña es visible

  final LoginService _loginService =
      LoginService(); // Instanciamos el servicio de login

  @override
  void initState() {
    super.initState();

    // Limpiar los campos al iniciar la pantalla
    _usernameController.clear();
    _passwordController.clear();

    _focusNodeUser.addListener(() {
      setState(() {
        _isUserFocused =
            !_focusNodeUser.hasFocus && _usernameController.text.isEmpty;
      });
    });

    _focusNodePassword.addListener(() {
      setState(() {
        _isPasswordFocused =
            !_focusNodePassword.hasFocus && _passwordController.text.isEmpty;
      });
    });
  }

  @override
  void dispose() {
    _focusNodeUser.dispose();
    _focusNodePassword.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    // Verificar si los campos están vacíos
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, complete todos los campos')),
      );
      return;
    }

    try {
      // Usamos el servicio de login
      final userData = await _loginService.login(
        _usernameController.text,
        _passwordController.text,
      );

      if (userData != null) {
        // Si el login es exitoso, navega a la pantalla de perfil con los datos del usuario
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(
                userData:
                    userData), // Navegamos a HomeScreen y pasamos los datos del usuario
          ),
        );
      } else {
        // Si las credenciales son incorrectas
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usuario o contraseña incorrectos')),
        );
      }
    } catch (e) {
      // Manejar error de conexión
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al conectarse al servidor')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 36, 36, 36),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Logo en el centro de la pantalla
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 200,
                      height: 200,
                      child: Image.asset(
                        'images/logoMineWatch.png',
                        fit: BoxFit.contain,
                        color: Color.fromARGB(255, 36, 36, 36),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Texto "Analytica"
                    Text(
                      "Analytica",
                      style: GoogleFonts.lato(
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
                        style: GoogleFonts.lato(
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
                  height: 600,
                  color: Color(0xFF800020),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Campo de texto para el usuario
                        Container(
                          width: 350,
                          child: TextField(
                            controller: _usernameController,
                            focusNode: _focusNodeUser,
                            decoration: InputDecoration(
                              hintText: _isUserFocused ? 'Usuario' : null,
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        // Campo de texto para la contraseña con ícono de ojo
                        Container(
                          width: 350,
                          child: TextField(
                            controller: _passwordController,
                            focusNode: _focusNodePassword,
                            obscureText:
                                !_passwordVisible, // Oculta o muestra el texto de la contraseña
                            decoration: InputDecoration(
                              hintText:
                                  _isPasswordFocused ? 'Contraseña' : null,
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  // Alternar visibilidad de la contraseña
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                              ),
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
                              onTap: _login,
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
