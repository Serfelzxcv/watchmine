import 'package:flutter/material.dart';

class VehicleDetail extends StatefulWidget {
  final Map<String, dynamic> vehicle;

  VehicleDetail({required this.vehicle});

  @override
  _VehicleDetailState createState() => _VehicleDetailState();
}

class _VehicleDetailState extends State<VehicleDetail> {
  bool isMaintenanceSelected = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(),
          SizedBox(height: 20),
          _buildDetailIcons(),
          SizedBox(height: 20),
          _buildTabs(),
          SizedBox(height: 20),
          _buildContent(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.network(
            widget.vehicle['imagen'] ?? 'https://via.placeholder.com/150',
            height: 150,
            width: 150,
            fit: BoxFit.cover,
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.vehicle['placa'] ?? 'Placa desconocida',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '${widget.vehicle['marca'] ?? 'Marca desconocida'} / ${widget.vehicle['año_fabricación']?.toString() ?? 'Año desconocido'}',
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildIconInfo(Icons.local_gas_station,
            widget.vehicle['tipo_combustible'] ?? 'Desconocido', 'Combustible'),
        _buildIconInfo(Icons.car_repair,
            widget.vehicle['categoría_vehículo'] ?? 'Desconocido', 'Categoría'),
        _buildIconInfo(Icons.color_lens,
            widget.vehicle['color_vehículo'] ?? 'Desconocido', 'Color'),
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
        _buildTabButton('Mantenimientos', isMaintenanceSelected),
        SizedBox(width: 10),
        _buildTabButton('Estadísticas', !isMaintenanceSelected),
      ],
    );
  }

  Widget _buildTabButton(String text, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isMaintenanceSelected = text == 'Mantenimientos';
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.yellow : Colors.grey[800],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return isMaintenanceSelected
        ? _buildMaintenanceDetails()
        : _buildStatisticsDetails();
  }

  Widget _buildMaintenanceDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mantenimientos recientes',
          style: TextStyle(color: Colors.yellow, fontSize: 18),
        ),
        SizedBox(height: 10),
        Text(
          'Aquí van los detalles de mantenimientos...',
          style: TextStyle(color: Colors.white),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildStatisticsDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Estadísticas del vehículo',
          style: TextStyle(color: Colors.yellow, fontSize: 18),
        ),
        SizedBox(height: 10),
        Text(
          'Aquí van las estadísticas...',
          style: TextStyle(color: Colors.white),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
