import 'package:flutter/material.dart';

class PerfilUsuario extends StatelessWidget {
  final Map<String, dynamic> userData;

  PerfilUsuario(this.userData); // Recibimos los datos del usuario

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
              // Widget para la imagen de perfil redondeada desde una URL
              CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(userData[
                    'imagenPerfil']), // Cargamos la imagen desde la URL
                onBackgroundImageError: (error, stackTrace) {
                  print('Error cargando imagen: $error');
                },
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
                    hintText: userData['nombre'], // Nombre del usuario
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
                    hintText: userData['identificador'], // Identificador
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
                    hintText: userData['cargo'], // Cargo del usuario
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
                    hintText: userData['area'], // Área del usuario
                    border: InputBorder.none, // Elimina el borde
                  ),
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              SizedBox(height: 30),
              // Rol del usuario (admin o user)
              Text(
                'Rol',
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
                    hintText: userData['role'], // Rol del usuario
                    border: InputBorder.none, // Elimina el borde
                  ),
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
