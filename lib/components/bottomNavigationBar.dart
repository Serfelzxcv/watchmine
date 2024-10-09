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
          icon: Icon(Icons.person, color: Colors.black),
          label: 'Perfil',
        ),
        NavigationDestination(
          icon: Icon(Icons.menu, color: Colors.black),
          label: 'Menú',
        ),
        NavigationDestination(
          icon: Badge(
            child: Icon(Icons.notifications_sharp, color: Colors.black),
          ),
          label: 'Notificaciones',
        ),
      ],
    );
  }
}

// Implementación básica de Badge si no lo tienes
class Badge extends StatelessWidget {
  final Widget child;

  const Badge({required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned(
          right: 0,
          child: Container(
            padding: EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(6),
            ),
            constraints: BoxConstraints(minWidth: 12, minHeight: 12),
            child: Text(
              '1', // Puedes hacerlo dinámico si lo deseas
              style: TextStyle(color: Colors.white, fontSize: 8),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
