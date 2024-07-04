
import 'package:flutter/foundation.dart';
import 'package:gradal/providers/products_class.dart';

class WishList extends ChangeNotifier {
  final List<Product> _list = [];

  List<Product> get getWishList {
    return _list;
  }

  int? get count {
    return _list.length;
  }

  void addWishItem (
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

  void removeItem(Product product) {
    _list.remove(product);
    notifyListeners();
  }

  void clearWishList() {
    _list.clear();
    notifyListeners();
  }

  void removeThis(String id) {
    _list.removeWhere((element) => element.documentId == id);
    notifyListeners();
  }
}