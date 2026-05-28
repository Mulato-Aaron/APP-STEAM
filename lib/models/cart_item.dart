import 'package:proyecto_5_semestre/models/game.dart';

class CartItem {
  final String id; // Product ID
  final String title;
  final int quantity;
  final double price;

  CartItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
  });

  // From Game to CartItem
  factory CartItem.fromGame(Game game) {
    return CartItem(
      id: game.id!,
      title: game.title,
      quantity: 1,
      price: game.price,
    );
  }
  
  // For Firestore serialization
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'quantity': quantity,
      'price': price,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'],
      title: map['title'],
      quantity: map['quantity'],
      price: map['price'],
    );
  }
}
