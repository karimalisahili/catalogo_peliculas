//Pagina que permite insertar una pelicula en la base de datos.
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddMovieScreen extends StatefulWidget {
  const AddMovieScreen({super.key});

  @override
  _AddMovieScreenState createState() => _AddMovieScreenState();
}

class _AddMovieScreenState extends State<AddMovieScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _genreController = TextEditingController();
  final _yearController = TextEditingController();
  final _directorController = TextEditingController();
  final _synopsisController = TextEditingController();
  XFile? _image;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String? imagePath;
        if (_image != null) {
          final directory = await getApplicationDocumentsDirectory();
          final imageFile = File('${directory.path}/${_image!.name}');
          await imageFile.writeAsBytes(await _image!.readAsBytes());
          imagePath = imageFile.path;
        }

        await FirebaseFirestore.instance.collection('movies').add({
          'userId': user.uid,
          'title': _titleController.text,
          'genre': _genreController.text,
          'year': _yearController.text,
          'director': _directorController.text,
          'synopsis': _synopsisController.text,
          'image': imagePath,
        });

        // Mostrar SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Movie added successfully'),
            duration: Duration(seconds: 2),
          ),
        );

        // Limpiar los campos del formulario
        _titleController.clear();
        _genreController.clear();
        _yearController.clear();
        _directorController.clear();
        _synopsisController.clear();
        setState(() {
          _image = null;
        });

        // Aquí puedes manejar la navegación después de agregar la película
        // Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Movie'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: _image == null
                    ? Container(
                        height: 200,
                        color: Colors.grey[300],
                        child: const Icon(Icons.add_a_photo, size: 50),
                      )
                    : Image.file(File(_image!.path)),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _genreController,
                decoration: const InputDecoration(labelText: 'Genre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a genre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _yearController,
                decoration: const InputDecoration(labelText: 'Year'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a year';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _directorController,
                decoration: const InputDecoration(labelText: 'Director'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a director';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _synopsisController,
                decoration: const InputDecoration(labelText: 'Synopsis'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a synopsis';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Add Movie'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}