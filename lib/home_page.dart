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
  int _selectedIndex = 1; // Inicio en el índice 1 para que "Inicio" sea el predeterminado

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _deleteMovie(String movieId) async {
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
      await FirebaseFirestore.instance.collection('movies').doc(movieId).delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return WillPopScope(
      onWillPop: () async => false, // Deshabilita el botón de retroceso
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Movie Catalog'),
          automaticallyImplyLeading: false, // Elimina el botón de retroceso
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('movies')
              .where('userId', isEqualTo: user?.uid) // Filtra por el ID del usuario actual
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final movies = snapshot.data!.docs;

            return ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                return ListTile(
                  leading: movie['image'] != null && movie['image'].isNotEmpty
                      ? Image.file(File(movie['image']))
                      : Container(
                          width: 50,
                          height: 50,
                          color: Colors.grey,
                          child: const Icon(Icons.movie),
                        ),
                  title: Text(movie['title']),
                  subtitle: Row(
                    children: [
                      ElevatedButton(
                        onPressed: () => _deleteMovie(movie.id),
                        child: const Text('Delete'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MovieDetailsScreen(movie: movie),
                            ),
                          );
                        },
                        child: const Text('Details'),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
        bottomNavigationBar: BottomNavBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
      ),
    );
  }
}