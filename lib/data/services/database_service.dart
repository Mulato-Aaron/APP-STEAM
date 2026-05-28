import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getProductsStream() {
    return _db
        .collection('products')
        .orderBy('updatedAt', descending: true)
        .snapshots();
  }

  Future<void> addProduct(Map<String, dynamic> productData) {
    productData['updatedAt'] = FieldValue.serverTimestamp();
    return _db.collection('products').add(productData);
  }

  Future<void> placeOrder(
      String userId, List<Map<String, dynamic>> items, double totalAmount) {
    return _db.collection('orders').add({
      'userId': userId,
      'items': items,
      'totalAmount': totalAmount,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> addSampleProduct() async {
    final products = await _db.collection('products').limit(1).get();
    if (products.docs.isEmpty) {
      await addProduct({
        'name': 'Laptop de Ejemplo',
        'description': 'Una excelente laptop para todas tus necesidades.',
        'price': 999.99,
        'imageUrl': 'https://picsum.photos/seed/picsum/400/300',
      });
    }
  }
}
