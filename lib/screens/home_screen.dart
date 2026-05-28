import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game.dart';
import '../providers/game_provider.dart';
import '../services/auth_service.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showGameDialog(BuildContext context, {Game? game}) {
    final nameController = TextEditingController(text: game?.name);
    final genreController = TextEditingController(text: game?.genre);
    final priceController = TextEditingController(text: game?.price.toString());
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(game == null ? 'Add Game' : 'Edit Game'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a name' : null,
              ),
              TextFormField(
                controller: genreController,
                decoration: const InputDecoration(labelText: 'Genre'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a genre' : null,
              ),
              TextFormField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty || double.tryParse(value) == null
                        ? 'Please enter a valid price'
                        : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final gameProvider =
                    Provider.of<GameProvider>(context, listen: false);
                final newGame = Game(
                  id: game?.id,
                  name: nameController.text,
                  genre: genreController.text,
                  price: double.parse(priceController.text),
                );
                if (game == null) {
                  gameProvider.addGame(newGame);
                } else {
                  gameProvider.updateGame(newGame);
                }
                Navigator.of(context).pop();
              }
            },
            child: Text(game == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Steam Games'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () =>
                Provider.of<AuthService>(context, listen: false).signOut(),
          ),
        ],
      ),
      body: StreamBuilder<List<Game>>(
        stream: gameProvider.games,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final games = snapshot.data ?? [];

          if (games.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'No games found. Add a new game using the + button below!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: games.length,
            itemBuilder: (context, index) {
              final game = games[index];
              return Slidable(
                startActionPane: ActionPane(
                  motion: const DrawerMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (_) => _showGameDialog(context, game: game),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      icon: Icons.edit,
                      label: 'Edit',
                    ),
                  ],
                ),
                endActionPane: ActionPane(
                  motion: const DrawerMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (_) => gameProvider.deleteGame(game.id!),
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                  ],
                ),
                child: Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(game.name,
                        style: Theme.of(context).textTheme.titleLarge),
                    subtitle: Text(game.genre,
                        style: Theme.of(context).textTheme.bodyMedium),
                    trailing: Text('\$${game.price.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleMedium),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showGameDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
