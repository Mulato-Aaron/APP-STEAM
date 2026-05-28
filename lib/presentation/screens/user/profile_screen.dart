
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_5_semestre/presentation/providers/auth_provider.dart';
import 'package:proyecto_5_semestre/presentation/screens/user/order_history_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        backgroundColor: theme.colorScheme.primary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          if (user != null)
            ListTile(
              leading: const Icon(Icons.email, size: 30),
              title: const Text('Correo Electrónico', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(user.email ?? 'No disponible'),
            ),
          const Divider(height: 32),
          ListTile(
            leading: const Icon(Icons.history, color: Colors.blueAccent),
            title: const Text('Historial de Compras'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OrderHistoryScreen()),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: theme.colorScheme.error),
            title: const Text('Cerrar Sesión'),
            onTap: () async {
              // Mostrar diálogo de confirmación
              final confirm = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('¿Cerrar Sesión?'),
                  content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text(
                        'Sí, Cerrar Sesión',
                        style: TextStyle(color: theme.colorScheme.error),
                      ),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await authProvider.signOut();
                // No es necesario navegar, el stream builder en main se encargará
              }
            },
          ),
        ],
      ),
    );
  }
}
