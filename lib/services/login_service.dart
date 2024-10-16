import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginService {
  Future<Map<String, dynamic>?> login(String username, String password) async {
    // Realizamos la solicitud al servidor json-server
    final response = await http.get(Uri.parse('http://10.0.2.2:3000/users'));

    if (response.statusCode == 200) {
      final List<dynamic> users = json.decode(utf8.decode(response.bodyBytes));

      // Verifica si el usuario y contraseña son correctos
      final validUser = users.firstWhere(
        (user) => user['username'] == username && user['password'] == password,
        orElse: () => null,
      );

      if (validUser != null) {
        return validUser; // Devuelve los datos del usuario si es válido
      }
    } else {
      throw Exception('Error al conectarse al servidor');
    }

    return null; // Devuelve null si no se encuentra el usuario
  }
}
