import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_5_semestre/models/game.dart';
import 'package:proyecto_5_semestre/presentation/providers/cart_provider.dart';
import 'package:proyecto_5_semestre/presentation/providers/catalog_provider.dart'; // Importar CatalogProvider
import 'package:proyecto_5_semestre/presentation/screens/user/library_screen.dart'; // Importar LibraryScreen

class GameDetailScreen extends StatelessWidget {
  final Game game;

  const GameDetailScreen({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(game.title),
        backgroundColor: theme.colorScheme.primary,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            game.imageUrl.isNotEmpty
                ? Image.network(
                    game.imageUrl,
                    fit: BoxFit.cover,
                    height: 300,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 300,
                        color: Colors.grey[800],
                        child: const Center(
                          child: Icon(Icons.broken_image, size: 100, color: Colors.grey),
                        ),
                      );
                    },
                  )
                : Container(
                    height: 300,
                    color: Colors.grey[800],
                    child: const Icon(Icons.videogame_asset_off, size: 100, color: Colors.grey),
                  ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    game.title,
                    style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${game.price.toStringAsFixed(2)}',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: theme.colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    game.description,
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  // Lógica condicional del botón con Consumer
                  Consumer<CatalogProvider>(
                    builder: (context, catalog, child) {
                      // Es crucial manejar el caso de que el id sea null
                      final isOwned = game.id != null ? catalog.isGameOwned(game.id!) : false;

                      if (isOwned) {
                        // Botón para ir a la biblioteca si ya se posee el juego
                        return SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.library_books),
                            label: const Text('Ver en la Biblioteca'),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const LibraryScreen()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              backgroundColor: Colors.grey[700], // Un color distintivo
                            ),
                          ),
                        );
                      } else {
                        // Botón para añadir al carrito si no se posee
                        return SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.shopping_cart_checkout),
                            label: const Text('Añadir al Carrito'),
                            onPressed: () {
                              context.read<CartProvider>().addItem(game);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${game.title} añadido al carrito.'),
                                  duration: const Duration(seconds: 2),
                                  backgroundColor: theme.colorScheme.secondary,
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
