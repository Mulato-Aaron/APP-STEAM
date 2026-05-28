import 'package:flutter/foundation.dart';
import 'package:proyecto_5_semestre/data/services/database_service.dart';
import 'package:proyecto_5_semestre/presentation/providers/auth_provider.dart';

class CatalogProvider with ChangeNotifier {
  final AuthProvider authProvider;
  final DatabaseService databaseService;
  
  List<String> _ownedGameIds = [];

  CatalogProvider({required this.authProvider, required this.databaseService}) {
    // Escuchar cambios en el estado de autenticación para actualizar el catálogo del usuario
    authProvider.addListener(_onAuthStateChanged);
    // Cargar datos iniciales si ya hay un usuario logueado
    _onAuthStateChanged();
  }

  List<String> get ownedGameIds => _ownedGameIds;

  // Método para comprobar si un juego específico pertenece al usuario
  bool isGameOwned(String gameId) {
    return _ownedGameIds.contains(gameId);
  }

  // Callback que se ejecuta cuando el estado de autenticación cambia
  void _onAuthStateChanged() {
    if (authProvider.user != null) {
      _loadOwnedGames(authProvider.user!.uid);
    } else {
      // Si el usuario cierra sesión, se vacía la lista de juegos poseídos
      _ownedGameIds = [];
      notifyListeners();
    }
  }

  // Carga los IDs de los juegos que el usuario posee desde la base de datos
  Future<void> _loadOwnedGames(String userId) async {
    try {
      _ownedGameIds = await databaseService.getOwnedGameIds(userId);
      notifyListeners();
    } catch (e) {
      print("Error al cargar la biblioteca del usuario: $e");
      // Opcional: manejar el error de forma más robusta
    }
  }

  // Limpiar el listener cuando el provider se destruye para evitar fugas de memoria
  @override
  void dispose() {
    authProvider.removeListener(_onAuthStateChanged);
    super.dispose();
  }
}
