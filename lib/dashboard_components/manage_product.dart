import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gradal/widgets/app_bar_widgets.dart';

import '../models/products_model.dart';

class ManageProduct extends StatelessWidget {
  const ManageProduct({super.key});

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> productsStream = FirebaseFirestore
        .instance.collection('products')
        .where('sid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: AppBarTitle(title: 'Manage Product'),
        centerTitle: true,
        leading: AppBarBackButton(),
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
