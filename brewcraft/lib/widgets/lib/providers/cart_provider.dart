import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/coffee.dart';

enum OrderStage { placed, brewing, qualityCheck, onTheWay, delivered }

class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {};
  OrderStage? _orderStage;

  Map<String, CartItem> get items => Map.unmodifiable(_items);

  int get totalCount =>
      _items.values.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal =>
      _items.values.fold(0, (sum, item) => sum + item.lineTotal);

  double get deliveryFee => _items.isEmpty ? 0 : 1.99;

  double get total => subtotal + deliveryFee;

  OrderStage? get orderStage => _orderStage;

  void addToCart(Coffee coffee, String size, {int quantity = 1}) {
    final key = '${coffee.id}_$size';
    if (_items.containsKey(key)) {
      _items[key]!.quantity += quantity;
    } else {
      _items[key] = CartItem(coffee: coffee, size: size, quantity: quantity);
    }
    notifyListeners();
  }

  void updateQuantity(String key, int delta) {
    final item = _items[key];
    if (item == null) return;
    item.quantity += delta;
    if (item.quantity <= 0) {
      _items.remove(key);
    }
    notifyListeners();
  }

  void removeItem(String key) {
    _items.remove(key);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  void setOrderStage(OrderStage? stage) {
    _orderStage = stage;
    notifyListeners();
  }
}
