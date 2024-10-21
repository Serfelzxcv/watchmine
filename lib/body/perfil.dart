import 'package:flutter/material.dart';

class PerfilUsuario extends StatelessWidget {
  final Map<String, dynamic> userData;

  PerfilUsuario(this.userData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF242424), // Un gris oscuro

      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 40),
              // Imagen de perfil con borde y sombra
              CircleAvatar(
                radius: 70,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 65,
                  backgroundImage: NetworkImage(userData['imagenPerfil']),
                  onBackgroundImageError: (error, stackTrace) {
                    print('Error cargando imagen: $error');
                  },
                ),
              ),
              SizedBox(height: 20),
              // Información del usuario con tarjetas
              _buildInfoCard(
                icon: Icons.person,
                title: 'Nombre',
                value: userData['nombre'] ?? 'No disponible',
              ),
              _buildInfoCard(
                icon: Icons.badge,
                title: 'Número Identificador',
                value: userData['identificador'] ?? 'No disponible',
              ),
              _buildInfoCard(
                icon: Icons.work_outline,
                title: 'Cargo',
                value: userData['cargo'] ?? 'No disponible',
              ),
              _buildInfoCard(
                icon: Icons.business_center,
                title: 'Área',
                value: userData['area'] ?? 'No disponible',
              ),
              _buildInfoCard(
                icon: Icons.security,
                title: 'Rol',
                value: userData['role'] ?? 'No disponible',
              ),
              SizedBox(height: 20),
              // Botón de editar (puede ser usado en un futuro)
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // Método para construir una tarjeta de información
  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Card(
        color: Color(0xFF333333),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 5,
        child: ListTile(
          leading: Icon(
            icon,
            color: Colors.yellow,
          ),
          title: Text(
            title,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
