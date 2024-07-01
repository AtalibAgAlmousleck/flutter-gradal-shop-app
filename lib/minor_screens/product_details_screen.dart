import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:gradal/minor_screens/full_screen_view.dart';
import 'package:gradal/widgets/yellow_button.dart';

import '../models/products_model.dart';

class ProductDetailsScreen extends StatefulWidget {
  final dynamic prodList;
  const ProductDetailsScreen({super.key, required this.prodList,});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late List<dynamic> imagesList = widget.prodList['proimages'];

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _productsStream = FirebaseFirestore
        .instance.collection('products')
        .where('maincateg', isEqualTo: widget.prodList['maincateg'])
        .where('subcateg', isEqualTo: widget.prodList['subcateg'])
        .snapshots();
    return Material(
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => FullScreenView(imagesList: imagesList,)
                    ),);
                  },
                  child: Stack(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.45,
                        child: Swiper(
                          pagination: SwiperPagination(
                              builder: SwiperPagination.fraction
                          ),
                          itemBuilder: (context, index) {
                            return Image(image: NetworkImage(imagesList[index]),);
                          },
                          itemCount: imagesList.length,
                        ),
                      ),
                      Positioned(
                        left: 15,
                        top: 20,
                        child: CircleAvatar(
                          backgroundColor: Colors.grey,
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.arrow_back, color: Colors.black,),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 15,
                        top: 20,
                        child: CircleAvatar(
                          backgroundColor: Colors.grey,
                          child: IconButton(
                            onPressed: () {
                              //Navigator.pop(context);
                            },
                            icon: Icon(Icons.share, color: Colors.black,),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8,right: 8, left: 8, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                      widget.prodList['proname'],
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: [
                              Text('USD ', style: TextStyle(
                                color: Colors.red,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),),
                              Text(widget.prodList['price'].toStringAsFixed(2), style: TextStyle(
                                color: Colors.red,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                              ),
                            ],
                          ),
                          IconButton(onPressed:() {
                          },
                            icon: Icon(Icons.favorite_border_outlined,
                              color: Colors.red,
                              size: 30,
                            ),),
                        ],
                      ),
                    ],
                  ),
                ),
                Text(
                  (widget.prodList['instock'].toString()) + (' pieces available in stock'),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blueGrey,
                ),),
                ProDetailsHear(
                  label: ' Item description ',
                ),
                Text(
                  widget.prodList['prodesc'],
                textScaleFactor: 1.1,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.blueGrey.shade800,
                ),),
                ProDetailsHear(
                  label: ' Recommended Items ',
                ),
                SizedBox(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _productsStream,
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                          ),
                        );
                      }
                      if (snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Text('This category has no items yet!',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),),
                        );
                      }
                      return SingleChildScrollView(
                        child: StaggeredGrid.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: 4,
                          crossAxisSpacing: 4,
                          children: List.generate(snapshot.data!.docs.length, (index) {
                            var doc = snapshot.data!.docs[index];
                            return StaggeredGridTile.fit(
                              crossAxisCellCount: 1,
                              child: ProductModel(
                                doc: doc,
                                products: snapshot.data!.docs[index],
                              ),
                            );
                          }),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          bottomSheet: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: [
                    IconButton(onPressed: () {}, icon: Icon(Icons.store),),
                    SizedBox(width: 20,),
                    IconButton(onPressed: () {}, icon: Icon(Icons.shopping_cart),),
                  ],
                ),
                YellowButton(label: 'ADD TO CART', onPressed: () {}, width: 0.5),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProDetailsHear extends StatelessWidget {
  final String label;
  const ProDetailsHear({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              color: Colors.grey,
              thickness: 1,
            ),
          ),
         Text(
           label,
         style: TextStyle(
           color: Colors.grey,
           fontSize: 24,
           fontWeight: FontWeight.w600
         ),),
          SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              color: Colors.grey,
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}
