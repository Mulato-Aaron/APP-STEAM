import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proyecto_5_semestre/models/cart_item.dart';

class UserOrder {
  final String? id;
  final String userId;
  final List<CartItem> items;
  final double total;
  final DateTime createdAt;

  UserOrder({
    this.id,
    required this.userId,
    required this.items,
    required this.total,
    required this.createdAt,
  });

  factory UserOrder.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return UserOrder(
      id: doc.id,
      userId: data['userId'],
      items: (data['items'] as List)
          .map((item) => CartItem.fromMap(item))
          .toList(),
      total: data['total'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'items': items.map((item) => item.toMap()).toList(),
      'total': total,
      'createdAt': createdAt,
    };
  }
}
