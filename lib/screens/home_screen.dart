import 'package:flutter/material.dart';
import 'package:minewatch/body/perfil.dart';
import 'package:minewatch/body/notificaciones.dart';
import 'package:minewatch/body/menu.dart';
import 'package:minewatch/body/vehicle_detail.dart';
import 'package:minewatch/components/bottomNavigationBar.dart';
import 'package:minewatch/menu_icons_body/vehicleSearch.dart';
import 'package:minewatch/screens/login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Enum para gestionar las diferentes pantallas
enum ScreenType {
  Perfil,
  Menu,
  Notificaciones,
  Flotas,
  Detalles,
}

class HomeScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  const HomeScreen({Key? key, required this.userData}) : super(key: key);

  @override
  State<HomeScreen> createState() => HomeScreenState(); // Clase State pública
}

class HomeScreenState extends State<HomeScreen> {
  ScreenType currentScreen = ScreenType.Perfil;
  int currentPageIndex = 0;
  Widget currentBodyWidget = Container(); // Inicialización vacía
  List<Map<String, dynamic>> vehiculos =
      []; // Lista para almacenar los vehículos

  @override
  void initState() {
    super.initState();
    currentBodyWidget =
        PerfilUsuario(widget.userData); // Inicializar con PerfilUsuario
    _cargarVehiculos(); // Cargar los vehículos al iniciar
  }

  // Función para cargar los vehículos desde la API
  void _cargarVehiculos() async {
    final String apiUrl = 'http://localhost:3001/vehicles';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        setState(() {
          vehiculos =
              List<Map<String, dynamic>>.from(json.decode(response.body));
        });
      } else {
        print('Error al cargar los vehículos: ${response.statusCode}');
      }
    } catch (e) {
      print('Ocurrió un error al cargar los vehículos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF800020),
          actions: [
            IconButton(
              icon: Icon(Icons.contact_support),
              color: Colors.white,
              onPressed: () {
                print("Ir a Contáctanos");
              },
            ),
            IconButton(
              icon: Icon(Icons.settings),
              color: Colors.white,
              onPressed: () {
                print("Ir a Configuración");
              },
            ),
            IconButton(
              icon: Icon(Icons.logout),
              color: Colors.white,
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBarWidget(
          currentPageIndex: currentPageIndex,
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
              if (index == 0) {
                currentScreen = ScreenType.Perfil;
                currentBodyWidget = PerfilUsuario(widget.userData);
              } else if (index == 1) {
                currentScreen = ScreenType.Menu;
                currentBodyWidget = Menu(onItemSelected: onMenuItemSelected);
              } else if (index == 2) {
                currentScreen = ScreenType.Notificaciones;
                currentBodyWidget = Notificaciones(
                  vehiculos: vehiculos, // Pasar la lista de vehículos
                );
              }
            });
          },
        ),
        body: currentBodyWidget,
      ),
    );
  }

  // Manejar selección de ítems en el menú
  void onMenuItemSelected(String item) {
    setState(() {
      if (item == 'Flotas') {
        currentScreen = ScreenType.Flotas;
        currentBodyWidget = VehicleSearch(onVehicleSelected: onVehicleSelected);
      }
    });
  }

  // Callback para manejar la selección de un vehículo
  void onVehicleSelected(Map<String, dynamic> vehicle) {
    setState(() {
      currentScreen = ScreenType.Detalles;
      currentBodyWidget = VehicleDetail(vehicle: vehicle);
    });
  }
}
