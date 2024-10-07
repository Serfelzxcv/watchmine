import 'package:flutter/material.dart';
import 'package:minewatch/body/perfil.dart';
import 'package:minewatch/body/notificaciones.dart';
import 'package:minewatch/body/menu.dart';
import 'package:minewatch/components/bottomNavigationBar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPageIndex = 0;

  final List<Widget> pages = [
    Perfil(),
    Menu(),
    Notificaciones(),
  ];

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
                // Acción para contactar
                print("Ir a Contáctanos");
              },
            ),
            IconButton(
              icon: Icon(Icons.settings),
              color: Colors.white,
              onPressed: () {
                // Acción para la configuración
                print("Ir a Configuración");
              },
            ),
            IconButton(
              icon: Icon(Icons.logout),
              color: Colors.white,
              onPressed: () {
                // Acción para cerrar sesión
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
            });
          },
        ),
        body: pages[currentPageIndex],
      ),
    );
  }
}
