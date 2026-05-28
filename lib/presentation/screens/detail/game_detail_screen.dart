import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_5_semestre/models/game.dart';
import 'package:proyecto_5_semestre/presentation/providers/cart_provider.dart';
import 'package:proyecto_5_semestre/presentation/providers/catalog_provider.dart';
import 'package:proyecto_5_semestre/presentation/screens/cart/cart_screen.dart'; // Asegúrate de importar CartScreen
import 'package:proyecto_5_semestre/presentation/screens/user/library_screen.dart';

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
                  // Lógica del botón con ambos providers
                  Consumer<CatalogProvider>(
                    builder: (context, catalog, child) {
                      final isOwned = game.id != null ? catalog.isGameOwned(game.id!) : false;

                      if (isOwned) {
                        // 1. Si el juego es del usuario -> Botón a la biblioteca
                        return _buildLibraryButton(context);
                      } else {
                        // 2. Si no es del usuario, revisamos el carrito
                        return Consumer<CartProvider>(
                          builder: (context, cart, child) {
                            final isInCart = game.id != null ? cart.isInCart(game.id!) : false;

                            if (isInCart) {
                              // 2.1. Si está en el carrito -> Botón al carrito
                              return _buildCartButton(context);
                            } else {
                              // 2.2. Si no está en el carrito -> Botón para añadir
                              return _buildAddToCartButton(context, cart);
                            }
                          },
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

  // Widget para el botón "Ver en la Biblioteca"
  Widget _buildLibraryButton(BuildContext context) {
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
          backgroundColor: Colors.grey[700],
        ),
      ),
    );
  }

  // Widget para el botón "Ver mi Carrito"
  Widget _buildCartButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.shopping_cart),
        label: const Text('Ver mi Carrito'),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CartScreen()),
          );
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          backgroundColor: Theme.of(context).colorScheme.secondary, // Un color que indique acción
        ),
      ),
    );
  }

  // Widget para el botón "Añadir al Carrito"
  Widget _buildAddToCartButton(BuildContext context, CartProvider cart) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.shopping_cart_checkout),
        label: const Text('Añadir al Carrito'),
        onPressed: () {
          cart.addItem(game);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${game.title} añadido al carrito.'),
              duration: const Duration(seconds: 2),
              backgroundColor: Theme.of(context).colorScheme.secondary,
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
}
