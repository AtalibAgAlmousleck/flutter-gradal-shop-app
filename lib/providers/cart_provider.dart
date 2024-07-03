
import 'package:flutter/material.dart';

class Product {
  String name;
  double price;
  int quantity = 1;
  int bigQuantity;
  List imagesUrl;
  String documentId;
  String suppId;

  Product({
    required this.name,
    required this.price,
    required this.quantity,
    required this.bigQuantity,
    required this.imagesUrl,
    required this.documentId,
    required this.suppId
});

  void increase() {
    quantity++;
  }

  void decrease() {
    quantity--;
  }
}

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