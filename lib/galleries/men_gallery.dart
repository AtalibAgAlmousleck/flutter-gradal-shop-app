import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../models/products_model.dart';

class MenGalleryScreen extends StatefulWidget {
  const MenGalleryScreen({super.key});

  @override
  State<MenGalleryScreen> createState() => _MenGalleryScreenState();
}

class _MenGalleryScreenState extends State<MenGalleryScreen> {
  final Stream<QuerySnapshot> _productsStream = FirebaseFirestore
      .instance.collection('products')
      .where('maincateg', isEqualTo: 'men').snapshots();


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
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

        // return SingleChildScrollView(
        //   child: StaggeredGrid.count(
        //     crossAxisCount: 2,
        //     mainAxisSpacing: 2,
        //     crossAxisSpacing: 2,
        //     children: List.generate(snapshot.data!.docs.length, (index) {
        //       var doc = snapshot.data!.docs[index];
        //       return StaggeredGridTile.count(
        //         crossAxisCellCount: 1, // Adjust the cell count as needed
        //         mainAxisCellCount: 1,
        //         child: Container(
        //           decoration: BoxDecoration(
        //             color: Colors.white,
        //             borderRadius: BorderRadius.circular(15),
        //           ),
        //           child: Column(
        //             children: [
        //               Container(
        //                 constraints: BoxConstraints(
        //                   minHeight: 100,
        //                   maxHeight: 250,
        //                 ),
        //                 child: Image.network(doc['proimages'][0]),
        //               ),
        //               Text(doc['proname']),
        //             ],
        //           ),
        //         ),
        //       );
        //     }),
        //   ),
        // );

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

        // return SingleChildScrollView(
        //   child: StaggeredGrid.countBuilder(
        //     physics: const NeverScrollableScrollPhysics(),
        //     shrinkWrap: true,
        //     itemCount: snapshot.data!.docs.length,
        //     crossAxisCount: 2,
        //     itemBuilder: (context, index) {
        //       return Container(
        //         decoration: BoxDecoration(
        //           color: Colors.white,
        //           borderRadius: BorderRadius.circular(15),
        //         ),
        //         child: Column(
        //           children: [
        //             Container(
        //               constraints: BoxConstraints(
        //                   minHeight: 100, maxHeight: 250
        //               ),
        //               child: Image(
        //                 image: NetworkImage(
        //                     snapshot.data!.docs[index]['proimages'][0]
        //                 ),
        //               ),
        //             ),
        //             Text(snapshot.data!.docs[index]['proname']),
        //           ],
        //         ),
        //       );
        //     },
        //     staggeredTileBuilder: (index) => StaggeredTile.fit(1),
        //   ),
        // );

        //   ListView(
        //   children: snapshot.data!.docs.map((DocumentSnapshot document) {
        //     Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
        //     return ListTile(
        //       leading: Image(image: NetworkImage(data['proimages'][0]),),
        //       title: Text(data['proname']),
        //       subtitle: Text(data['price'].toString()),
        //     );
        //   }).toList(),
        // );
      },
    );
  }
}














