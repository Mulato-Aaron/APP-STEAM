
import 'package:flutter/material.dart';
import 'package:proyecto_5_semestre/presentation/screens/admin/product_management_screen.dart';
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
  ];

  static const List<String> _screenTitles = <String>[
    'Gestión de Productos',
    'Gestión de Usuarios',
    'Gestión de Órdenes',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context); // Cierra el drawer
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
          ],
        ),
      ),
      body: _managementScreens[_selectedIndex],
    );
  }
}
