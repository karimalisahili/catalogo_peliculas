import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:go_router/go_router.dart';

class BottomNavBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  BottomNavBar({required this.selectedIndex, required this.onItemTapped});

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
          label: 'Configuración',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          label: 'Agregar Película',
        ),
      ],
      currentIndex: widget.selectedIndex,
      selectedItemColor: Colors.red[800],
      onTap: (index) {
        if (index == 0) {
          // Navegar a la pantalla de perfil de Firebase
          context.push('/home/profile');
        } else {
          widget.onItemTapped(index);
        }
      },
    );
  }
}