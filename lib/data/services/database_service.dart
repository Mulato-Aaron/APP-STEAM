
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
  Future<void> placeOrder(UserOrder order) async {
    WriteBatch batch = _db.batch();

    // 1. Crea el documento del pedido en la colección /orders
    DocumentReference orderRef = _db.collection('orders').doc();
    batch.set(orderRef, order.toFirestore());

    // 2. Añade cada juego a la biblioteca del usuario
    for (var item in order.items) {
      DocumentReference libraryRef = _db
          .collection('users')
          .doc(order.userId)
          .collection('library')
          .doc(item.id); // Usa el ID del producto como ID del documento

      batch.set(libraryRef, {
        'productId': item.id,
        'title': item.title,
        'purchaseDate': order.createdAt,
      });
    }

    // 3. Confirma el lote atómico
    await batch.commit();
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
        // Asumiendo que 'productId' está guardado en el documento de la biblioteca
        String productId = doc.data()['productId'];
        DocumentSnapshot gameDoc = await _db.collection('products').doc(productId).get();
        if (gameDoc.exists) {
          libraryGames.add(Game.fromFirestore(gameDoc));
        }
      }
      return libraryGames;
    });
  }

}
