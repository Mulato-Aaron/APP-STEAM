import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as developer;
import 'data/services/database_service.dart';
import 'firebase_options.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/cart_provider.dart';
import 'core/theme/app_theme.dart';
import 'presentation/screens/shared/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final dbService = DatabaseService();

  // Intentamos añadir el producto de ejemplo, pero de forma segura.
  // Si esto falla (ej. sin conexión), la app no se bloqueará.
  try {
    developer.log('Intentando añadir producto de ejemplo si es necesario...', name: 'main.startup');
    await dbService.addSampleProduct();
    developer.log('Operación de producto de ejemplo completada.', name: 'main.startup');
  } catch (e, s) {
    developer.log(
      'No se pudo añadir el producto de ejemplo. Esto es seguro y la app continuará.',
      name: 'main.startup',
      error: e,
      stackTrace: s,
    );
  }

  runApp(MyApp(dbService: dbService));
}

class MyApp extends StatelessWidget {
  final DatabaseService dbService;

  const MyApp({super.key, required this.dbService});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        Provider<DatabaseService>(create: (_) => dbService),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        title: 'Proyecto 5',
        theme: AppTheme.darkTheme,
        debugShowCheckedModeBanner: false, // He quitado la banda de "DEBUG"
        home: const SplashScreen(),
      ),
    );
  }
}
