import 'coffee.dart';

class CartItem {
  final Coffee coffee;
  final String size; // 'S' | 'M' | 'L'
  int quantity;

  CartItem({required this.coffee, required this.size, this.quantity = 1});

  double get sizeMultiplier {
    switch (size) {
      case 'S':
        return 0.9;
      case 'L':
        return 1.35;
      default:
        return 1.1;
    }
  }

  double get lineTotal => coffee.price * sizeMultiplier * quantity;

  String get key => '${coffee.id}_$size';
}
