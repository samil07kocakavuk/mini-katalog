import 'package:flutter/foundation.dart';

import '../models/cart_item.dart';
import '../models/product.dart';

class CartController extends ChangeNotifier {
  final Map<int, CartItem> _items = <int, CartItem>{};

  List<CartItem> get items => List<CartItem>.unmodifiable(_items.values);
  bool get isEmpty => _items.isEmpty;
  int get totalCount =>
      _items.values.fold(0, (sum, item) => sum + item.quantity);
  double get totalPrice =>
      _items.values.fold<double>(0, (sum, item) => sum + item.lineTotal);

  void add(Product product) {
    final existing = _items[product.id];
    if (existing == null) {
      _items[product.id] = CartItem(product: product);
    } else {
      existing.quantity++;
    }
    notifyListeners();
  }

  void increment(int productId) {
    final item = _items[productId];
    if (item == null) return;
    item.quantity++;
    notifyListeners();
  }

  void decrement(int productId) {
    final item = _items[productId];
    if (item == null) return;
    if (item.quantity <= 1) {
      _items.remove(productId);
    } else {
      item.quantity--;
    }
    notifyListeners();
  }

  void remove(int productId) {
    if (_items.remove(productId) != null) {
      notifyListeners();
    }
  }

  void clear() {
    if (_items.isEmpty) return;
    _items.clear();
    notifyListeners();
  }
}
