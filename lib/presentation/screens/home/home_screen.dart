
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_5_semestre/data/services/database_service.dart';
import 'package:proyecto_5_semestre/models/game.dart';
import 'package:proyecto_5_semestre/presentation/providers/cart_provider.dart';
import 'package:proyecto_5_semestre/presentation/screens/cart/cart_screen.dart';
import 'package:proyecto_5_semestre/presentation/screens/detail/game_detail_screen.dart';
import 'package:proyecto_5_semestre/presentation/screens/shared/app_drawer.dart';
import 'package:proyecto_5_semestre/presentation/screens/user/library_screen.dart';
import 'package:proyecto_5_semestre/presentation/screens/user/profile_screen.dart'; // Importar ProfileScreen

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Añadir ProfileScreen a la lista de widgets
  static const List<Widget> _widgetOptions = <Widget>[
    GameStore(), // Cambiado de GameGrid a GameStore
    LibraryScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Mapeo de índices a títulos
  static const List<String> _appBarTitles = [
    'Tienda de Juegos',
    'Mi Biblioteca',
    'Mi Perfil',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitles[_selectedIndex]), // Título dinámico
        actions: [
          IconButton(
            icon: const Icon(Icons.cleaning_services),
            tooltip: 'Limpiar Carrito Cache',
            onPressed: () {
              Provider.of<CartProvider>(context, listen: false).clearCart();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Caché del carrito limpiada.')),
              );
            },
          ),
          Consumer<CartProvider>(
            builder: (_, cart, ch) => Badge(
              label: Text(cart.itemCount.toString()),
              child: ch,
            ),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const CartScreen()),
                );
              },
            ),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'Tienda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Mi Biblioteca',
          ),
          // Nuevo ítem para el perfil
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Mi Perfil',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}

class GameStore extends StatefulWidget {
  const GameStore({super.key});

  @override
  GameStoreState createState() => GameStoreState();
}

class GameStoreState extends State<GameStore> {
  String _searchTerm = '';
  String _priceFilter = 'none';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              labelText: 'Buscar juegos...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
            ),
            onChanged: (value) {
              setState(() {
                _searchTerm = value;
              });
            },
          ),
        ),
        Wrap(
          spacing: 8.0,
          children: <Widget>[
            ChoiceChip(
              label: const Text('Precio: Más barato'),
              selected: _priceFilter == 'asc',
              onSelected: (selected) {
                setState(() {
                  _priceFilter = selected ? 'asc' : 'none';
                });
              },
            ),
            ChoiceChip(
              label: const Text('Precio: Más caro'),
              selected: _priceFilter == 'desc',
              onSelected: (selected) {
                setState(() {
                  _priceFilter = selected ? 'desc' : 'none';
                });
              },
            ),
          ],
        ),
        Expanded(
          child: GameGrid(searchTerm: _searchTerm, priceFilter: _priceFilter),
        ),
      ],
    );
  }
}

class GameGrid extends StatelessWidget {
  final String searchTerm;
  final String priceFilter;

  const GameGrid({super.key, required this.searchTerm, required this.priceFilter});

  @override
  Widget build(BuildContext context) {
    final dbService = Provider.of<DatabaseService>(context, listen: false);
    return StreamBuilder<List<Game>>(
      stream: dbService.getGames(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No hay juegos disponibles.'));
        }

        var games = snapshot.data!;
        
        // Lógica de filtrado
        if (searchTerm.isNotEmpty) {
          games = games.where((game) => game.title.toLowerCase().contains(searchTerm.toLowerCase())).toList();
        }

        // Lógica de ordenación
        if (priceFilter != 'none') {
          games.sort((a, b) {
            if (priceFilter == 'asc') {
              return a.price.compareTo(b.price);
            } else {
              return b.price.compareTo(a.price);
            }
          });
        }


        return LayoutBuilder(
          builder: (context, constraints) {
            const double breakpoint = 600.0;
            final bool isWide = constraints.maxWidth > breakpoint;

            final int crossAxisCount = isWide ? 4 : 2;
            final double childAspectRatio = isWide ? 0.6 : 2 / 3;

            return GridView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: games.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: childAspectRatio,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (ctx, i) => GameCard(game: games[i]),
            );
          },
        );
      },
    );
  }
}

class GameCard extends StatelessWidget {
  final Game game;

  const GameCard({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => GameDetailScreen(game: game),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Hero(
                tag: 'gameImage-${game.id}',
                child: Image.network(
                  game.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                game.title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Text(
                '\$${game.price.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 14, color: Colors.grey[400]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
