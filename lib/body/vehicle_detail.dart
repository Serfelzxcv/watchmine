import 'package:flutter/material.dart';
import 'package:minewatch/dialogs/preventive_maintenance_dialog.dart';
import 'package:minewatch/dialogs/maintenance_history_dialog.dart';
import 'package:minewatch/dialogs/corrective_maintenance_history_dialog.dart';
import 'package:minewatch/dialogs/equipment_history_dialog.dart';
import 'package:minewatch/forms/add_equipment_form.dart';
import 'package:minewatch/forms/add_corrective_maintenance_form.dart';

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
          parentContext: this.context,
          vehicleId: widget.vehicle['id'],
          vehicleData: widget.vehicle,
          mantenimientoPreventivo: mantenimientoPreventivo,
        );
      },
    ).then((_) {
      setState(() {});
    });
  }

  // Mostrar un diálogo con el historial de mantenimiento preventivo
  void _showMaintenanceHistoryDialog() {
    final List<dynamic> historialMantenimientoPreventivo =
        widget.vehicle['historial_mantenimiento_preventivo'] ?? [];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MaintenanceHistoryDialog(
          historialMantenimientoPreventivo: historialMantenimientoPreventivo,
        );
      },
    );
  }

  // Mostrar un diálogo con el historial de mantenimiento correctivo
  void _showCorrectiveMaintenanceHistoryDialog() {
    final List<dynamic> historialCorrectivo =
        widget.vehicle['mantenimiento_correctivo'] ?? [];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CorrectiveMaintenanceHistoryDialog(
          historialCorrectivo: historialCorrectivo,
        );
      },
    );
  }

  // Mostrar un diálogo con el historial de equipamiento
  void _showEquipmentHistoryDialog() {
    final List<dynamic> historialEquipamiento =
        widget.vehicle['equipamiento'] ?? [];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EquipmentHistoryDialog(
          historialEquipamiento: historialEquipamiento,
        );
      },
    );
  }

  // Mostrar el formulario de mantenimiento correctivo
  void _showCorrectiveMaintenanceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddCorrectiveMaintenanceForm(
          parentContext: this.context,
          vehicleId: widget.vehicle['id'],
          vehicleData: widget.vehicle,
          onMaintenanceAdded: _onCorrectiveMaintenanceAdded,
        );
      },
    );
  }

  // Mostrar el formulario de equipamiento
  void _showEquipmentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddEquipmentForm(
          parentContext: this.context,
          vehicleId: widget.vehicle['id'],
          vehicleData: widget.vehicle,
          onEquipmentAdded: _onEquipmentAdded,
        );
      },
    );
  }

  // Método para actualizar la lista de mantenimiento correctivo
  void _onCorrectiveMaintenanceAdded(Map<String, dynamic> nuevoCorrectivo) {
    setState(() {
      widget.vehicle['mantenimiento_correctivo'] =
          List.from(widget.vehicle['mantenimiento_correctivo'] ?? [])
            ..add(nuevoCorrectivo);
    });
  }

  // Método para actualizar la lista de equipamiento
  void _onEquipmentAdded(Map<String, dynamic> nuevoEquipamiento) {
    setState(() {
      widget.vehicle['equipamiento'] =
          List.from(widget.vehicle['equipamiento'] ?? [])
            ..add(nuevoEquipamiento);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color.fromARGB(255, 36, 36, 36),
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
      ),
    );
  }

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
        color: Colors.white,
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
          'Tipo de Mantenimiento',
          style: TextStyle(color: Colors.yellow, fontSize: 18),
        ),
        SizedBox(height: 10),
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
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildHistoryIcon(Icons.history, 'Hist. Preventivo',
                  _showMaintenanceHistoryDialog),
              _buildHistoryIcon(Icons.list, 'Hist. Correctivo',
                  _showCorrectiveMaintenanceHistoryDialog),
              _buildHistoryIcon(Icons.inventory, 'Hist. Equipamiento',
                  _showEquipmentHistoryDialog),
            ],
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildMaintenanceIcon(IconData icon, String label) {
    return GestureDetector(
      onTap: () {
        if (label == 'Preventivo') {
          _showPreventiveMaintenanceDialog();
        } else if (label == 'Correctivo') {
          _showCorrectiveMaintenanceDialog();
        } else if (label == 'Equipamiento') {
          _showEquipmentDialog();
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

  Widget _buildHistoryIcon(IconData icon, String label, Function onTap) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Column(
        children: [
          Icon(icon, color: Colors.yellow, size: 40),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(color: Colors.white, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
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
