import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gradal/widgets/app_bar_widgets.dart';
import '../models/products_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'edit_store.dart';

class VisitStore extends StatefulWidget {
  final String suppId;

  const VisitStore({super.key, required this.suppId});

  @override
  State<VisitStore> createState() => _VisitStoreState();
}

class _VisitStoreState extends State<VisitStore> {
  bool following = false;

  @override
  Widget build(BuildContext context) {
    CollectionReference suppliers =
        FirebaseFirestore.instance.collection('suppliers');
    final Stream<QuerySnapshot> productsStream = FirebaseFirestore.instance
        .collection('products')
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
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            backgroundColor: Colors.blueGrey.shade100,
            appBar: AppBar(
              toolbarHeight: 120,
              flexibleSpace: data['coverimage'] == '' ? Image.asset(
                'images/inapp/coverimage.jpg',
                fit: BoxFit.cover,
              ) : Image.network(data['coverimage'], fit: BoxFit.cover,),
              leading: YellowBarBackButton(),
              title: Row(
                children: <Widget>[
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      border: Border.all(width: 4, color: Colors.yellow),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        data['storelogo'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                data['storename'].toUpperCase(),
                                style: TextStyle(
                                  color: Colors.yellow,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                        //todo: if it's store owner else no owner
                        data['sid'] == FirebaseAuth.instance.currentUser!.uid
                            ? Container(
                                height: 35,
                                width: MediaQuery.of(context).size.width * 0.3,
                                decoration: BoxDecoration(
                                  color: Colors.yellow,
                                  border:
                                      Border.all(width: 3, color: Colors.black),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                //todo: edit store
                                child: MaterialButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditStore(
                                          data: data,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: const <Widget>[
                                      Text(
                                        'Edit',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      Icon(
                                        Icons.edit,
                                        color: Colors.black,
                                        size: 30,
                                      ),
                                    ],
                                  ),
                                ),
                              ) //todo: if it's store owner else no owner
                            : Container(
                                height: 35,
                                width: MediaQuery.of(context).size.width * 0.3,
                                decoration: BoxDecoration(
                                  color: Colors.yellow,
                                  border:
                                      Border.all(width: 3, color: Colors.black),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: MaterialButton(
                                  onPressed: () {
                                    setState(() {
                                      following = !following;
                                    });
                                  },
                                  child: following == true
                                      ? Text('following')
                                      : Text('FOLLOW'),
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder<QuerySnapshot>(
                stream: productsStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Material(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  if (snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        'This Store has no items yet!',
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
                      children:
                          List.generate(snapshot.data!.docs.length, (index) {
                        var doc = snapshot.data!.docs[index];
                        return StaggeredGridTile.fit(
                          crossAxisCellCount: 1,
                          child: ProductModel(
                            //products: doc,
                            products: snapshot.data!.docs[index],
                          ),
                        );
                      }),
                    ),
                  );
                },
              ),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.green,
              onPressed: () {},
              child: Icon(
                FontAwesomeIcons.whatsapp,
                color: Colors.white,
                size: 40,
              ),
            ),
          );
        }
        return Center(
          child: Text(
            'Loading data',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
          ),
        );
      },
    );
  }
}
