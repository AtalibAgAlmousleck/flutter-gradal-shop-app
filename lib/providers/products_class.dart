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