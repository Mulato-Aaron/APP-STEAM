import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/game.dart';
import 'dart:developer' as developer;

class GameProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionPath = 'Juegos'; // Changed from 'games' to 'Juegos'

  Stream<List<Game>> get games {
    return _firestore.collection(_collectionPath).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        try {
          return Game.fromMap(doc.data(), doc.id);
        } catch (e, s) {
          developer.log(
            'Error parsing game document',
            name: 'GameProvider',
            error: e,
            stackTrace: s,
            level: 1000, // SEVERE
          );
          return null; // Return null for documents that fail to parse
        }
      }).whereType<Game>().toList(); // Filter out the nulls
    });
  }

  Future<void> addGame(Game game) {
    return _firestore.collection(_collectionPath).add(game.toMap());
  }

  Future<void> updateGame(Game game) {
    return _firestore.collection(_collectionPath).doc(game.id).update(game.toMap());
  }

  Future<void> deleteGame(String id) {
    return _firestore.collection(_collectionPath).doc(id).delete();
  }
}
