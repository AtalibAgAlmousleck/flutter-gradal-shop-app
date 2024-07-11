import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

import '../providers/cart_provider.dart';
import '../providers/products_class.dart';
import '../providers/wish_list_provider.dart';

class CartItemModal extends StatelessWidget {
  const CartItemModal({
    super.key,
    required this.product,
    required this.cart
  });

  final Product product;
  final Cart cart;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
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
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          //color: Colors.grey.shade700
                        ),),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(product.price.toStringAsFixed(2),
                            style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),),
                          Container(
                            //width: 70,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Row(
                              children: [
                                product.quantity == 1 ? IconButton(
                                  onPressed: (){
                                    //cart.removeItem(product);
                                    showCupertinoModalPopup<void>(

                                      context: context,
                                      builder: (BuildContext context) => CupertinoActionSheet(
                                        title: Text('RemoveItem'),
                                        message: Text('Are you sure to remove this item'),
                                        actions: <CupertinoActionSheetAction>[
                                          CupertinoActionSheetAction(
                                            onPressed: () async {
                                              context.read<WishList>()
                                                  .getWishList.firstWhereOrNull((element) =>
                                              element.documentId == product.documentId)
                                                  != null ?
                                              context.read<Cart>()
                                                  .removeItem(product)
                                                  : await
                                              context.read<WishList>()

                                                  .addWishItem(
                                                  product.name,
                                                  product.price,
                                                  1,
                                                  product.bigQuantity,
                                                  product.imagesUrl,
                                                  product.documentId,
                                                  product.suppId
                                              );
                                              await Future.delayed(Duration(microseconds: 100)).whenComplete(() {
                                                context.read<Cart>()
                                                    .removeItem(product);
                                                Navigator.pop(context);
                                              });
                                            },
                                            child: Text('Move to wishlist ?'),
                                          ),
                                          CupertinoActionSheetAction(
                                            onPressed: () {
                                              context.read<Cart>()
                                                  .removeItem(product);
                                              Navigator.pop(context);
                                            },
                                            child: Text('Delete item ?'),
                                          ),
                                        ],
                                        cancelButton: TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('Cancel',
                                            style: TextStyle(color: Colors.red, fontSize: 20),),
                                        ),
                                      ),
                                    );
                                  },
                                  icon: Icon(Icons.delete_forever, size: 18,),
                                ) : IconButton(
                                  onPressed: (){
                                    cart.decrement(product);
                                  },
                                  icon: Icon(FontAwesomeIcons.circleMinus, size: 18,),
                                ),
                                Text(
                                  product.quantity.toString(),
                                  style: product.quantity ==
                                      product.bigQuantity ? TextStyle(
                                      fontSize: 20, color: Colors.red)
                                      : TextStyle(fontSize: 20),
                                ),
                                IconButton(
                                  onPressed: product.quantity ==
                                      product.bigQuantity ? null : (){
                                    cart.increment(product);

                                  },
                                  icon: Icon(FontAwesomeIcons.circlePlus, size: 18,),
                                )
                              ],
                            ),
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