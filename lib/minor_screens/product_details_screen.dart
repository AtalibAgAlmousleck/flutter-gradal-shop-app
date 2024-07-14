import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:gradal/main_screens/cart.dart';
import 'package:gradal/minor_screens/full_screen_view.dart';
import 'package:gradal/minor_screens/visit_store.dart';
import 'package:gradal/providers/cart_provider.dart';
import 'package:gradal/providers/wish_list_provider.dart';
import 'package:gradal/widgets/app_bar_widgets.dart';
import 'package:gradal/widgets/snack_bar.dart';
import 'package:gradal/widgets/yellow_button.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import 'package:badges/badges.dart' as badges;
import 'package:expandable/expandable.dart';

import '../models/products_model.dart';

class ProductDetailsScreen extends StatefulWidget {
  final dynamic prodList;

  const ProductDetailsScreen({
    super.key,
    required this.prodList,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance
      .collection('products')
      .where('maincateg', isEqualTo: widget.prodList['maincateg'])
      .where('subcateg', isEqualTo: widget.prodList['subcateg'])
      .snapshots();

  late final Stream<QuerySnapshot> reviewsStream = FirebaseFirestore.instance
      .collection('products')
      .doc(widget.prodList['proid'])
      .collection('review')
      .snapshots();

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
  GlobalKey<ScaffoldMessengerState>();
  late List<dynamic> imagesList = widget.prodList['proimages'];

  @override
  Widget build(BuildContext context) {
    var onSale = widget.prodList['discount'];
    var existingItemCart = context.read<Cart>().getItems.firstWhereOrNull(
            (product) => product.documentId == widget.prodList['proid']);
    return Material(
      child: SafeArea(
        child: ScaffoldMessenger(
          key: _scaffoldKey,
          child: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FullScreenView(
                              imagesList: imagesList,
                            )),
                      );
                    },
                    child: Stack(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.45,
                          child: Swiper(
                            pagination: SwiperPagination(
                                builder: SwiperPagination.fraction),
                            itemBuilder: (context, index) {
                              return Image(
                                image: NetworkImage(imagesList[index]),
                              );
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
                              icon: Icon(
                                Icons.arrow_back,
                                color: Colors.black,
                              ),
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
                              icon: Icon(
                                Icons.share,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 8, right: 8, left: 8, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.prodList['proname'],
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: [
                                Text(
                                  'USD ',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  widget.prodList['price'].toStringAsFixed(2),
                                  //+ (' \$'),
                                  style: widget.prodList['discount'] != 0
                                      ? TextStyle(
                                    color: Colors.grey,
                                    fontSize: 20,
                                    decoration:
                                    TextDecoration.lineThrough,
                                    fontWeight: FontWeight.w600,
                                  )
                                      : TextStyle(
                                    color: Colors.red,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 6),
                                onSale != 0
                                    ? Text(
                                  //widget.products['price'].toStringAsFixed(2),
                                  //+ (' \$'),
                                  ((1 - (onSale / 100)) *
                                      widget.prodList['price'])
                                      .toStringAsFixed(2),
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                                    : Text(''),
                              ],
                            ),
                            IconButton(
                              onPressed: () {
                                var existingItemWishList = context
                                    .read<WishList>()
                                    .getWishList
                                    .firstWhereOrNull((product) =>
                                product.documentId ==
                                    widget.prodList['proid']);
                                existingItemWishList != null
                                    ? context
                                    .read<WishList>()
                                    .removeThis(widget.prodList['proid'])
                                    : context.read<WishList>().addWishItem(
                                    widget.prodList['proname'],
                                    //widget.prodList['price'],
                                    onSale != 0
                                        ? ((1 -
                                        (widget.prodList[
                                        'discount'] /
                                            100)) *
                                        widget.prodList['price'])
                                        : widget.prodList['price'],
                                    1,
                                    widget.prodList['instock'],
                                    widget.prodList['proimages'],
                                    widget.prodList['proid'],
                                    widget.prodList['sid']);
                              },
                              icon: context
                                  .watch<WishList>()
                                  .getWishList
                                  .firstWhereOrNull((product) =>
                              product.documentId ==
                                  widget.prodList['proid']) !=
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
                  widget.prodList['instock'] == 0
                      ? Text(
                    'Ops! this item is out of stock',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  )
                      : Text(
                    (widget.prodList['instock'].toString()) +
                        (' pieces available in stock'),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blueGrey,
                    ),
                  ),
                  ProDetailsHear(
                    label: ' Item description ',
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.prodList['prodesc'],
                      //textScaleFactor: 1.1,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        //color: Colors.blueGrey.shade800,
                      ),
                      //textAlign: TextAlign.center,
                    ),
                  ),
                  //todo: review from customers
                  Stack(
                    children: [
                      ExpandableTheme(
                        data: ExpandableThemeData(
                          iconColor: Colors.blue,
                          iconSize: 30,
                        ),
                        child: reviews(reviewsStream),
                      ),
                    ],
                  ),
                  //todo: recommended items
                  ProDetailsHear(
                    label: ' Recommended Items ',
                  ),
                  SizedBox(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: _productsStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('Something went wrong');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.data!.docs.isEmpty) {
                          return Center(
                            child: Text(
                              'This category has no items yet!',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }
                        return SingleChildScrollView(
                          child: StaggeredGrid.count(
                            crossAxisCount: 2,
                            mainAxisSpacing: 4,
                            crossAxisSpacing: 4,
                            children: List.generate(snapshot.data!.docs.length,
                                    (index) {
                                  var doc = snapshot.data!.docs[index];
                                  return StaggeredGridTile.fit(
                                    crossAxisCellCount: 1,
                                    child: ProductModel(
                                      //doc: doc,
                                      products: snapshot.data!.docs[index],
                                    ),
                                  );
                                }),
                          ),
                        );
                      },
                    ),
                  ),
                  // Add space before bottom sheet
                  SizedBox(height: 20),
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
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  VisitStore(suppId: widget.prodList['sid']),
                            ),
                          );
                        },
                        icon: Icon(Icons.store),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CartScreen(
                                back: const AppBarBackButton(),
                              ),
                            ),
                          );
                        },
                        //todo: fix the badge shopping cart
                        icon: badges.Badge(
                          showBadge: context.read<Cart>().getItems.isEmpty
                              ? false
                              : true,
                          badgeStyle: badges.BadgeStyle(
                            badgeColor: Colors.yellow,
                            padding: EdgeInsets.all(4),
                          ),
                          badgeContent: Text(
                            context.watch<Cart>().getItems.length.toString(),
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w400),
                          ),
                          child: Icon(Icons.shopping_cart),
                        ),
                      ),
                    ],
                  ),
                  //SizedBox(height: 60),
                  YellowButton(
                      label: existingItemCart != null
                          ? 'added to cart'
                          : 'ADD TO CART',
                      onPressed: () {
                        if (widget.prodList['instock'] == 0) {
                          MyMessageHandler.showSnackBar(
                              _scaffoldKey, 'Ops! this item is out of stock');
                        } else if (existingItemCart != null) {
                          MyMessageHandler.showSnackBar(
                              _scaffoldKey, 'Item already added to cart');
                        } else {
                          context.read<Cart>().addItem(
                              widget.prodList['proname'],
                              onSale != 0
                                  ? ((1 - (widget.prodList['discount'] / 100)) *
                                  widget.prodList['price'])
                                  : widget.prodList['price'],
                              1,
                              widget.prodList['instock'],
                              widget.prodList['proimages'],
                              widget.prodList['proid'],
                              widget.prodList['sid']);
                        }
                      },
                      width: 0.5),
                ],
              ),
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
                color: Colors.grey, fontSize: 20, fontWeight: FontWeight.w500),
          ),
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

