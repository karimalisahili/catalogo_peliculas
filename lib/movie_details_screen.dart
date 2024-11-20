//permite ver los detalles de una pelicula.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MovieDetailsScreen extends StatelessWidget {
  final QueryDocumentSnapshot movie;

  const MovieDetailsScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie['title']),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            movie['image'] != null && movie['image'].isNotEmpty
                ? Image.file(File(movie['image']))
                : Container(
                    width: double.infinity,
                    height: 200,
                    color: Colors.grey,
                    child: const Icon(Icons.movie, size: 100),
                  ),
            const SizedBox(height: 16),
            Text('Title: ${movie['title']}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Genre: ${movie['genre']}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Year: ${movie['year']}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Director: ${movie['director']}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Synopsis: ${movie['synopsis']}', style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}