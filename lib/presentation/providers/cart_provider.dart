
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:proyecto_5_semestre/models/cart_item.dart';
import 'package:proyecto_5_semestre/models/game.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartItem> _items = {};

  CartProvider() {
    loadCart();
  }

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  Future<void> _saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = json.encode({
      'items': _items.map((key, item) => MapEntry(key, item.toMap())).values.toList(),
    });
    await prefs.setString('cart', cartData);
  }

  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('cart')) {
      return;
    }
    final extractedData = json.decode(prefs.getString('cart')!) as Map<String, dynamic>;
    final List<dynamic> itemsList = extractedData['items'];
    
    _items = {};
    for (var itemData in itemsList) {
      final cartItem = CartItem.fromMap(itemData as Map<String, dynamic>);
      _items[cartItem.id] = cartItem;
    }
    notifyListeners();
  }

  void addItem(Game game) {
    if (_items.containsKey(game.id)) {
      _items.update(
        game.id!,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          quantity: existingCartItem.quantity + 1,
          price: existingCartItem.price,
        ),
      );
    } else {
      _items.putIfAbsent(
        game.id!,
        () => CartItem(
          id: game.id!,
          title: game.title,
          price: game.price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
    _saveCart();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
    _saveCart();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId]!.quantity > 1) {
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          quantity: existingCartItem.quantity - 1,
          price: existingCartItem.price,
        ),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
    _saveCart();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
    _saveCart();
  }
}
