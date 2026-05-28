import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/auth_status.dart';
import '../home/home_screen.dart'; // RUTA CORREGIDA
import '../auth/login_screen.dart';
import '../admin/admin_screen.dart';

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
          return const AdminScreen();
        } else {
          return const HomeScreen(); // AHORA SE RECONOCE HomeScreen
        }
    }
  }
}
