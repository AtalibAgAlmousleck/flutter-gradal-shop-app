import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gradal/main_screens/category_screen.dart';
import 'package:gradal/minor_screens/product_details_screen.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import '../minor_screens/edit_product.dart';
import '../minor_screens/edit_store.dart';
import '../providers/wish_list_provider.dart';

class ProductModel extends StatefulWidget {
  final dynamic products;

  const ProductModel({
    super.key,
    //required this.doc,
    required this.products,
  });

  //final QueryDocumentSnapshot<Object?> doc;

  @override
  State<ProductModel> createState() => _ProductModelState();
}

class _ProductModelState extends State<ProductModel> {
  @override
  Widget build(BuildContext context) {
    var onSale = widget.products['discount'];
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(
              prodList: widget.products,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                    child: Container(
                      constraints:
                          BoxConstraints(minHeight: 100, maxHeight: 250),
                      child: Image(
                        image: NetworkImage(widget.products['proimages'][0]),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          widget.products['proname'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),

                        //todo: price and favorites
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '\$ ',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  widget.products['price'].toStringAsFixed(2),
                                  style: widget.products['discount'] != 0
                                      ? TextStyle(
                                          color: Colors.grey,
                                          fontSize: 11,
                                          decoration:
                                              TextDecoration.lineThrough,
                                          fontWeight: FontWeight.w600,
                                        )
                                      : TextStyle(
                                          color: Colors.red,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                ),
                                SizedBox(width: 6),
                                onSale != 0
                                    ? Text(
                                        //widget.products['price'].toStringAsFixed(2),
                                        //+ (' \$'),
                                        ((1 - (onSale / 100)) *
                                                widget.products['price'])
                                            .toStringAsFixed(2),
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )
                                    : Text(''),
                              ],
                            ),
                            widget.products['sid'] ==
                                    FirebaseAuth.instance.currentUser!.uid
                                ? IconButton(
                                    onPressed: () {

                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.red,
                                    ),
                                  )
                                : IconButton(
                                    onPressed: () {
                                      var existingItemModel = context
                                          .read<WishList>()
                                          .getWishList
                                          .firstWhereOrNull((product) =>
                                              product.documentId ==
                                              widget.products['proid']);
                                      existingItemModel != null
                                          ? context.read<WishList>().removeThis(
                                              widget.products['proid'])
                                          : context
                                              .read<WishList>()
                                              .addWishItem(
                                                widget.products['proname'],
                                                //widget.products['price'],
                                                onSale != 0
                                                    ? ((1 -
                                                            (widget.products[
                                                                    'discount'] /
                                                                100)) *
                                                        widget
                                                            .products['price'])
                                                    : widget.products['price'],
                                                1,
                                                widget.products['instock'],
                                                widget.products['proimages'],
                                                widget.products['proid'],
                                                widget.products['sid'],
                                              );
                                    },
                                    icon: context
                                                .watch<WishList>()
                                                .getWishList
                                                .firstWhereOrNull(
                                                  (product) =>
                                                      product.documentId ==
                                                      widget.products['proid'],
                                                ) !=
                                            null
                                        ? Icon(
                                            Icons.favorite,
                                            color: Colors.red,
                                            size: 30,
                                          )
                                        : Icon(
                                            Icons.favorite_border,
                                            color: Colors.red,
                                            size: 30,
                                          ),
                                  ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            onSale != 0
                ? Positioned(
                    top: 30,
                    left: 0,
                    child: Container(
                      height: 25,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                      ),
                      child: Center(
                        child: Text('Save $onSale %'),
                      ),
                    ),
                  )
                : Container(
                    color: Colors.transparent,
                  ),
          ],
        ),
      ),
    );
  }
}
