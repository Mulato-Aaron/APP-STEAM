import 'dart:async'; // Importar para usar StreamSubscription
import 'package:flutter/foundation.dart';
import 'package:proyecto_5_semestre/data/services/database_service.dart';
import 'package:proyecto_5_semestre/presentation/providers/auth_provider.dart';

class CatalogProvider with ChangeNotifier {
  final AuthProvider authProvider;
  final DatabaseService databaseService;
  
  List<String> _ownedGameIds = [];
  StreamSubscription? _librarySubscription; // Suscripción al stream de la biblioteca

  CatalogProvider({required this.authProvider, required this.databaseService}) {
    authProvider.addListener(_onAuthStateChanged);
    _onAuthStateChanged(); // Cargar datos iniciales
  }

  List<String> get ownedGameIds => _ownedGameIds;

  bool isGameOwned(String gameId) {
    return _ownedGameIds.contains(gameId);
  }

  void _onAuthStateChanged() {
    _librarySubscription?.cancel(); // Cancelar la suscripción anterior si existe

    if (authProvider.user != null) {
      // Escuchar el stream de la biblioteca en tiempo real
      _librarySubscription = databaseService.getOwnedGameIdsStream(authProvider.user!.uid).listen((gameIds) {
        _ownedGameIds = gameIds;
        notifyListeners(); // Notificar a los widgets que la lista cambió
      });
    } else {
      // Si el usuario cierra sesión, limpiar la lista y cancelar la suscripción
      _ownedGameIds = [];
      notifyListeners();
    }
  }

  @override
  void dispose() {
    authProvider.removeListener(_onAuthStateChanged);
    _librarySubscription?.cancel(); // Asegurarse de cancelar la suscripción al destruir el provider
    super.dispose();
  }
}
