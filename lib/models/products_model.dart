import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gradal/minor_screens/product_details_screen.dart';

class ProductModel extends StatelessWidget {
  final dynamic products;
  const ProductModel({
    super.key,
    required this.doc, required this.products,
  });

  final QueryDocumentSnapshot<Object?> doc;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) =>
        ProductDetailsScreen(prodList: products,),),);
      },
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),),
                child: Container(
                  constraints: BoxConstraints(
                      minHeight: 100, maxHeight: 250
                  ),
                  child: Image(
                    image: NetworkImage(doc['proimages'][0]),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      products['proname'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 16, fontWeight: FontWeight.w600
                      ),
                    ),
                    // price and favorites
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          products['price'].toStringAsFixed(2) + (' \$'),
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 16, fontWeight: FontWeight.w600
                          ),),
                        IconButton(onPressed: () {},
                            icon: Icon(Icons.favorite_border_outlined,
                              color: Colors.red,)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}