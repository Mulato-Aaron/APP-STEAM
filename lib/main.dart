import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_5_semestre/data/services/database_service.dart';
import 'package:proyecto_5_semestre/firebase_options.dart';
import 'package:proyecto_5_semestre/presentation/providers/auth_provider.dart';
import 'package:proyecto_5_semestre/presentation/providers/cart_provider.dart';
import 'package:proyecto_5_semestre/presentation/providers/catalog_provider.dart'; // Importar el nuevo provider
import 'package:proyecto_5_semestre/core/theme/app_theme.dart';
import 'package:proyecto_5_semestre/presentation/screens/admin/admin_dashboard_screen.dart';
import 'package:proyecto_5_semestre/presentation/screens/auth/login_screen.dart';
import 'package:proyecto_5_semestre/presentation/screens/shared/auth_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Proveedor de autenticación
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        // Proveedor de servicio de base de datos (no cambia)
        Provider<DatabaseService>(create: (_) => DatabaseService()),
        // Proveedor del carrito de compras
        ChangeNotifierProvider(create: (_) => CartProvider()),
        // Nuevo ProxyProvider para el catálogo
        ChangeNotifierProxyProvider<AuthProvider, CatalogProvider>(
          create: (context) => CatalogProvider(
            authProvider: Provider.of<AuthProvider>(context, listen: false),
            databaseService: Provider.of<DatabaseService>(context, listen: false),
          ),
          update: (context, auth, previousCatalog) => CatalogProvider(
            authProvider: auth,
            databaseService: Provider.of<DatabaseService>(context, listen: false),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Tienda de Juegos',
        theme: AppTheme.darkTheme,
        debugShowCheckedModeBanner: false,
        home: const AuthWrapper(),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/admin': (context) => const AdminDashboardScreen(),
        },
      ),
    );
  }
}