Widget reviews(var reviewsStream) {
  return ExpandablePanel(
    header: Padding(
      padding: EdgeInsets.all(10),
      child: Text(
        'Reviews',
        style: TextStyle(
          fontSize: 20,
          color: Colors.blue,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    collapsed: SizedBox(
      height: 230,
      child: reviewsAll(reviewsStream),
    ),
    expanded: reviewsAll(reviewsStream),
  );
}

Widget reviewsAll(var reviewsStream) {
  return StreamBuilder<QuerySnapshot>(
    stream: reviewsStream,
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot2) {
      if (snapshot2.connectionState == ConnectionState.waiting) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
      if (snapshot2.data!.docs.isEmpty) {
        return Center(
          child: Text(
            'This product has no reviews yet!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }
      return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: snapshot2.data!.docs.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                snapshot2.data!.docs[index]['profileimage'],
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(snapshot2.data!.docs[index]['name']),
                Row(
                  children: [
                    Text(snapshot2.data!.docs[index]['rate'].toString()),
                    Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                  ],
                ),
              ],
            ),
            subtitle: Text(snapshot2.data!.docs[index]['comment']),
          );
        },
      );
    },
  );
}


// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
// import 'package:gradal/main_screens/cart.dart';
// import 'package:gradal/minor_screens/full_screen_view.dart';
// import 'package:gradal/minor_screens/visit_store.dart';
// import 'package:gradal/providers/cart_provider.dart';
// import 'package:gradal/providers/wish_list_provider.dart';
// import 'package:gradal/widgets/app_bar_widgets.dart';
// import 'package:gradal/widgets/snack_bar.dart';
// import 'package:gradal/widgets/yellow_button.dart';
// import 'package:provider/provider.dart';
// import 'package:collection/collection.dart';
// import 'package:badges/badges.dart' as badges;
// import 'package:expandable/expandable.dart';
//
// import '../models/products_model.dart';
//
// class ProductDetailsScreen extends StatefulWidget {
//   final dynamic prodList;
//
//   const ProductDetailsScreen({
//     super.key,
//     required this.prodList,
//   });
//
//   @override
//   State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
// }
//
// class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
//   late final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance
//       .collection('products')
//       .where('maincateg', isEqualTo: widget.prodList['maincateg'])
//       .where('subcateg', isEqualTo: widget.prodList['subcateg'])
//       .snapshots();
//
//   late final Stream<QuerySnapshot> reviewsStream = FirebaseFirestore.instance
//       .collection('products')
//       .doc(widget.prodList['proid'])
//       .collection('review')
//       .snapshots();
//
//   final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
//       GlobalKey<ScaffoldMessengerState>();
//   late List<dynamic> imagesList = widget.prodList['proimages'];
//
//   @override
//   Widget build(BuildContext context) {
//     var onSale = widget.prodList['discount'];
//     var existingItemCart = context.read<Cart>().getItems.firstWhereOrNull(
//         (product) => product.documentId == widget.prodList['proid']);
//     return Material(
//       child: SafeArea(
//         child: ScaffoldMessenger(
//           key: _scaffoldKey,
//           child: Scaffold(
//             body: SingleChildScrollView(
//               child: Column(
//                 children: <Widget>[
//                   InkWell(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => FullScreenView(
//                                   imagesList: imagesList,
//                                 )),
//                       );
//                     },
//                     child: Stack(
//                       children: [
//                         SizedBox(
//                           height: MediaQuery.of(context).size.height * 0.45,
//                           child: Swiper(
//                             pagination: SwiperPagination(
//                                 builder: SwiperPagination.fraction),
//                             itemBuilder: (context, index) {
//                               return Image(
//                                 image: NetworkImage(imagesList[index]),
//                               );
//                             },
//                             itemCount: imagesList.length,
//                           ),
//                         ),
//                         Positioned(
//                           left: 15,
//                           top: 20,
//                           child: CircleAvatar(
//                             backgroundColor: Colors.grey,
//                             child: IconButton(
//                               onPressed: () {
//                                 Navigator.pop(context);
//                               },
//                               icon: Icon(
//                                 Icons.arrow_back,
//                                 color: Colors.black,
//                               ),
//                             ),
//                           ),
//                         ),
//                         Positioned(
//                           right: 15,
//                           top: 20,
//                           child: CircleAvatar(
//                             backgroundColor: Colors.grey,
//                             child: IconButton(
//                               onPressed: () {
//                                 //Navigator.pop(context);
//                               },
//                               icon: Icon(
//                                 Icons.share,
//                                 color: Colors.black,
//                               ),
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(
//                         top: 8, right: 8, left: 8, bottom: 10),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           widget.prodList['proname'],
//                           style: TextStyle(
//                             color: Colors.grey.shade600,
//                             fontSize: 18,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: <Widget>[
//                             Row(
//                               children: [
//                                 Text(
//                                   'USD ',
//                                   style: TextStyle(
//                                     color: Colors.red,
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                                 Text(
//                                   widget.prodList['price'].toStringAsFixed(2),
//                                   //+ (' \$'),
//                                   style: widget.prodList['discount'] != 0
//                                       ? TextStyle(
//                                           color: Colors.grey,
//                                           fontSize: 20,
//                                           decoration:
//                                               TextDecoration.lineThrough,
//                                           fontWeight: FontWeight.w600,
//                                         )
//                                       : TextStyle(
//                                           color: Colors.red,
//                                           fontSize: 20,
//                                           fontWeight: FontWeight.w600,
//                                         ),
//                                 ),
//                                 SizedBox(width: 6),
//                                 onSale != 0
//                                     ? Text(
//                                         //widget.products['price'].toStringAsFixed(2),
//                                         //+ (' \$'),
//                                         ((1 - (onSale / 100)) *
//                                                 widget.prodList['price'])
//                                             .toStringAsFixed(2),
//                                         style: TextStyle(
//                                           color: Colors.red,
//                                           fontSize: 20,
//                                           fontWeight: FontWeight.w600,
//                                         ),
//                                       )
//                                     : Text(''),
//                               ],
//                             ),
//                             IconButton(
//                               onPressed: () {
//                                 var existingItemWishList = context
//                                     .read<WishList>()
//                                     .getWishList
//                                     .firstWhereOrNull((product) =>
//                                         product.documentId ==
//                                         widget.prodList['proid']);
//                                 existingItemWishList != null
//                                     ? context
//                                         .read<WishList>()
//                                         .removeThis(widget.prodList['proid'])
//                                     : context.read<WishList>().addWishItem(
//                                         widget.prodList['proname'],
//                                         //widget.prodList['price'],
//                                         onSale != 0
//                                             ? ((1 -
//                                                     (widget.prodList[
//                                                             'discount'] /
//                                                         100)) *
//                                                 widget.prodList['price'])
//                                             : widget.prodList['price'],
//                                         1,
//                                         widget.prodList['instock'],
//                                         widget.prodList['proimages'],
//                                         widget.prodList['proid'],
//                                         widget.prodList['sid']);
//                               },
//                               icon: context
//                                           .watch<WishList>()
//                                           .getWishList
//                                           .firstWhereOrNull((product) =>
//                                               product.documentId ==
//                                               widget.prodList['proid']) !=
//                                       null
//                                   ? Icon(
//                                       Icons.favorite,
//                                       color: Colors.red,
//                                       size: 30,
//                                     )
//                                   : Icon(
//                                       Icons.favorite_border,
//                                       color: Colors.red,
//                                       size: 30,
//                                     ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   widget.prodList['instock'] == 0
//                       ? Text(
//                           'Ops! this item is out of stock',
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.red,
//                           ),
//                         )
//                       : Text(
//                           (widget.prodList['instock'].toString()) +
//                               (' pieces available in stock'),
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.blueGrey,
//                           ),
//                         ),
//                   ProDetailsHear(
//                     label: ' Item description ',
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text(
//                       widget.prodList['prodesc'],
//                       //textScaleFactor: 1.1,
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w500,
//                         //color: Colors.blueGrey.shade800,
//                       ),
//                       //textAlign: TextAlign.center,
//                     ),
//                   ),
//                   //todo: review from customers
//                   Stack(
//                     children: [ ExpandableTheme(
//                       data: ExpandableThemeData(
//                         iconColor: Colors.blue,
//                         iconSize: 30,
//                       ),
//                       child: reviews(reviewsStream),
//                     ),
//                   ]),
//                   //todo: recommended items
//                   ProDetailsHear(
//                     label: ' Recommended Items ',
//                   ),
//                   SizedBox(
//                     child: StreamBuilder<QuerySnapshot>(
//                       stream: _productsStream,
//                       builder: (BuildContext context,
//                           AsyncSnapshot<QuerySnapshot> snapshot) {
//                         if (snapshot.hasError) {
//                           return Text('Something went wrong');
//                         }
//
//                         if (snapshot.connectionState ==
//                             ConnectionState.waiting) {
//                           return Center(
//                             child: CircularProgressIndicator(),
//                           );
//                         }
//                         if (snapshot.data!.docs.isEmpty) {
//                           return Center(
//                             child: Text(
//                               'This category has no items yet!',
//                               style: TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           );
//                         }
//                         return SingleChildScrollView(
//                           child: StaggeredGrid.count(
//                             crossAxisCount: 2,
//                             mainAxisSpacing: 4,
//                             crossAxisSpacing: 4,
//                             children: List.generate(snapshot.data!.docs.length,
//                                 (index) {
//                               var doc = snapshot.data!.docs[index];
//                               return StaggeredGridTile.fit(
//                                 crossAxisCellCount: 1,
//                                 child: ProductModel(
//                                   doc: doc,
//                                   products: snapshot.data!.docs[index],
//                                 ),
//                               );
//                             }),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             bottomSheet: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 15),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   Row(
//                     children: [
//                       IconButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) =>
//                                   VisitStore(suppId: widget.prodList['sid']),
//                             ),
//                           );
//                         },
//                         icon: Icon(Icons.store),
//                       ),
//                       SizedBox(
//                         width: 20,
//                       ),
//                       IconButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => CartScreen(
//                                 back: const AppBarBackButton(),
//                               ),
//                             ),
//                           );
//                         },
//                         //todo: fix the badge shopping cart
//                         icon: badges.Badge(
//                           showBadge: context.read<Cart>().getItems.isEmpty
//                               ? false
//                               : true,
//                           badgeStyle: badges.BadgeStyle(
//                             badgeColor: Colors.yellow,
//                             padding: EdgeInsets.all(4),
//                           ),
//                           badgeContent: Text(
//                             context.watch<Cart>().getItems.length.toString(),
//                             style: TextStyle(
//                                 fontSize: 16, fontWeight: FontWeight.w400),
//                           ),
//                           child: Icon(Icons.shopping_cart),
//                         ),
//                       ),
//                     ],
//                   ),
//                   //SizedBox(height: 60),
//                   YellowButton(
//                       label: existingItemCart != null
//                           ? 'added to cart'
//                           : 'ADD TO CART',
//                       onPressed: () {
//                         if (widget.prodList['instock'] == 0) {
//                           MyMessageHandler.showSnackBar(
//                               _scaffoldKey, 'Ops! this item is out of stock');
//                         } else if (existingItemCart != null) {
//                           MyMessageHandler.showSnackBar(
//                               _scaffoldKey, 'Item already added to cart');
//                         } else {
//                           context.read<Cart>().addItem(
//                               widget.prodList['proname'],
//                               onSale != 0
//                                   ? ((1 - (widget.prodList['discount'] / 100)) *
//                                       widget.prodList['price'])
//                                   : widget.prodList['price'],
//                               1,
//                               widget.prodList['instock'],
//                               widget.prodList['proimages'],
//                               widget.prodList['proid'],
//                               widget.prodList['sid']);
//                         }
//                       },
//                       width: 0.5),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class ProDetailsHear extends StatelessWidget {
//   final String label;
//
//   const ProDetailsHear({
//     super.key,
//     required this.label,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 60,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           SizedBox(
//             height: 40,
//             width: 50,
//             child: Divider(
//               color: Colors.grey,
//               thickness: 1,
//             ),
//           ),
//           Text(
//             label,
//             style: TextStyle(
//                 color: Colors.grey, fontSize: 20, fontWeight: FontWeight.w500),
//           ),
//           SizedBox(
//             height: 40,
//             width: 50,
//             child: Divider(
//               color: Colors.grey,
//               thickness: 1,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// Widget reviews(var reviewsStream) {
//   return ExpandablePanel(
//     header: Padding(
//       padding: EdgeInsets.all(10),
//       child: Text(
//         'Reviews',
//         style: TextStyle(
//           fontSize: 20,
//           color: Colors.blue,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     ),
//     collapsed: SizedBox(
//       height: 230,
//       child: reviewsAll(reviewsStream),
//     ),
//     expanded: reviewsAll(reviewsStream),
//   );
// }
//
// Widget reviewsAll(var reviewsStream) {
//   return StreamBuilder<QuerySnapshot>(
//     stream: reviewsStream,
//     builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot2) {
//       if (snapshot2.connectionState == ConnectionState.waiting) {
//         return Center(
//           child: CircularProgressIndicator(),
//         );
//       }
//       if (snapshot2.data!.docs.isEmpty) {
//         return Center(
//           child: Text(
//             'This product has no reviews yet!',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         );
//       }
//       return ListView.builder(
//         physics: const NeverScrollableScrollPhysics(),
//         shrinkWrap: true,
//         itemCount: snapshot2.data!.docs.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             leading: CircleAvatar(
//               backgroundImage: NetworkImage(
//                 snapshot2.data!.docs[index]['profileimage'],
//               ),
//             ),
//             title: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(snapshot2.data!.docs[index]['name']),
//                 Row(
//                   children: [
//                     Text(snapshot2.data!.docs[index]['rate'].toString()),
//                     Icon(
//                       Icons.star,
//                       color: Colors.amber,
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             subtitle: Text(snapshot2.data!.docs[index]['comment']),
//           );
//         },
//       );
//     },
//   );
// }
