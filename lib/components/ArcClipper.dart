import 'package:flutter/material.dart';

class ArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.moveTo(0.0, 150); // Empezamos desde la parte inferior izquierda
    path.quadraticBezierTo(
      size.width / 2, 0.0, // Punto de control en el centro
      size.width, 150, // Parte inferior derecha
    );
    path.lineTo(
        size.width, size.height); // Línea recta hacia abajo a la derecha
    path.lineTo(0.0, size.height); // Línea recta hacia abajo a la izquierda5
    path.close(); // Cerrar el path
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
