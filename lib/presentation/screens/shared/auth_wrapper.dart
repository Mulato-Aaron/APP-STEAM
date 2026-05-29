import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_5_semestre/presentation/providers/auth_provider.dart';
import 'package:proyecto_5_semestre/presentation/providers/auth_status.dart';
import 'package:proyecto_5_semestre/presentation/screens/admin/admin_dashboard_screen.dart';
import 'package:proyecto_5_semestre/presentation/screens/home/home_screen.dart';
import 'package:proyecto_5_semestre/presentation/screens/auth/login_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    switch (authProvider.status) {
      case AuthStatus.uninitialized:
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      case AuthStatus.unauthenticated:
        return const LoginScreen();
      case AuthStatus.authenticated:
        if (authProvider.isAdmin) {
          // Redirige al panel de administración
          return const AdminDashboardScreen();
        } else {
          // Redirige a la pantalla de inicio para clientes
          return const HomeScreen();
        }
    }
  }
}
