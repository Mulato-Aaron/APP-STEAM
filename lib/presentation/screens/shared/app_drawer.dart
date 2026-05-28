import 'package:flutter/material.dart';
import 'package:proyecto_5_semestre/presentation/screens/admin/product_management_screen.dart';

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
              color: Colors.deepPurple,
            ),
            child: Text(
              'Menú de Opciones',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Gestión de Productos'),
            onTap: () {
              // Cierra el drawer primero
              Navigator.pop(context); 
              // Luego navega a la pantalla de gestión
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProductManagementScreen(),
                ),
              );
            },
          ),
          // Aquí podríamos añadir más opciones en el futuro
        ],
      ),
    );
  }
}
