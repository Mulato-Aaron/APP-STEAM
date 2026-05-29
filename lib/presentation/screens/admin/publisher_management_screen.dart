import 'package:flutter/material.dart';
import 'package:proyecto_5_semestre/data/services/database_service.dart';
import 'package:proyecto_5_semestre/models/publisher.dart';

class PublisherManagementScreen extends StatefulWidget {
  const PublisherManagementScreen({super.key});

  @override
  State<PublisherManagementScreen> createState() => _PublisherManagementScreenState();
}

class _PublisherManagementScreenState extends State<PublisherManagementScreen> {
  final DatabaseService _dbService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Publisher>>(
        stream: _dbService.getPublishers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay editores.'));
          }
          final publishers = snapshot.data!;
          return ListView.builder(
            itemCount: publishers.length,
            itemBuilder: (context, index) {
              final publisher = publishers[index];
              return ListTile(
                title: Text(publisher.name),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showPublisherDialog(publisher: publisher),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        if (publisher.id != null) {
                          _dbService.deletePublisher(publisher.id!);
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showPublisherDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showPublisherDialog({Publisher? publisher}) {
    final nameController = TextEditingController(text: publisher?.name ?? '');
    final imageUrlController = TextEditingController(text: publisher?.imageUrl ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(publisher == null ? 'Añadir Editor' : 'Editar Editor'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: imageUrlController,
                decoration: const InputDecoration(labelText: 'URL de la Imagen'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  if (publisher == null) {
                    final newPublisher = Publisher(
                      name: nameController.text,
                      imageUrl: imageUrlController.text,
                      gameIds: [],
                    );
                    _dbService.addPublisher(newPublisher);
                  } else {
                    final updatedPublisher = Publisher(
                      id: publisher.id,
                      name: nameController.text,
                      imageUrl: imageUrlController.text,
                      gameIds: publisher.gameIds,
                    );
                    _dbService.updatePublisher(updatedPublisher);
                  }
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }
}
