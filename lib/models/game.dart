
import 'package:cloud_firestore/cloud_firestore.dart';

class Game {
  final String? id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final String genre;
  final String releaseDate;

  Game({
    this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.genre,
    required this.releaseDate,
  });

  // Factory constructor to create a Game from a Firestore document
  factory Game.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Game(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: data['imageUrl'] ?? '',
      category: data['category'] ?? '',
      genre: data['genre'] ?? 'N/A',
      releaseDate: data['releaseDate'] ?? 'N/A',
    );
  }

  // Method to convert a Game object to a map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'genre': genre,
      'releaseDate': releaseDate,
    };
  }
}
