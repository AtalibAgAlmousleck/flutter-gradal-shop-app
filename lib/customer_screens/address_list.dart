import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradal/customer_screens/add_address.dart';
import 'package:gradal/widgets/app_bar_widgets.dart';
import 'package:gradal/widgets/yellow_button.dart';

class AddressList extends StatefulWidget {
  const AddressList({super.key});

  @override
  State<AddressList> createState() => _AddressListState();
}

class _AddressListState extends State<AddressList> {
  final Stream<QuerySnapshot> addressStream = FirebaseFirestore.instance
      .collection('customers')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('address')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: AppBarBackButton(),
        title: AppBarTitle(
          title: 'Address list',
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
              stream: addressStream,
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
                      'Please Set Your Address',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var customer = snapshot.data!.docs[index];
                    return GestureDetector(
                      onTap: () async {
                        for (var item in snapshot.data!.docs) {
                          await FirebaseFirestore.instance
                              .runTransaction((transaction) async {
                            DocumentReference documentReference =
                                FirebaseFirestore.instance
                                    .collection('customers')
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .collection('address')
                                    .doc(item.id);
                            transaction.update(documentReference, {
                              'default': false,
                            });
                          });
                        }
                          await FirebaseFirestore.instance
                              .runTransaction((transaction) async {
                            DocumentReference documentReference =
                            FirebaseFirestore.instance
                                .collection('customers')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .collection('address')
                                .doc(customer['addressid']);
                            transaction.update(documentReference, {
                              'default': true,
                            });
                          });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          color: Colors.white,
                          child: ListTile(
                            trailing: customer['default'] == true
                                ? Icon(Icons.home)
                                : SizedBox(),
                            title: SizedBox(
                              height: 50,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'Name: ${customer['firstname']} ${customer['lastname']}'),
                                  Text('Phone: ${customer['phone']}'),
                                ],
                              ),
                            ),
                            subtitle: SizedBox(
                              height: 70,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('State: ${customer['city']}'
                                      'City: ${customer['state']}'),
                                  Text('Country: ${customer['country']}'),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            )),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
              child: YellowButton(
                label: 'Add New Address',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddAddress(),
                    ),
                  );
                },
                width: 0.8,
              ),
            )
          ],
        ),
      ),
    );
  }
}
