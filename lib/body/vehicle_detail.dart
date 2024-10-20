import 'package:flutter/material.dart';
import 'package:minewatch/dialogs/preventive_maintenance_dialog.dart';
import 'package:minewatch/dialogs/maintenance_history_dialog.dart'; // Importar el diálogo de historial

class VehicleDetail extends StatefulWidget {
  final Map<String, dynamic> vehicle;

  VehicleDetail({required this.vehicle});

  @override
  _VehicleDetailState createState() => _VehicleDetailState();
}

class _VehicleDetailState extends State<VehicleDetail> {
  bool isMaintenanceSelected = true;

  @override
  void initState() {
    super.initState();
    print('Datos del Vehículo:');
    widget.vehicle.forEach((key, value) {
      print('$key: $value');
    });
  }

  // Mostrar un diálogo con los mantenimientos preventivos
  void _showPreventiveMaintenanceDialog() {
    final List<dynamic> mantenimientoPreventivo =
        widget.vehicle['mantenimiento_preventivo'] ?? [];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PreventiveMaintenanceDialog(
          mantenimientoPreventivo: mantenimientoPreventivo,
        );
      },
    );
  }

  // Mostrar un diálogo con el historial de mantenimiento
  void _showMaintenanceHistoryDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MaintenanceHistoryDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 36, 36, 36), // Fondo oscuro
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            SizedBox(height: 50),
            _buildDetailIcons(),
            SizedBox(height: 50),
            _buildTabs(),
            SizedBox(height: 50),
            _buildContent(),
          ],
        ),
      ),
    );
  }

  // Construcción del encabezado con fondo blanco
  Widget _buildHeader() {
    final placa = widget.vehicle['placa'] ?? 'Placa desconocida';
    final marca = widget.vehicle['marca'] ?? 'Marca desconocida';
    final anio =
        widget.vehicle['anio_fabricacion']?.toString() ?? 'Año desconocido';
    final numeroMotor =
        widget.vehicle['numero_motor'] ?? 'Número de motor desconocido';

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white, // Fondo blanco para el encabezado
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.network(
            widget.vehicle['imagen'] ?? 'https://via.placeholder.com/150',
            height: 100,
            width: 100,
            fit: BoxFit.cover,
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    placa,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 8),
                _buildRichText('Marca: ', marca),
                SizedBox(height: 4),
                _buildRichText('Año de Fabricación: ', anio),
                SizedBox(height: 4),
                _buildRichText('Número de Motor: ', numeroMotor),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Función para construir el texto con el título en negrita y el valor normal
  Widget _buildRichText(String title, String value) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: title,
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: value,
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  // Construcción de los íconos de detalle
  Widget _buildDetailIcons() {
    final tipoCombustible = widget.vehicle['tipo_combustible'] ?? 'Desconocido';
    final categoria = widget.vehicle['categoria_vehiculo'] ?? 'Desconocido';
    final colorVehiculo = widget.vehicle['color_vehiculo'] ?? 'Desconocido';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildIconInfo(Icons.local_gas_station, tipoCombustible, 'Combustible'),
        _buildIconInfo(Icons.category, categoria, 'Categoría'),
        _buildIconInfo(Icons.color_lens, colorVehiculo, 'Color'),
      ],
    );
  }

  // Construcción de cada ícono de detalle
  Widget _buildIconInfo(IconData icon, String info, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.yellow, size: 40),
        SizedBox(height: 8),
        Text(
          info,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }

  // Construcción de las pestañas de Mantenimientos y Estadísticas
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

  // Construcción de cada botón de pestaña
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

  // Construcción del contenido dinámico basado en la pestaña seleccionada
  Widget _buildContent() {
    return isMaintenanceSelected
        ? _buildMaintenanceDetails()
        : _buildStatisticsDetails();
  }

  // Detalles de Mantenimientos
  Widget _buildMaintenanceDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tipo de Mantenimiento',
          style: TextStyle(color: Colors.yellow, fontSize: 18),
        ),
        SizedBox(height: 10),
        // Caja que muestra íconos de tipo de mantenimiento
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMaintenanceIcon(Icons.warning, 'Preventivo'),
              _buildMaintenanceIcon(Icons.build, 'Correctivo'),
              _buildMaintenanceIcon(Icons.car_rental, 'Equipamiento'),
            ],
          ),
        ),
        SizedBox(height: 20),
        Text(
          'Historial de Mantenimiento',
          style: TextStyle(color: Colors.yellow, fontSize: 18),
        ),
        SizedBox(height: 10),
        // Caja centrada con icono de historial de mantenimiento
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: GestureDetector(
              onTap: _showMaintenanceHistoryDialog,
              child: Column(
                children: [
                  Icon(Icons.history, color: Colors.yellow, size: 64),
                  SizedBox(height: 8),
                  Text(
                    'Historial de Mantenimiento',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  // Construcción de cada ícono de tipo de mantenimiento
  Widget _buildMaintenanceIcon(IconData icon, String label) {
    return GestureDetector(
      onTap: () {
        if (label == 'Preventivo') {
          _showPreventiveMaintenanceDialog();
        }
      },
      child: Column(
        children: [
          Icon(icon, color: Colors.yellow, size: 40),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }

  // Detalles de Estadísticas
  Widget _buildStatisticsDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Estadísticas del vehículo',
          style: TextStyle(color: Colors.yellow, fontSize: 18),
        ),
        SizedBox(height: 10),
        // Caja que muestra contenido dinámico de estadísticas
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Kilometraje total: 45,000 km',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'Consumo promedio de combustible: 15 km/l',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'Uso diario promedio: 50 km',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
