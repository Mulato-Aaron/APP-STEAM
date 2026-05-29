import 'package:cloud_firestore/cloud_firestore.dart';

class Developer {
  final String? id;
  final String name;
  final String imageUrl;
  final List<String> gameIds;

  Developer({
    this.id,
    required this.name,
    required this.imageUrl,
    required this.gameIds,
  });

  // Factory constructor to create a Developer from a Firestore document.
  factory Developer.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Developer(
      id: doc.id,
      name: data['name'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      gameIds: List<String>.from(data['gameIds'] ?? []),
    );
  }

  // Method to convert a Developer object to a map for Firestore.
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'gameIds': gameIds,
    };
  }
}
