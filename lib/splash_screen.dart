//Pagina de Bienvenida
// Muestra un texto de bienvenida, una imagen personalizada 
//y un indicador de progreso circular.

import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Agrega el texto "Bienvenid@"
            const Text(
              'Bienvenid@',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            // Muestra la imagen personalizada en lugar del FlutterLogo
            Image.asset(
              'lib/src/assets/cinema_logo.png',
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
