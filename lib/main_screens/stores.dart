import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gradal/widgets/app_bar_widgets.dart';

class StoresScreen extends StatelessWidget {
  const StoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: AppBarTitle(
          title: 'Stores',
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(stream: FirebaseFirestore.instance.collection('suppliers')
            .snapshots(),builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
           return GridView.builder(
             itemCount: snapshot.data!.docs.length,
               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                 mainAxisSpacing: 25,
                 crossAxisSpacing: 25,
                 crossAxisCount: 2
               ),
               itemBuilder: (context, index) {
                 return Column(
                   children: [
                     Stack(
                       children: [
                         SizedBox(
                           height: 120, width: 120,
                           child: Image.network(snapshot.data!.docs[index]['storelogo']),
                           //Image.asset('images/inapp/almousleck.jpg'),
                         ),
                         // Positioned(
                         //   bottom: 28, left: 10,
                         //   child: SizedBox(
                         //     height: 48, width: 100,
                         //     child: Image.network(snapshot.data!.docs[index]['storelogo'],
                         //     fit: BoxFit.cover,),
                         //
                         //   ),
                         // ),
                       ],
                     ),
                     Text(snapshot.data!.docs[index]['storename'],
                     style: TextStyle(
                       fontSize: 24,
                       fontWeight: FontWeight.w600,
                       fontStyle: FontStyle.italic
                     ),),
                   ],
                 );
               },
           );
          }
          return Center(
            child: Text('No stores found',
            style: TextStyle(fontSize: 25),),
          );
            },
            ),
      ));
  }
}
