
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_5_semestre/presentation/providers/auth_provider.dart';
import 'package:proyecto_5_semestre/presentation/screens/admin/admin_dashboard_screen.dart';
import 'package:proyecto_5_semestre/presentation/screens/cart/cart_screen.dart';
import 'package:proyecto_5_semestre/presentation/screens/home/home_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userEmail = authProvider.user?.email ?? 'no-email@example.com'; // Corregido

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: null, // Puedes añadir un nombre si lo tienes
            accountEmail: Text(userEmail),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Colors.deepPurple),
            ),
            decoration: const BoxDecoration(
              color: Colors.deepPurple,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Inicio'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text('Carrito'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
          ),
          const Divider(),
          // Usamos Consumer para reconstruir solo este ListTile si el estado de admin cambia
          Consumer<AuthProvider>(
            builder: (context, auth, child) {
              if (auth.isAdmin) {
                return ListTile(
                  leading: const Icon(Icons.admin_panel_settings),
                  title: const Text('Panel de Administración'),
                  onTap: () {
                    Navigator.of(context).pop(); // Cierra el drawer
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const AdminDashboardScreen(),
                      ),
                    );
                  },
                );
              }
              return const SizedBox.shrink(); // No muestra nada si no es admin
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Cerrar Sesión'),
            onTap: () {
              Navigator.of(context).pop();
              authProvider.signOut();
            },
          ),
        ],
      ),
    );
  }
}
