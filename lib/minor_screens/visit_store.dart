import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../models/products_model.dart';

class VisitStore extends StatefulWidget {
  final String suppId;
  const VisitStore({super.key, required this.suppId});

  @override
  State<VisitStore> createState() => _VisitStoreState();
}

class _VisitStoreState extends State<VisitStore> {
  @override
  Widget build(BuildContext context) {
    CollectionReference suppliers = FirebaseFirestore.instance.collection('suppliers');
    final Stream<QuerySnapshot> _productsStream = FirebaseFirestore
        .instance.collection('products')
        .where('sid', isEqualTo: widget.suppId)
        .snapshots();

    return FutureBuilder<DocumentSnapshot>(
      future: suppliers.doc(widget.suppId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Material(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            backgroundColor: Colors.blueGrey.shade100,
            appBar: AppBar(
              toolbarHeight: 100,
              flexibleSpace: Image.asset('images/inapp/coverimage.jpg',
              fit: BoxFit.cover,),
              title: Row(
                children: <Widget>[
                  Container(
                    height: 80, width: 80,
                    decoration: BoxDecoration(
                      border: Border.all(width: 4, color: Colors.yellow),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ],
              ),
            ),
            body: StreamBuilder<QuerySnapshot>(
              stream: _productsStream,
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Material(
                    child: Center(
                      child: CircularProgressIndicator(
                      ),
                    ),
                  );
                }
                if (snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text('This Store has no items yet!',
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
        return Center(
          child: Text('Loading data',
            style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600
            ),),
        );
      },
    );
  }
}
