import 'package:flutter/material.dart';
import 'package:minewatch/body/perfil.dart';
import 'package:minewatch/body/notificaciones.dart';
import 'package:minewatch/body/menu.dart';
import 'package:minewatch/components/bottomNavigationBar.dart';
import 'package:minewatch/menu_body/vehicleSearch.dart';
import 'package:minewatch/screens/login.dart';
import 'package:minewatch/body/VehicleDetail.dart'; // Asegúrate de importar VehicleDetail

// Enum para gestionar las diferentes pantallas
enum ScreenType {
  Perfil,
  Menu,
  Notificaciones,
  Flotas,
  Detalles, // Nueva pantalla para detalles del vehículo
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

  @override
  void initState() {
    super.initState();
    currentBodyWidget =
        PerfilUsuario(widget.userData); // Inicializar con PerfilUsuario
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
                currentBodyWidget = Notificaciones();
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
