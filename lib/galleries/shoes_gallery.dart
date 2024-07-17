import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gradal/widgets/app_bar_widgets.dart';

import '../models/products_model.dart';

class ShoesGalleryScreen extends StatefulWidget {
  final bool fromOnBoarding;
  const ShoesGalleryScreen({super.key, this.fromOnBoarding = false});

  @override
  State<ShoesGalleryScreen> createState() => _ShoesGalleryScreenState();
}

class _ShoesGalleryScreenState extends State<ShoesGalleryScreen> {
  final Stream<QuerySnapshot> _productsStream = FirebaseFirestore
      .instance.collection('products')
      .where('maincateg', isEqualTo: 'shoes')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.fromOnBoarding == true ? AppBar(
        title: AppBarTitle(title: 'Shoes collections',),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/customer_home');
          },
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black,),
        ),
      ) : null,
      body: StreamBuilder<QuerySnapshot>(
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
                    //doc: doc,
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














