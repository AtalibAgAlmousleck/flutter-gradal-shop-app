import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

import '../providers/cart_provider.dart';
import '../providers/products_class.dart';
import '../providers/wish_list_provider.dart';

class WishListModal extends StatelessWidget {
  const WishListModal({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: SizedBox(
          height: 100,
          child: Row(
            children: [
              SizedBox(
                height: 100, width: 120,
                child: Image.network(
                  product.imagesUrl.first,
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15,
                          //fontWeight: FontWeight.w600,
                          //color: Colors.grey.shade700
                        ),),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(product.price.toStringAsFixed(2),
                            style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  context.read<WishList>()
                                      .removeItem(product);
                                },
                                icon: Icon(Icons.delete_forever),
                              ),
                              SizedBox(width: 10),
                              //todo: check if this item into the cart: else remove
                              context.watch<Cart>().getItems.firstWhereOrNull(
                                      (element) =>
                                  element.documentId ==
                                      product.documentId
                              ) != null ? SizedBox() : IconButton(
                                onPressed: () {
                                  // context.read<Cart>().getItems.firstWhereOrNull(
                                  //         (element) =>
                                  //     element.documentId ==
                                  //         product.documentId
                                  // ) != null ? print('in cart') :

                                  context.read<Cart>()
                                      .addItem(
                                      product.name,
                                      product.price,
                                      1,
                                      product.bigQuantity,
                                      product.imagesUrl,
                                      product.documentId,
                                      product.suppId
                                  );
                                },
                                icon: Icon(Icons.add_shopping_cart),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}