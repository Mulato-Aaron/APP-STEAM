import 'package:flutter/material.dart';
import 'package:proyecto_5_semestre/presentation/screens/admin/admin_dashboard_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
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
          ListTile(
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
          ),
        ],
      ),
    );
  }
}
