import 'package:http/http.dart' as http;
import 'dart:convert';

class VehicleService {
  // Fetch vehicle data from API
  Future<List<dynamic>> fetchVehicles() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:3001/vehicles'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al cargar los datos');
    }
  }
}
