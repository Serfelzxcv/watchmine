import 'package:flutter/material.dart';
import 'package:minewatch/services/vehicle_service.dart';

class VehicleSearch extends StatefulWidget {
  final void Function(Map<String, dynamic>) onVehicleSelected;

  // Constructor actualizado para aceptar el callback
  VehicleSearch({required this.onVehicleSelected});

  @override
  _VehicleSearchState createState() => _VehicleSearchState();
}

class _VehicleSearchState extends State<VehicleSearch> {
  TextEditingController _controller = TextEditingController();
  VehicleService _vehicleService = VehicleService();
  Map<String, dynamic>? _vehicle;
  bool _notFound = false;
  bool _loading = false;

  // Función para buscar el vehículo por placa
  Future<void> _searchVehicle() async {
    setState(() {
      _loading = true;
      _notFound = false;
    });

    try {
      List<dynamic> vehicles = await _vehicleService.fetchVehicles();
      String plate = _controller.text.toUpperCase();

      setState(() {
        _vehicle = vehicles.firstWhere(
          (vehicle) => vehicle['placa'] == plate,
          orElse: () => null,
        );
        _notFound = _vehicle == null;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _notFound = true;
      });
      print('Error al buscar vehículo: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 36, 36, 36), // Fondo oscuro
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            _buildHeader(),
            SizedBox(height: 30),
            _buildSearchInput(),
            SizedBox(height: 30),
            _loading ? CircularProgressIndicator() : _buildResults(),
          ],
        ),
      ),
    );
  }

  // Construcción del encabezado con el logo
  Widget _buildHeader() {
    return Column(
      children: [
        SizedBox(
          height: 200,
          width: 200,
          child: Image.asset(
            'images/logoMineWatch.png',
            fit: BoxFit.contain,
            color: const Color.fromARGB(255, 255, 184, 4),
          ),
        ),
        SizedBox(height: 16),
        Text(
          'ANALYTICS',
          style: TextStyle(
              color: const Color.fromARGB(255, 255, 184, 4),
              fontSize: 24,
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  // Construcción del campo de búsqueda
  Widget _buildSearchInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Ingresar placa a buscar',
            style: TextStyle(
                color: const Color.fromARGB(255, 255, 184, 4), fontSize: 20),
            textAlign: TextAlign.start,
          ),
          SizedBox(height: 10),
          TextField(
            controller: _controller,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              color: const Color.fromARGB(255, 255, 255, 255),
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.black,
              hintText: '--- ---',
              hintStyle: TextStyle(color: Colors.grey, fontSize: 25),
              contentPadding: EdgeInsets.symmetric(vertical: 15),
              border: OutlineInputBorder(),
            ),
            onSubmitted: (_) => _searchVehicle(),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _searchVehicle,
            child: Text('Buscar'),
          ),
        ],
      ),
    );
  }

  // Construcción de los resultados de la búsqueda
  Widget _buildResults() {
    if (_vehicle != null) {
      return _buildVehicleCard();
    } else if (_notFound) {
      return _buildNotFound();
    } else {
      return _buildEmptyState();
    }
  }

  // Construcción de la tarjeta del vehículo encontrado
  Widget _buildVehicleCard() {
    return GestureDetector(
      onTap: () {
        // Invocar el callback pasando el vehículo seleccionado
        widget.onVehicleSelected(_vehicle!);
      },
      child: Card(
        color: Colors.grey[800],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Imagen agrandada del vehículo
              Image.network(
                _vehicle!['imagen'],
                width: 100, // Tamaño aumentado para una imagen más grande
                height: 80,
                fit: BoxFit.cover,
              ),
              SizedBox(width: 16), // Espacio entre la imagen y la placa
              // Placa centrada
              Expanded(
                child: Center(
                  child: Text(
                    _vehicle!['placa'],
                    style: TextStyle(
                      color: Colors.yellow,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Mensaje cuando no se encuentra el vehículo
  Widget _buildNotFound() {
    return Column(
      children: [
        Icon(Icons.sentiment_dissatisfied, color: Colors.grey, size: 64),
        SizedBox(height: 16),
        Text(
          'No se encontró ningún vehículo con esa placa',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ],
    );
  }

  // Estado vacío antes de realizar una búsqueda
  Widget _buildEmptyState() {
    return Column(
      children: [
        Icon(Icons.search, color: Colors.grey, size: 64),
        SizedBox(height: 16),
        Text(
          'Aquí aparecerá el vehículo de la placa que ingresaste',
          style: TextStyle(color: Colors.white, fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
