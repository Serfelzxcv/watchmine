import 'package:flutter/material.dart';

class bottomNavigationBar extends StatelessWidget {
  int selectedIndex;
  final Function(int) onItemTapped;

  bottomNavigationBar({
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: NavigationBar(
      onDestinationSelected: (int index) {
        setState(() {
          selectedIndex = index;
        });
      },
      indicatorColor: Colors.amber,
      selectedIndex: selectedIndex,
      destinations: const <Widget>[
        NavigationDestination(
          selectedIcon: Icon(Icons.home),
          icon: Icon(Icons.home_outlined),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Badge(child: Icon(Icons.notifications_sharp)),
          label: 'Notifications',
        ),
        NavigationDestination(
          icon: Badge(
            label: Text('2'),
            child: Icon(Icons.messenger_sharp),
          ),
          label: 'Messages',
        ),
      ],
    ));
  }

  void setState(Null Function() param0) {}
}
