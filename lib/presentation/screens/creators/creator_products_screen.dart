import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proyecto_5_semestre/models/game.dart';
import 'package:proyecto_5_semestre/presentation/screens/detail/game_detail_screen.dart';

class CreatorProductsScreen extends StatefulWidget {
  final String creatorId;
  final String creatorType; // 'developer' or 'publisher'

  const CreatorProductsScreen({
    super.key,
    required this.creatorId,
    required this.creatorType,
  });

  @override
  State<CreatorProductsScreen> createState() => _CreatorProductsScreenState();
}

class _CreatorProductsScreenState extends State<CreatorProductsScreen> {
  late Future<DocumentSnapshot> _creatorFuture;
  late Future<List<Game>> _productsFuture;

  @override
  void initState() {
    super.initState();
    final creatorCollection = widget.creatorType == 'developer' ? 'developers' : 'publishers';
    _creatorFuture = FirebaseFirestore.instance.collection(creatorCollection).doc(widget.creatorId).get();
    _productsFuture = _fetchProductsByCreator();
  }

  Future<List<Game>> _fetchProductsByCreator() async {
    final fieldToQuery = widget.creatorType == 'developer' ? 'developerId' : 'publisherId';
    final querySnapshot = await FirebaseFirestore.instance
        .collection('games')
        .where(fieldToQuery, isEqualTo: widget.creatorId)
        .get();

    if (querySnapshot.docs.isEmpty) {
      return [];
    }
    // Corregido: Se elimina Future.wait y se mapea directamente.
    return querySnapshot.docs.map((doc) => Game.fromFirestore(doc)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        future: _creatorFuture,
        builder: (context, creatorSnapshot) {
          if (creatorSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!creatorSnapshot.hasData || !creatorSnapshot.data!.exists) {
            return const Center(child: Text('Creador no encontrado.'));
          }

          final creatorData = creatorSnapshot.data!.data() as Map<String, dynamic>;
          final creatorName = creatorData['name'] ?? 'Nombre no disponible';
          final creatorImageUrl = creatorData['imageUrl'];

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 140.0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (creatorImageUrl != null)
                        CircleAvatar(
                          backgroundImage: NetworkImage(creatorImageUrl),
                          radius: 15,
                        ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          creatorName,
                          style: const TextStyle(fontSize: 16, color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  background: creatorImageUrl != null
                      ? Image.network(
                          creatorImageUrl,
                          fit: BoxFit.cover,
                          color: Colors.black.withAlpha(128),
                          colorBlendMode: BlendMode.darken,
                        )
                      : Container(color: Colors.grey),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Juegos de $creatorName',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              _buildProductsGrid(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProductsGrid() {
    final theme = Theme.of(context);
    return FutureBuilder<List<Game>>(
      future: _productsFuture,
      builder: (context, productsSnapshot) {
        if (productsSnapshot.connectionState == ConnectionState.waiting) {
          return const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (!productsSnapshot.hasData || productsSnapshot.data!.isEmpty) {
          return const SliverFillRemaining(
            child: Center(child: Text('No se encontraron juegos de este creador.')),
          );
        }

        final products = productsSnapshot.data!;
        return SliverPadding(
          padding: const EdgeInsets.all(10.0),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200.0,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              childAspectRatio: 0.7,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                final product = products[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GameDetailScreen(game: product),
                      ),
                    );
                  },
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    elevation: 4.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: product.imageUrl.isNotEmpty
                              ? Image.network(
                                  product.imageUrl,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                )
                              : const Center(child: Icon(Icons.videogame_asset_off, size: 50)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.title,
                                style: theme.textTheme.titleMedium,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '\$${product.price.toStringAsFixed(2)}',
                                style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.secondary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              childCount: products.length,
            ),
          ),
        );
      },
    );
  }
}
