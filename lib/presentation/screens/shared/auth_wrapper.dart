import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../presentation/providers/auth_provider.dart';
import '../auth/login_screen.dart';
import '../home/home_screen.dart';
import '../auth/register_screen.dart';


class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    // Usamos el estado isLogin para decidir qué pantalla de autenticación mostrar
    if (authProvider.currentUser == null) {
      return authProvider.isLogin ? const LoginScreen() : const RegisterScreen();
    } else {
      // Si el usuario está autenticado, mostramos la pantalla principal
      return const HomeScreen();
    }
  }
}
