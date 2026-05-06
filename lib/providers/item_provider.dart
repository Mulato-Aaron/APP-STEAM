import 'package:flutter/material.dart';
import '../models/item.dart';

class ItemProvider with ChangeNotifier {
  final List<Item> _items = [];

  List<Item> get items => _items;

  void addItem(String name) {
    final newItem = Item(id: DateTime.now().toString(), name: name);
    _items.add(newItem);
    notifyListeners();
  }

  void toggleItem(String id) {
    final item = _items.firstWhere((item) => item.id == id);
    item.isBought = !item.isBought;
    notifyListeners();
  }
}
