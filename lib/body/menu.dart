import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  final Function(String) onItemSelected;

  Menu({required this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Contenido base si lo hubiera
        Container(),
        // Diálogo flotante que solo cubre el body
        Positioned.fill(
          child: Column(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    // Si deseas que al tocar fuera del diálogo haga algo, puedes manejarlo aquí
                  },
                  child: Container(
                    color: Colors.black.withOpacity(0.5), // Opaca solo el body
                    alignment: Alignment.center,
                    child: Container(
                      width: 300, // Ancho del cuadro
                      height: 300, // Altura del cuadro
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: GridView.count(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        padding: EdgeInsets.all(10.0),
                        children: [
                          _buildAppIcon(Icons.car_repair, 'Flotas'),
                          _buildAppIcon(Icons.message, 'Mensajes'),
                          _buildAppIcon(Icons.camera_alt, 'Cámara'),
                          _buildAppIcon(Icons.photo, 'Fotos'),
                          _buildAppIcon(Icons.music_note, 'Música'),
                          _buildAppIcon(Icons.settings, 'Ajustes'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 0),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAppIcon(IconData iconData, String label) {
    return GestureDetector(
      onTap: () {
        print('Has seleccionado $label');
        onItemSelected(label); // Notifica al HomeScreen la selección
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            iconData,
            size: 40.0,
            color: Colors.blue,
          ),
          SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(fontSize: 14.0),
          ),
        ],
      ),
    );
  }
}
