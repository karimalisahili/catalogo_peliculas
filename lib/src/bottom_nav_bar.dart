// Lleva a cabo la creación de la barra de navegación inferior de la aplicación
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavBar(
      {super.key, required this.selectedIndex, required this.onItemTapped});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Configuration',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          label: 'Add Movie',
        ),
      ],
      currentIndex: widget.selectedIndex,
      selectedItemColor: Colors.deepPurple,
      onTap: (index) {
        if (index == 0) {
          // Navegar a la pantalla de perfil de Firebase
          context.push('/home/profile');
        } else if (index == 1) {
          // Navegar a la pantalla de home de Firebase
          context.push('/');
        } else if (index == 2) {
          // Navegar a la pantalla de agregar película
          context.push('/home/agregar-pelicula');
        } else {
          widget.onItemTapped(index);
        }
      },
    );
  }
}
