import 'package:flutter/material.dart';

class PerfilUsuario extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 36, 36, 36), // Un gris oscuro
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 60),
              // Widget para la imagen de perfil redondeada
              CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage(
                    'images/perfil_image.jpg'), // Ruta local de la imagen
              ),
              SizedBox(height: 50),
              // Nombre del usuario
              Text(
                'Nombre del Usuario',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40), // Reducir ancho
                child: TextField(
                  readOnly: true,
                  textAlign:
                      TextAlign.center, // Centra el texto dentro del TextField
                  decoration: InputDecoration(
                    hintText: 'Juan Pérez', // Nombre del usuario
                    border: InputBorder.none, // Elimina el borde
                  ),
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              SizedBox(height: 30),
              // Número Identificador
              Text(
                'Número Identificador',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: TextField(
                  readOnly: true,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText:
                        '123456789', // Número de identificación del usuario
                    border: InputBorder.none, // Elimina el borde
                  ),
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              SizedBox(height: 30),
              // Cargo
              Text(
                'Cargo',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: TextField(
                  readOnly: true,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: 'Ingeniero de Minas', // Cargo del usuario
                    border: InputBorder.none, // Elimina el borde
                  ),
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              SizedBox(height: 30),
              // Área
              Text(
                'Área',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: TextField(
                  readOnly: true,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: 'Operaciones', // Área de trabajo del usuario
                    border: InputBorder.none, // Elimina el borde
                  ),
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              SizedBox(height: 30),
              // Botón de edición del perfil
            ],
          ),
        ),
      ),
    );
  }
}
