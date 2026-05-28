
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:proyecto_5_semestre/models/cart_item.dart';
import 'package:proyecto_5_semestre/models/game.dart';
import 'dart:developer' as developer;

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

  // Nuevo método para verificar si un juego está en el carrito
  bool isInCart(String gameId) {
    return _items.containsKey(gameId);
  }

  Future<void> _saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    try {
       final cartData = json.encode({
        'items': _items.values.map((item) => item.toMap()).toList(),
      });
      await prefs.setString('cart', cartData);
      developer.log('Carrito guardado exitosamente.', name: 'CartProvider');
    } catch (e) {
      developer.log('Error al guardar el carrito: $e', name: 'CartProvider', level: 1000);
    }
  }

  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('cart')) {
      return;
    }
    try {
      final extractedData = json.decode(prefs.getString('cart')!) as Map<String, dynamic>;
      final List<dynamic> itemsList = extractedData['items'];
      
      _items = {};
      for (var itemData in itemsList) {
        final cartItem = CartItem.fromMap(itemData as Map<String, dynamic>);
        _items[cartItem.id] = cartItem;
      }
      notifyListeners();
       developer.log('Carrito cargado exitosamente.', name: 'CartProvider');
    } catch (e) {
       developer.log('Error al cargar el carrito: $e', name: 'CartProvider', level: 1000);
       // Si hay un error, limpiar el carrito para evitar corrupción
       await prefs.remove('cart');
       _items = {};
       notifyListeners();
    }
  }

  void addItem(Game game) {
    // Si el juego ya está, no hacemos nada, porque el botón no debería estar visible.
    if (_items.containsKey(game.id)) {
      return; 
    }
    // Se añade siempre con cantidad 1.
    _items.putIfAbsent(
      game.id!,
      () => CartItem.fromGame(game), // Asume cantidad 1 desde el factory
    );
    notifyListeners();
    _saveCart();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
    _saveCart();
  }

  // Ya no necesitamos la lógica de cantidad, pero mantenemos el método por si se usa en otro lado.
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
          imageUrl: existingCartItem.imageUrl,
        ),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
    _saveCart();
  }

  Future<void> clearCart() async {
    _items = {};
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cart');
    notifyListeners();
    developer.log('Carrito limpiado y caché eliminada.', name: 'CartProvider');
  }
}
