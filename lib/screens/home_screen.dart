import 'package:flutter/material.dart';
import 'package:minewatch/body/pag1.dart';
import 'package:minewatch/body/pag2.dart';
import 'package:minewatch/body/pag3.dart';
import 'package:minewatch/components/bottomNavigationBar.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Lista de widgets para las diferentes páginas
  final List<Widget> _pages = [
    Pag1(),
    Pag2(),
    Pag3(),
  ];

  // Cambiar el índice cuando se presiona un botón en el BottomNavigationBar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Navegación Inferior'),
      ),
      body: _pages[_selectedIndex], // Mostrar la página seleccionada
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Aquí defines la acción para el botón "Menú"
          print('Botón de Menú presionado');
          setState(() {
            _selectedIndex = 1; // Opcional: redirigir a Pag2 (Menú)
          });
        },
        child: Icon(Icons.menu),
        tooltip: 'Menú',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked, // Centrar el FAB
      bottomNavigationBar: bottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped, // Cambiar el índice
      ),
    );
  }
}

