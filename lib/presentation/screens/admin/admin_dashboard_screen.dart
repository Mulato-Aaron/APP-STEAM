import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_5_semestre/presentation/providers/auth_provider.dart';
import 'package:proyecto_5_semestre/presentation/screens/admin/developer_management_screen.dart';
import 'package:proyecto_5_semestre/presentation/screens/admin/product_management_screen.dart';
import 'package:proyecto_5_semestre/presentation/screens/admin/publisher_management_screen.dart';
import 'package:proyecto_5_semestre/presentation/screens/admin/user_management_screen.dart';
import 'package:proyecto_5_semestre/presentation/screens/admin/order_management_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _managementScreens = <Widget>[
    ProductManagementScreen(),
    UserManagementScreen(),
    OrderManagementScreen(),
    DeveloperManagementScreen(),
    PublisherManagementScreen(),
  ];

  static const List<String> _screenTitles = <String>[
    'Gestión de Productos',
    'Gestión de Usuarios',
    'Gestión de Órdenes',
    'Gestión de Desarrolladores',
    'Gestión de Editores',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context); // Cierra el drawer
  }

  void _signOut() {
    Provider.of<AuthProvider>(context, listen: false).signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_screenTitles[_selectedIndex]),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurple,
              ),
              child: Text(
                'Panel de Administración',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.games),
              title: const Text('Productos'),
              onTap: () => _onItemTapped(0),
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Usuarios'),
              onTap: () => _onItemTapped(1),
            ),
            ListTile(
              leading: const Icon(Icons.receipt),
              title: const Text('Órdenes'),
              onTap: () => _onItemTapped(2),
            ),
            ListTile(
              leading: const Icon(Icons.developer_mode),
              title: const Text('Desarrolladores'),
              onTap: () => _onItemTapped(3),
            ),
            ListTile(
              leading: const Icon(Icons.publish),
              title: const Text('Editores'),
              onTap: () => _onItemTapped(4),
            ),
            const Divider(), // Separador visual
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Cerrar Sesión'),
              onTap: _signOut, // Llama al método para cerrar sesión
            ),
          ],
        ),
      ),
      body: _managementScreens[_selectedIndex],
    );
  }
}
