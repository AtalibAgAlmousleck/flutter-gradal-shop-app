import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gradal/providers/cart_provider.dart';
import 'package:gradal/widgets/app_bar_widgets.dart';
import 'package:gradal/widgets/yellow_button.dart';
import 'package:provider/provider.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int selectedValue = 1;
  CollectionReference customers =
      FirebaseFirestore.instance.collection('customers');

  @override
  Widget build(BuildContext context) {
    double totalPrice = context.watch<Cart>().totalPrice;
    double totalPaid = context.watch<Cart>().totalPrice + 10.0;
    return FutureBuilder<DocumentSnapshot>(
        future: customers.doc(FirebaseAuth.instance.currentUser!.uid).get(),
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
            return Material(
              color: Colors.grey.shade400,
              child: SafeArea(
                child: Scaffold(
                  backgroundColor: Colors.grey.shade400,
                  appBar: AppBar(
                    elevation: 0,
                    backgroundColor: Colors.grey.shade400,
                    leading: AppBarBackButton(),
                    title: AppBarTitle(title: 'Payment'),
                    centerTitle: true,
                  ),
                  body: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 60),
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 130,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                //todo:
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Total',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Text(
                                      '${totalPaid.toStringAsFixed(2)} USD',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ],
                                ),
                                Divider(
                                  color: Colors.grey.shade400,
                                  thickness: 2,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Total order:',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.grey),
                                    ),
                                    Text(
                                      '${totalPrice.toStringAsFixed(2)} USD',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.grey),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text(
                                      'Shipping Coast:',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.grey),
                                    ),
                                    Text(
                                      '10.00 USD',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        //todo: register payment method
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              children: <Widget>[
                                RadioListTile(
                                  value: 1,
                                  groupValue: selectedValue,
                                  onChanged: (int? value) {
                                    setState(() {
                                      selectedValue = value!;
                                    });
                                  },
                                  title: Text('Cash On Delivery'),
                                  subtitle: Text('Pay Cash At Home'),
                                ),
                                RadioListTile(
                                  value: 2,
                                  groupValue: selectedValue,
                                  onChanged: (int? value) {
                                    setState(() {
                                      selectedValue = value!;
                                    });
                                  },
                                  title: Text('Pay via Visa / Master Card'),
                                  subtitle: Row(
                                    children: const <Widget>[
                                      Icon(
                                        Icons.payment,
                                        color: Colors.blue,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: Icon(
                                          FontAwesomeIcons.ccMastercard,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      Icon(
                                        FontAwesomeIcons.ccVisa,
                                        color: Colors.blue,
                                      ),
                                    ],
                                  ),
                                ),
                                RadioListTile(
                                  value: 3,
                                  groupValue: selectedValue,
                                  onChanged: (int? value) {
                                    setState(() {
                                      selectedValue = value!;
                                    });
                                  },
                                  title: Text('Pay via PayPal'),
                                  subtitle: Row(
                                    children: const [
                                      Icon(
                                        FontAwesomeIcons.paypal,
                                        color: Colors.blue,
                                      ),
                                      SizedBox(width: 15),
                                      Icon(
                                        FontAwesomeIcons.ccPaypal,
                                        color: Colors.blue,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  bottomSheet: Container(
                    color: Colors.grey.shade400,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: YellowButton(
                        label: 'Confirm ${totalPaid.toStringAsFixed(2)} USD',
                        width: 1,
                        onPressed: () {
                          if (selectedValue == 1) {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 100),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Text(
                                        'Pay At Home ${totalPrice.toStringAsFixed(2)} \$',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      YellowButton(
                                        label:
                                            'Confirm ${totalPaid.toStringAsFixed(2)}',
                                        onPressed: () {},
                                        width: 0.9,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } else if (selectedValue == 2) {
                            print('Pay via Master');
                          } else if (selectedValue == 3) {
                            print('Pay via Paypal');
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}