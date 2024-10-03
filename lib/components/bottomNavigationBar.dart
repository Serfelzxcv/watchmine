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
      destinations: const <Widget>[
        NavigationDestination(
          selectedIcon: Icon(Icons.home,
              color: Colors.amber), // Icono seleccionado con color ámbar
          icon: Icon(Icons.home_outlined,
              color: Colors.black), // Icono no seleccionado
          label: 'Home',
        ),
        NavigationDestination(
          icon: Badge(
              child: Icon(Icons.notifications_sharp, color: Colors.black)),
          label: 'Notifications',
        ),
        NavigationDestination(
          icon: Badge(
            label: Text('2', style: TextStyle(color: Colors.white)),
            child: Icon(Icons.messenger_sharp, color: Colors.black),
          ),
          label: 'Messages',
        ),
      ],
    );
  }
}
