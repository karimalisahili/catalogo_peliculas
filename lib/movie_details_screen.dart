import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MovieDetailsScreen extends StatelessWidget {
  final QueryDocumentSnapshot movie;

  MovieDetailsScreen({required this.movie});

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
                    child: Icon(Icons.movie, size: 100),
                  ),
            SizedBox(height: 16),
            Text('Título: ${movie['title']}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Género: ${movie['genre']}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Año: ${movie['year']}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Director: ${movie['director']}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Sinopsis: ${movie['synopsis']}', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}