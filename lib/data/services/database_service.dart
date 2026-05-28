import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proyecto_5_semestre/models/game.dart';
import 'package:proyecto_5_semestre/models/user_order.dart';

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
  Future<void> placeOrder(UserOrder order) {
    return _db.collection('orders').add(order.toFirestore());
  }
  
}
