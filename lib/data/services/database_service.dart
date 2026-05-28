
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proyecto_5_semestre/models/game.dart';
import 'package:proyecto_5_semestre/models/user_order.dart';
import 'dart:developer' as developer; // Importa el logger

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- Product (Game) CRUD ---
  Stream<List<Game>> getGames() {
    return _db.collection('products').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Game.fromFirestore(doc)).toList());
  }

  Future<void> addGame(Game game) {
    return _db.collection('products').add(game.toFirestore());
  }

  Future<void> updateGame(Game game) {
    return _db.collection('products').doc(game.id).update(game.toFirestore());
  }

  Future<void> deleteGame(String gameId) {
    return _db.collection('products').doc(gameId).delete();
  }

  // --- Order Management ---
  Future<void> placeOrder(UserOrder order) async {
    developer.log(
      'Intentando realizar el pedido...',
      name: 'DatabaseService.placeOrder',
      error: 'UserID: ${order.userId}, Items: ${order.items.length}, Total: ${order.total}',
    );

    try {
      WriteBatch batch = _db.batch();

      DocumentReference orderRef = _db.collection('orders').doc();
      batch.set(orderRef, order.toFirestore());

      if (order.items.isEmpty) {
        throw Exception('No se puede procesar un pedido sin artículos.');
      }
      
      for (var item in order.items) {
        DocumentReference libraryRef = _db
            .collection('users')
            .doc(order.userId)
            .collection('library')
            .doc(item.id);

        batch.set(libraryRef, {
          'productId': item.id,
          'title': item.title,
          'purchaseDate': order.createdAt,
          'imageUrl': item.imageUrl,
        });
      }

      await batch.commit();

      developer.log('¡Pedido realizado con éxito en Firestore!', name: 'DatabaseService.placeOrder');

    } catch (e, s) {
      final errorMessage = 'Error al realizar el pedido en Firestore: ${e.toString()}';
      developer.log(
        errorMessage,
        name: 'DatabaseService.placeOrder',
        error: e,
        stackTrace: s,
        level: 1000, 
      );
      throw Exception('Ocurrió un error al procesar tu pedido. Detalles: ${e.toString()}');
    }
  }

   Stream<List<Game>> getUserLibrary(String userId) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('library')
        .snapshots()
        .asyncMap((snapshot) async {
      List<Game> libraryGames = [];
      for (var doc in snapshot.docs) {
        String? productId = doc.data()['productId'];
        if(productId != null) {
          DocumentSnapshot gameDoc = await _db.collection('products').doc(productId).get();
          if (gameDoc.exists) {
            libraryGames.add(Game.fromFirestore(gameDoc));
          }
        }
      }
      return libraryGames;
    });
  }

  Future<List<String>> getOwnedGameIds(String userId) async {
    try {
      var snapshot = await _db
          .collection('users')
          .doc(userId)
          .collection('library')
          .get();
      return snapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      developer.log(
        'Error al obtener los IDs de la biblioteca: ${e.toString()}',
        name: 'DatabaseService.getOwnedGameIds',
        error: e,
      );
      return [];
    }
  }
  
  Stream<List<String>> getOwnedGameIdsStream(String userId) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('library')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => doc.id).toList();
        });
  }

  // NUEVO MÉTODO: Devuelve un Stream con el historial de compras de un usuario
  Stream<List<UserOrder>> getOrdersForUser(String userId) {
    return _db
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true) // Ordenar por fecha, más reciente primero
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => UserOrder.fromFirestore(doc))
            .toList());
  }
}
