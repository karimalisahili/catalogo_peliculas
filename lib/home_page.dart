//Pantalla donde se visualiza el catalogo de peliculas, ver el detalle o eliminar la pelicula.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'src/bottom_nav_bar.dart'; // Importa el nuevo archivo
import 'movie_details_screen.dart'; // Importa la pantalla de detalles de la película

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex =
      1; // Inicio en el índice 1 para que "Inicio" sea el predeterminado

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _deleteMovie(String movieId) async {
    final confirmation = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Movie'),
        content: const Text('Are you sure you want to delete this movie?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmation == true) {
      // Obtener la referencia del documento
      final docRef =
          FirebaseFirestore.instance.collection('movies').doc(movieId);

      // Obtener los datos del documento
      final docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        final imagePath = data?['image'];

        // Eliminar el documento de Firebase
        await docRef.delete();

        // Verificar si la imagen es referenciada por otras películas
        if (imagePath != null) {
          final querySnapshot = await FirebaseFirestore.instance
              .collection('movies')
              .where('image', isEqualTo: imagePath)
              .get();

          // Si no hay otras referencias a la imagen, eliminarla de la memoria del teléfono
          if (querySnapshot.docs.isEmpty) {
            final file = File(imagePath);
            if (await file.exists()) {
              await file.delete();
            }
          }
        }

        // Mostrar un mensaje de confirmación
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Movie deleted successfully')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return WillPopScope(
      onWillPop: () async => false, // Disable back button
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Movie Catalog',
            style: TextStyle(
                color: Colors.deepPurple,
                fontSize: 32,
                fontWeight: FontWeight.bold),
          ),
          automaticallyImplyLeading: false, // Elimina el botón de retroceso
        ),
        body: Column(
          children: [
            const Divider(color: Colors.deepPurple, thickness: 2),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('movies')
                    .where('userId',
                        isEqualTo:
                            user?.uid) // Filtra por el ID del usuario actual
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final movies = snapshot.data!.docs;
                  if (movies.isEmpty) {
                    return const Center(
                        child: Text('No movies have been added yet'));
                  }

                  return ListView.builder(
                    itemCount: movies.length,
                    itemBuilder: (context, index) {
                      final movie = movies[index];
                      return Container(
                        margin: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                movie['image'] != null &&
                                        movie['image'].isNotEmpty
                                    ? Container(
                                        constraints: BoxConstraints(
                                          maxHeight:
                                              170, // Altura máxima de 150 píxeles
                                        ),
                                        child: AspectRatio(
                                          aspectRatio: 3 /
                                            4, // Ajusta la proporción según sea necesario
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: Image.file(
                                              File(movie['image']),
                                              fit: BoxFit
                                                  .cover, // Mantiene la proporción sin hacer zoom in
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(
                                        width: 100,
                                        height: 100,
                                        color: Colors.grey,
                                        child:
                                            const Icon(Icons.movie, size: 50),
                                      ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        movie['title'],
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 80),
                                      Row(
                                        children: [
                                          ElevatedButton(
                                            onPressed: () =>
                                                _deleteMovie(movie.id),
                                            child: const Text('Delete'),
                                          ),
                                          const SizedBox(width: 8),
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      MovieDetailsScreen(
                                                          movie: movie),
                                                ),
                                              );
                                            },
                                            child: const Text('Details'),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Divider(
                                color: Colors.deepPurple, thickness: 2),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
      ),
    );
  }
}
