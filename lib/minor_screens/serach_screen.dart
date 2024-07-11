import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gradal/minor_screens/product_details_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String searchInput = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey.shade300,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: CupertinoSearchTextField(
          autofocus: true,
          backgroundColor: Colors.white,
          onChanged: (value) {
            setState(() {
              searchInput = value;
            });
          },
        ),
        centerTitle: true,
      ),
      body: searchInput == ''
          ? Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.yellow,
                  borderRadius: BorderRadius.circular(25),
                ),
                height: 30,
                width: MediaQuery.of(context).size.width * 0.7,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Icon(
                        Icons.search,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      'Search for anything..',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            )
          : StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('products').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No products found.'));
                }

                final result = snapshot.data!.docs.where((e) {
                  final data = e.data() as Map<String, dynamic>;
                  return data.containsKey('proname') &&
                      data['proname']
                          .toString()
                          .toLowerCase()
                          .contains(searchInput.toLowerCase());
                }).toList();

                if (result.isEmpty) {
                  return Center(
                    child: Text('Ops! it seems like no products found.',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey.shade600
                    ),),
                  );
                }

                return ListView(
                  children: result.map((e) => SearchModal(e: e)).toList(),
                );
              },
            ),
    );
  }
}

class SearchModal extends StatelessWidget {
  final DocumentSnapshot e;

  const SearchModal({super.key, required this.e});

  @override
  Widget build(BuildContext context) {
    final data = e.data() as Map<String, dynamic>;
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(prodList: e),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          height: 100,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    height: 100,
                    width: 100,
                    child: Image(
                      image: NetworkImage(data['proimages'][0]),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        data['proname'],
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        data['prodesc'],
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:gradal/minor_screens/product_details_screen.dart';
//
// class SearchScreen extends StatefulWidget {
//   const SearchScreen({super.key});
//
//   @override
//   State<SearchScreen> createState() => _SearchScreenState();
// }
//
// class _SearchScreenState extends State<SearchScreen> {
//   String searchInput = '';
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade300,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.grey.shade300,
//         leading: IconButton(
//           icon: Icon(
//             Icons.arrow_back_ios_new,
//             color: Colors.black,
//           ),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         title: CupertinoSearchTextField(
//           autofocus: true,
//           backgroundColor: Colors.white,
//           onChanged: (value) {
//             setState(() {
//               searchInput = value;
//             });
//           },
//         ),
//         centerTitle: true,
//       ),
//       body: searchInput == ''
//           ? Center(
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.yellow,
//                   borderRadius: BorderRadius.circular(25),
//                 ),
//                 height: 30,
//                 width: MediaQuery.of(context).size.width * 0.7,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: const [
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 15),
//                       child: Icon(
//                         Icons.search,
//                         color: Colors.grey,
//                       ),
//                     ),
//                     Text(
//                       'Search for anything..',
//                       style: TextStyle(color: Colors.grey),
//                     ),
//                   ],
//                 ),
//               ),
//             )
//           : StreamBuilder<QuerySnapshot>(
//               stream:
//                   FirebaseFirestore.instance.collection('products').snapshots(),
//               builder: (BuildContext context,
//                   AsyncSnapshot<QuerySnapshot> snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Material(
//                     child: Center(
//                       child: CircularProgressIndicator(),
//                     ),
//                   );
//                 }
//
//                 final result = snapshot.data!.docs.where((e) =>
//                     e['proname'.toLowerCase()]
//                         .contains(searchInput.toLowerCase()));
//
//                 return ListView(
//                   children: result.map((e) => SearchModal(e: e)).toList(),
//                 );
//               },
//             ),
//     );
//   }
// }
//
// class SearchModal extends StatelessWidget {
//   final dynamic e;
//
//   const SearchModal({super.key, required this.e});
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ProductDetailsScreen(prodList: e),
//           ),
//         );
//       },
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
//         child: Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(12),
//           ),
//           height: 100,
//           width: double.infinity,
//           child: Padding(
//             padding: const EdgeInsets.only(right: 10),
//             child: Row(
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(8),
//                   child: SizedBox(
//                     height: 100,
//                     width: 100,
//                     child: Image(
//                       image: NetworkImage(e['proimages'][0]),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Flexible(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       Text(
//                         e['proname'],
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 1,
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.black,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       Text(
//                         e['prodesc'],
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 2,
//                         style: TextStyle(fontSize: 12, color: Colors.grey),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
