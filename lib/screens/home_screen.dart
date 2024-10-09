import 'package:flutter/material.dart';
import 'package:minewatch/body/perfil.dart';
import 'package:minewatch/body/notificaciones.dart';
import 'package:minewatch/body/menu.dart';
// Importa Flotas
import 'package:minewatch/components/bottomNavigationBar.dart';
import 'package:minewatch/menu_body/flotas.dart';

enum ScreenType {
  Perfil,
  Menu,
  Notificaciones,
  Flotas,
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

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
      // Puedes manejar otros ítems aquí si lo deseas
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget currentBodyWidget;
    switch (currentScreen) {
      case ScreenType.Perfil:
        currentBodyWidget = PerfilUsuario();
        break;
      case ScreenType.Menu:
        currentBodyWidget = Menu(onItemSelected: onMenuItemSelected);
        break;
      case ScreenType.Notificaciones:
        currentBodyWidget = Notificaciones();
        break;
      case ScreenType.Flotas:
        currentBodyWidget = Flotas();
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
                print("Cerrar sesión");
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
