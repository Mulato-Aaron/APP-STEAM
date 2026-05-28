import 'package:flutter/material.dart';
import 'package:proyecto_5_semestre/presentation/screens/admin/product_management_screen.dart';

// Placeholder para las futuras pantallas
class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Gestión de Usuarios - Próximamente'));
  }
}

class OrderManagementScreen extends StatelessWidget {
  const OrderManagementScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Gestión de Órdenes - Próximamente'));
  }
}


class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Productos, Usuarios, Órdenes
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Panel de Administración'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.games), text: 'Productos'),
              Tab(icon: Icon(Icons.people), text: 'Usuarios'),
              Tab(icon: Icon(Icons.receipt), text: 'Órdenes'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ProductManagementScreen(), // La pantalla que ya teníamos
            UserManagementScreen(),      // Placeholder
            OrderManagementScreen(),     // Placeholder
          ],
        ),
      ),
    );
  }
}
