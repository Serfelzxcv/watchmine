import 'package:flutter/material.dart';

class VehicleDetail extends StatelessWidget {
  final Map<String, dynamic> vehicle;

  VehicleDetail({required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del Vehículo'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Color.fromARGB(255, 36, 36, 36),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            SizedBox(height: 20),
            _buildDetailIcons(),
            SizedBox(height: 20),
            _buildTabs(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    // Safely handle possible null values with default values
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.network(
          vehicle['imagen'] ??
              'https://via.placeholder.com/150', // Default image if null
          height: 150,
          fit: BoxFit.cover,
        ),
        SizedBox(height: 16),
        Text(
          vehicle['placa'] ?? 'Placa desconocida', // Default if 'placa' is null
          style: TextStyle(
              color: Colors.yellow, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          '${vehicle['marca'] ?? 'Marca desconocida'} / ${vehicle['año_fabricación'] ?? 'Año desconocido'}', // Default for 'marca' and 'año_fabricación'
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildDetailIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildIconInfo(Icons.local_gas_station,
            vehicle['tipo_combustible'] ?? 'Desconocido', 'Combustible'),
        _buildIconInfo(Icons.car_repair,
            vehicle['categoría_vehículo'] ?? 'Desconocido', 'Categoría'),
        _buildIconInfo(Icons.color_lens,
            vehicle['color_vehículo'] ?? 'Desconocido', 'Color'),
      ],
    );
  }

  Widget _buildIconInfo(IconData icon, String info, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.yellow, size: 40),
        SizedBox(height: 8),
        Text(info, style: TextStyle(color: Colors.white, fontSize: 16)),
        SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  Widget _buildTabs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            // Acción de mantenimiento
          },
          child: Text('Mantenimientos'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[800]),
        ),
        SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {
            // Acción de estadísticas
          },
          child: Text('Estadísticas'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow),
        ),
      ],
    );
  }
}
