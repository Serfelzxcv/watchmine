import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minewatch/services/vehicle_service.dart';

class VehicleSearch extends StatefulWidget {
  @override
  _VehicleSearchState createState() => _VehicleSearchState();
}

class _VehicleSearchState extends State<VehicleSearch> {
  TextEditingController _controller = TextEditingController();
  Map<String, dynamic>? _vehicle; // Vehículo encontrado
  bool _notFound = false;
  VehicleService _vehicleService = VehicleService();

  Future<void> _searchVehicle() async {
    try {
      List<dynamic> vehicles = await _vehicleService.fetchVehicles();
      String plate = _controller.text.toUpperCase();

      setState(() {
        _vehicle = vehicles.firstWhere((vehicle) => vehicle['placa'] == plate,
            orElse: () => null);
        _notFound = _vehicle == null;
      });
    } catch (e) {
      throw Exception('Error al buscar el vehículo');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 36, 36, 36),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              _buildHeader(),
              SizedBox(height: 30),
              _buildSearchInput(),
              SizedBox(height: 30),
              _buildResults(),
            ],
          ),
        ),
      ),
    );
  }

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
            textAlignVertical: TextAlignVertical.center,
            style: GoogleFonts.bungee(
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

  Widget _buildResults() {
    if (_vehicle != null) {
      return _buildVehicleCard();
    } else if (_notFound) {
      return _buildNotFound();
    } else {
      return _buildEmptyState();
    }
  }

  Widget _buildVehicleCard() {
    return Card(
      color: Colors.grey[800],
      child: ListTile(
        leading: Icon(Icons.directions_car, color: Colors.yellow),
        title: Text(
          _vehicle!['placa'],
          style: TextStyle(
              color: Colors.yellow, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Oprima para ver más información',
          style: TextStyle(color: Colors.grey),
        ),
        onTap: () {
          // Implementa la acción al hacer clic
        },
      ),
    );
  }

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
