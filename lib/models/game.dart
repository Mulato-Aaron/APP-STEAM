import 'package:cloud_firestore/cloud_firestore.dart';

class Game {
  final String? id;
  final String title;
  final String description;
  final double price;
  final int stock;
  final String imageUrl;
  final String category;

  Game({
    this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.stock,
    required this.imageUrl,
    required this.category,
  });

  // Factory constructor to create a Game from a Firestore document
  factory Game.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Game(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      stock: (data['stock'] as num?)?.toInt() ?? 0,
      imageUrl: data['imageUrl'] ?? '',
      category: data['category'] ?? '',
    );
  }

  // Method to convert a Game object to a map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'stock': stock,
      'imageUrl': imageUrl,
      'category': category,
    };
  }
}
