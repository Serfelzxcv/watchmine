import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minewatch/screens/home_screen.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: EdgeInsets.only(top: 50, bottom: 80),
        decoration: BoxDecoration(
            color: Colors.black,
            image: DecorationImage(
                image: AssetImage("images/bg.jpg"),
                fit: BoxFit.cover,
                opacity: 0.8)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Mine Watch",
              style: GoogleFonts.bungee(
                fontSize: 50,
                color: const Color.fromARGB(255, 255, 184, 4),
              ),
            ),
            Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255).withOpacity(0.5),
                  ),
                  child: Text(
                    "La mejor manera de evitar un accidente es anticipándolo.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 150),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      // Acción del botón
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeScreen()));
                    },
                    splashColor: const Color.fromARGB(255, 255, 255, 255)
                        .withOpacity(0.5), // Efecto splash visible
                    highlightColor: Colors.orangeAccent
                        .withOpacity(0.2), // Color al presionar
                    borderRadius: BorderRadius.circular(10), // Borde redondeado
                    child: Ink(
                      decoration: BoxDecoration(
                        color:
                            Color.fromARGB(255, 255, 184, 4), // Color del botón
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                        child: Text(
                          "Adelante",
                          style: TextStyle(
                              color: const Color.fromARGB(255, 0, 0, 0),
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 50),
              ],
            )
          ],
        ),
      ),
    );
  }
}
