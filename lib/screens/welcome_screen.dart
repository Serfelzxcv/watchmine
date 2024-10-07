import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minewatch/screens/login.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFF800020),
            // Fondo granate con opacidad 1
          ),
          child: Column(
            children: [
              // Texto "Mine Watch" en la parte superior
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Text(
                  "Mine Watch",
                  style: GoogleFonts.bungee(
                    fontSize: 50,
                    color: const Color.fromARGB(255, 255, 184, 4),
                  ),
                ),
              ),
              // Spacer para crear espacio flexible
              Spacer(),
              // Logo en el centro
              SizedBox(
                width: 200, // Ancho del logo
                height: 200, // Altura del logo
                child: Image.asset(
                  'images/logoMineWatch.png',
                  fit: BoxFit.contain,
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
              ),

              // Textos debajo del logo
              Column(
                children: [
                  Text(
                    "Analytica",
                    style: GoogleFonts.lato(
                      fontSize: 50,
                      color: const Color.fromARGB(255, 255, 184, 4),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Text(
                        "Empresa Minera dedicada a la exploración, explotación y beneficios de minerales.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(
                          fontSize: 17,
                          color: const Color(0xFFFFFFFF),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Spacer(),
              // Botón en la parte inferior
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 30.0), // Padding para mover el botón hacia abajo
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Login(),
                        ),
                      );
                    },
                    splashColor: const Color.fromARGB(255, 255, 255, 255)
                        .withOpacity(0.5),
                    highlightColor: Colors.orangeAccent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                    child: Ink(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 184, 4),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                        child: Text(
                          "INGRESAR",
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
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
