import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';
import 'src/bottom_nav_bar.dart'; // Importa el nuevo archivo


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1; // Inicio en el índice 1 para que "Inicio" sea el predeterminado

  static const List<Widget> _widgetOptions = <Widget>[
    Text('Configuración'),
    Text('Inicio'),
    Text('Agregar Película'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<ApplicationState>(context).user;

    return Scaffold(
      appBar: AppBar(
        title: Text('Bottom Navigation Bar Example'),
      ),
      body: Center(
        child: _selectedIndex == 1 && user != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Welcome, ${user.displayName ?? user.email}!'),
                  Text('Email: ${user.email}'),
                  // Puedes agregar más datos del usuario aquí
                ],
              )
            : _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}