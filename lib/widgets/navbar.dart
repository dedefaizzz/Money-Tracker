import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NavBar extends StatelessWidget {
  const NavBar(
      {super.key,
      required this.selectedIndex,
      required this.onDestinatioSelected});
  final int selectedIndex;
  final ValueChanged<int> onDestinatioSelected;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinatioSelected,
      indicatorColor: Colors.deepPurple,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      height: 70,
      destinations: const <Widget>[
        NavigationDestination(
          icon: Icon(Icons.home),
          selectedIcon: Icon(
            Icons.home,
            color: Colors.white,
          ),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.monetization_on),
          selectedIcon: Icon(
            Icons.monetization_on,
            color: Colors.white,
          ),
          label: 'Transaction',
        ),
      ],
    );
  }
}
