import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../domain/models/product_model.dart';
import '../../../presentation/providers/auth_provider.dart';
import '../../../presentation/providers/cart_provider.dart';
import '../../../data/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../cart/cart_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final databaseService = Provider.of<DatabaseService>(context);
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tienda'),
        actions: [
          Consumer<CartProvider>(
            builder: (_, cart, ch) => Badge(
              label: Text(cart.itemCount.toString()),
              child: ch,
            ),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const CartScreen(),
                  ),
                );
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authProvider.signOut();
            },
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: databaseService.getProductsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Algo salió mal'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final products = snapshot.data!.docs
              .map((doc) => Product.fromFirestore(doc))
              .toList();

          return GridView.builder(
            padding: const EdgeInsets.all(10.0),
            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (ctx, i) => GridTile(
              footer: GridTileBar(
                backgroundColor: Colors.black87,
                title: Text(
                  products[i].name,
                  textAlign: TextAlign.center,
                ),
                subtitle: const Text(
                  '\${products[i].price.toStringAsFixed(2)}',
                  textAlign: TextAlign.center,
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.add_shopping_cart),
                  onPressed: () {
                    cartProvider.addItem(products[i]);
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Añadido al carrito!'),
                        duration: const Duration(seconds: 2),
                        action: SnackBarAction(
                          label: 'DESHACER',
                          onPressed: () {
                            cartProvider.removeSingleItem(products[i].id);
                          },
                        ),
                      ),
                    );
                  },
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              child: Image.network(
                products[i].imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}
