import 'package:flutter/material.dart';

class bottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  bottomNavigationBar({
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Pag 1',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.business),
          label: 'Pag 2',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.school),
          label: 'Pag 3',
        ),
      ],
      currentIndex: selectedIndex, // Indica qué botón está seleccionado
      onTap: onItemTapped, // Cambia la página cuando se presiona
    );
  }
}
