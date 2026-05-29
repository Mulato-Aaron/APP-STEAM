import 'package:flutter/material.dart';
import 'package:proyecto_5_semestre/data/services/database_service.dart';
import 'package:proyecto_5_semestre/models/developer.dart';

class DeveloperManagementScreen extends StatefulWidget {
  const DeveloperManagementScreen({super.key});

  @override
  State<DeveloperManagementScreen> createState() => _DeveloperManagementScreenState();
}

class _DeveloperManagementScreenState extends State<DeveloperManagementScreen> {
  final DatabaseService _dbService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Developer>>(
        stream: _dbService.getDevelopers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay desarrolladores.'));
          }
          final developers = snapshot.data!;
          return ListView.builder(
            itemCount: developers.length,
            itemBuilder: (context, index) {
              final developer = developers[index];
              return ListTile(
                title: Text(developer.name),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showDeveloperDialog(developer: developer),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        if (developer.id != null) {
                          _dbService.deleteDeveloper(developer.id!);
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
        onPressed: () => _showDeveloperDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDeveloperDialog({Developer? developer}) {
    final nameController = TextEditingController(text: developer?.name ?? '');
    final imageUrlController = TextEditingController(text: developer?.imageUrl ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(developer == null ? 'Añadir Desarrollador' : 'Editar Desarrollador'),
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
                  if (developer == null) {
                    final newDeveloper = Developer(
                      name: nameController.text,
                      imageUrl: imageUrlController.text,
                      gameIds: [],
                    );
                    _dbService.addDeveloper(newDeveloper);
                  } else {
                    final updatedDeveloper = Developer(
                      id: developer.id,
                      name: nameController.text,
                      imageUrl: imageUrlController.text,
                      gameIds: developer.gameIds,
                    );
                    _dbService.updateDeveloper(updatedDeveloper);
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
