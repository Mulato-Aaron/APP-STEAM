
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_5_semestre/data/services/database_service.dart';
import 'package:proyecto_5_semestre/models/game.dart';
import 'package:proyecto_5_semestre/presentation/providers/auth_provider.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Biblioteca Digital'),
        backgroundColor: Colors.deepPurple,
      ),
      body: user == null
          ? const Center(child: Text('Inicia sesión para ver tu biblioteca.'))
          : StreamBuilder<List<Game>>(
              stream: DatabaseService().getUserLibrary(user.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.gamepad_outlined, size: 80, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'Tu biblioteca está vacía',
                          style: TextStyle(fontSize: 22, color: Colors.grey),
                        ),
                        Text(
                          'Los juegos que compres aparecerán aquí.',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                final libraryGames = snapshot.data!;

                return ListView.builder(
                  itemCount: libraryGames.length,
                  itemBuilder: (context, index) {
                    final game = libraryGames[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(game.imageUrl),
                        ),
                        title: Text(game.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Comprado el: ${game.releaseDate}'), // Placeholder
                        trailing: ElevatedButton(
                          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Accediendo a ${game.title}...')),
                          ),
                          child: const Text('Jugar'),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
