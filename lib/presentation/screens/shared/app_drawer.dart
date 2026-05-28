import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_5_semestre/presentation/providers/auth_provider.dart';
import 'package:proyecto_5_semestre/presentation/screens/admin/admin_dashboard_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Menú',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          // Usamos Consumer para reconstruir solo este ListTile si el estado de admin cambia
          Consumer<AuthProvider>(
            builder: (context, auth, child) {
              if (auth.isAdmin) {
                return ListTile(
                  leading: const Icon(Icons.settings),
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
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Cerrar Sesión'),
            onTap: () {
              // 1. Cierra el drawer
              Navigator.of(context).pop();
              
              // 2. Llama a signOut. El AuthWrapper se encargará de la navegación.
              authProvider.signOut();
            },
          ),
        ],
      ),
    );
  }
}
