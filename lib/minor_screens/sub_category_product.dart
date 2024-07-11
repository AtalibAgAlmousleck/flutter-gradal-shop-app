import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../models/products_model.dart';
import '../widgets/app_bar_widgets.dart';

class SubCategoryProduct extends StatefulWidget {
  const SubCategoryProduct({
    super.key,
    required this.subcategoryName,
    required this.mainCategoryName,
  });
  final String subcategoryName;
  final String mainCategoryName;

  @override
  State<SubCategoryProduct> createState() => _SubCategoryProductState();
}

class _SubCategoryProductState extends State<SubCategoryProduct> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> productsStream = FirebaseFirestore
        .instance.collection('products')
        .where('maincateg', isEqualTo: widget.mainCategoryName)
        .where('subcateg', isEqualTo: widget.subcategoryName)
        .snapshots();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey.shade200,
        leading: AppBarBackButton(),
        title: AppBarTitle(title: widget.subcategoryName),
        centerTitle: true,
        //centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: productsStream,
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
    );
  }
}
