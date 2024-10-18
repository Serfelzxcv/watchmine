import 'package:flutter/material.dart';
import 'package:minewatch/body/perfil.dart';
import 'package:minewatch/body/notificaciones.dart';
import 'package:minewatch/body/menu.dart';
// Importa Flotas
import 'package:minewatch/components/bottomNavigationBar.dart';
import 'package:minewatch/menu_body/flotas.dart';
import 'package:minewatch/screens/login.dart'; // Importa la pantalla de Login

enum ScreenType {
  Perfil,
  Menu,
  Notificaciones,
  Flotas,
}

class HomeScreen extends StatefulWidget {
  final Map<String, dynamic> userData; // Añadimos esta línea

  const HomeScreen({Key? key, required this.userData})
      : super(key: key); // Aceptamos userData en el constructor

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ScreenType currentScreen = ScreenType.Perfil;
  int currentPageIndex = 0;

  void onMenuItemSelected(String item) {
    setState(() {
      if (item == 'Flotas') {
        currentScreen = ScreenType.Flotas;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget currentBodyWidget;
    switch (currentScreen) {
      case ScreenType.Perfil:
        currentBodyWidget =
            PerfilUsuario(widget.userData); // Pasamos los datos del usuario
        break;
      case ScreenType.Menu:
        currentBodyWidget = Menu(onItemSelected: onMenuItemSelected);
        break;
      case ScreenType.Notificaciones:
        currentBodyWidget = Notificaciones();
        break;
      case ScreenType.Flotas:
        currentBodyWidget = VehicleSearch();
        break;
    }

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
                // Al hacer clic en el botón de logout, se navega de regreso a la pantalla de Login
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Login()), // Navegar al login
                  (Route<dynamic> route) =>
                      false, // Remover todas las rutas previas
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
              } else if (index == 1) {
                currentScreen = ScreenType.Menu;
              } else if (index == 2) {
                currentScreen = ScreenType.Notificaciones;
              }
            });
          },
        ),
        body: currentBodyWidget,
      ),
    );
  }
}
