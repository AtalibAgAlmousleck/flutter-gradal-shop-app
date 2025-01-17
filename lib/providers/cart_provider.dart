
import 'package:flutter/foundation.dart';
import 'package:gradal/providers/products_class.dart';

class Cart extends ChangeNotifier {
  final List<Product> _list = [];

  List<Product> get getItems {
    return _list;
  }

  int? get count {
    return _list.length;
  }

  void addItem (
      String name,
      double price,
      int quantity,
      int bigQuantity,
      List imagesUrl,
      String documentId,
      String suppId) {
    final product = Product(name: name, price: price,
        quantity: quantity, bigQuantity: bigQuantity,
        imagesUrl: imagesUrl, documentId: documentId, suppId: suppId);
    _list.add(product);
    notifyListeners();
  }

  void increment(Product product) {
    product.increase();
    notifyListeners();
  }

  double get totalPrice {
    var total = 0.0;

    for (var item in _list) {
      total += item.price * item.quantity;
    }
    return total;
  }

  void decrement(Product product) {
    product.decrease();
    notifyListeners();
  }

  void removeItem(Product product) {
    _list.remove(product);
    notifyListeners();
  }

  void clearCart() {
    _list.clear();
    notifyListeners();
  }
}