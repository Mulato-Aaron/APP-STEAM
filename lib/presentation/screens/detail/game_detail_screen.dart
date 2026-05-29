import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_5_semestre/data/services/database_service.dart';
import 'package:proyecto_5_semestre/models/developer.dart';
import 'package:proyecto_5_semestre/models/game.dart';
import 'package:proyecto_5_semestre/models/publisher.dart';
import 'package:proyecto_5_semestre/presentation/providers/cart_provider.dart';
import 'package:proyecto_5_semestre/presentation/providers/catalog_provider.dart';
import 'package:proyecto_5_semestre/presentation/screens/cart/cart_screen.dart';
import 'package:proyecto_5_semestre/presentation/screens/user/library_screen.dart';

class GameDetailScreen extends StatelessWidget {
  final Game game;
  final DatabaseService _databaseService = DatabaseService();

  GameDetailScreen({super.key, required this.game});

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
                          child: Icon(Icons.broken_image,
                              size: 100, color: Colors.grey),
                        ),
                      );
                    },
                  )
                : Container(
                    height: 300,
                    color: Colors.grey[800],
                    child: const Icon(Icons.videogame_asset_off,
                        size: 100, color: Colors.grey),
                  ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    game.title,
                    style: theme.textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
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
                  _buildInfoSection(context, theme),
                  const SizedBox(height: 16),
                  Text(
                    game.description,
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  Consumer<CatalogProvider>(
                    builder: (context, catalog, child) {
                      final isOwned = game.id != null
                          ? catalog.isGameOwned(game.id!)
                          : false;

                      if (isOwned) {
                        return _buildLibraryButton(context);
                      } else {
                        return Consumer<CartProvider>(
                          builder: (context, cart, child) {
                            final isInCart = game.id != null
                                ? cart.isInCart(game.id!)
                                : false;

                            if (isInCart) {
                              return _buildCartButton(context);
                            } else {
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

  Widget _buildInfoSection(BuildContext context, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow<Developer>(
          label: 'Desarrollador',
          future: _databaseService.getDeveloperById(game.developerId),
          builder: (data) => Text(data.name, style: theme.textTheme.bodyLarge),
        ),
        const SizedBox(height: 8),
        _buildInfoRow<Publisher>(
          label: 'Editor',
          future: _databaseService.getPublisherById(game.publisherId),
          builder: (data) => Text(data.name, style: theme.textTheme.bodyLarge),
        ),
      ],
    );
  }

  Widget _buildInfoRow<T>({
    required String label,
    required Future<T> future,
    required Widget Function(T data) builder,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('$label:', style: const TextStyle(fontWeight: FontWeight.bold)),
        FutureBuilder<T>(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              );
            }
            if (snapshot.hasError || !snapshot.hasData) {
              return const Text('No disponible');
            }
            return builder(snapshot.data as T);
          },
        ),
      ],
    );
  }

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
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }

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
