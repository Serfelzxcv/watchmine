import 'package:flutter/material.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  final int currentPageIndex;
  final Function(int) onDestinationSelected;

  const BottomNavigationBarWidget({
    Key? key,
    required this.currentPageIndex,
    required this.onDestinationSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      onDestinationSelected: onDestinationSelected,
      selectedIndex: currentPageIndex,
      indicatorColor: Colors.amber, // Indicador de color ámbar
      backgroundColor: Colors.grey[200], // Color de fondo del NavigationBar
      labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      destinations: <Widget>[
        NavigationDestination(
          icon:
              Icon(Icons.person, color: Colors.black), // Icono no seleccionado
          label: 'Perfil',
        ),
        NavigationDestination(
          icon: Icon(Icons.menu, color: Colors.black),
          label: 'Menú',
        ),
        NavigationDestination(
          icon: Badge(
              child: Icon(Icons.notifications_sharp, color: Colors.black)),
          label: 'Notifications',
        ),
      ],
    );
  }
}
