
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_5_semestre/models/game.dart';
import 'package:proyecto_5_semestre/presentation/providers/cart_provider.dart';

class GameDetailScreen extends StatelessWidget {
  final Game game;

  const GameDetailScreen({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(game.title),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
              tag: 'gameImage-${game.id}', // Etiqueta Hero correspondiente
              child: Image.network(
                game.imageUrl,
                fit: BoxFit.cover,
                height: 300,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    game.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${game.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 22,
                      color: Colors.amber,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  Text(
                    'Género: ${game.genre}',
                    style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Lanzamiento: ${game.releaseDate}',
                     style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 16),
                   const Divider(),
                  const SizedBox(height: 16),
                  const Text(
                    'Descripción',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    game.description,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          cart.addItem(game);
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${game.title} añadido al carrito!'),
              duration: const Duration(seconds: 2),
            ),
          );
        },
        label: const Text('Añadir al Carrito'),
        icon: const Icon(Icons.shopping_cart_checkout),
        backgroundColor: Colors.amber[800],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
