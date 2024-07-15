import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gradal/providers/cart_provider.dart';
import 'package:gradal/providers/strip_id.dart';
import 'package:gradal/widgets/app_bar_widgets.dart';
import 'package:gradal/widgets/yellow_button.dart';
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({
    super.key,
    required this.name,
    required this.phone,
    required this.address,
  });

  final String name;
  final String phone;
  final String address;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int selectedValue = 1;
  late String orderId;
  CollectionReference customers =
      FirebaseFirestore.instance.collection('customers');

  void showProgress() {
    ProgressDialog progressDialog = ProgressDialog(context: context);
    progressDialog.show(
        max: 100,
        msg: 'Please wait payment progress',
        progressBgColor: Colors.red);
  }

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
                  //todo button here
                  bottomSheet: Container(
                    color: Colors.grey.shade400,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: YellowButton(
                        label: 'Confirm ${totalPaid.toStringAsFixed(2)} USD',
                        width: 1,
                        onPressed: () async {
                          if (selectedValue == 1) {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 100),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Text(
                                        'Pay At Home ${totalPrice.toStringAsFixed(2)} \$',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      YellowButton(
                                        label:
                                            'Confirm ${totalPaid.toStringAsFixed(2)}',
                                        onPressed: () async {
                                          showProgress();
                                          for (var item in context
                                              .read<Cart>()
                                              .getItems) {
                                            CollectionReference orderReference =
                                                FirebaseFirestore.instance
                                                    .collection('orders');
                                            orderId = Uuid().v4();
                                            await orderReference
                                                .doc(orderId)
                                                .set({
                                              //customer
                                              'cid': data['cid'],
                                              'custname': widget.name,
                                              'email': data['email'],
                                              'address': widget.address,
                                              'phone': widget.phone,
                                              'profilemage':
                                                  data['profileimage'],

                                              //supplier
                                              'sid': item.suppId,

                                              // products
                                              'proid': item.documentId,
                                              'orderid': orderId,
                                              'ordername': item.name,

                                              'orderimage':
                                                  item.imagesUrl.first,
                                              'orderqty': item.quantity,
                                              'orderprice':
                                                  item.quantity * item.price,

                                              // delivery status
                                              'deliverystatus': 'preparing',
                                              'deliverydate': '',
                                              'orderdate': DateTime.now(),
                                              'paymentstatus':
                                                  'cash on delivery',
                                              'orderreview': false,
                                            }).whenComplete(() async {
                                              await FirebaseFirestore.instance
                                                  .runTransaction(
                                                      (transaction) async {
                                                DocumentReference documentRef =
                                                    FirebaseFirestore.instance
                                                        .collection('products')
                                                        .doc(item.documentId);
                                                DocumentSnapshot snapshot2 =
                                                    await transaction
                                                        .get(documentRef);
                                                transaction.update(
                                                    documentRef, {
                                                  'instock':
                                                      snapshot2['instock'] -
                                                          item.quantity
                                                });
                                              });
                                            });
                                          }
                                          await Future.delayed(
                                                  Duration(microseconds: 100))
                                              .whenComplete(() {
                                            context.read<Cart>().clearCart();
                                            Navigator.popUntil(
                                                context,
                                                ModalRoute.withName(
                                                    '/customer_home'));
                                          });
                                        },
                                        width: 0.9,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } else if (selectedValue == 2) {
                            await makePayment();
                          } else if (selectedValue == 3) {}
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

  // // Define your test and live secret keys
  // static const String _stripeTestSecretKey =
  //     'sk_test_51PbXRnRplWIBmGj9EeuL9bcAS9Zb7HMFe1nSrG6KkQWWVIVQeYV1xnltMiE9OWIme8RcqjO8XZDkzmqZZORLQAgl00CRpSjl1m';
  // static const String _stripeLiveSecretKey =
  //     'sk_live_your_live_secret_key_here';
  //
  // // Set the mode here: true for test mode, false for live mode
  // static const bool _isTestMode = true;
  //
  // static String get _stripeSecretKey =>
  //     _isTestMode ? _stripeTestSecretKey : _stripeLiveSecretKey;

  Map<String, dynamic>? paymentIntentData;

  // Future<void> makePayment() async {
  //   paymentIntentData = await createPaymentIntent();
  //   if (paymentIntentData != null) {
  //     await Stripe.instance.initPaymentSheet(
  //       paymentSheetParameters: SetupPaymentSheetParameters(
  //         paymentIntentClientSecret: paymentIntentData!['client_secret'],
  //         merchantDisplayName: 'Almousleck',
  //         applePay: const PaymentSheetApplePay(
  //           merchantCountryCode: 'US',
  //         ),
  //         googlePay: const PaymentSheetGooglePay(
  //           merchantCountryCode: 'US',
  //           testEnv: _isTestMode, // This should be set according to the mode
  //         ),
  //       ),
  //     );
  //
  //     await displayPaymentSheet();
  //   } else {
  //     print('Failed to create payment intent');
  //   }
  // }
  //
  // Future<Map<String, dynamic>> createPaymentIntent() async {
  //   Map<String, dynamic> body = {
  //     'amount': '1200',
  //     'currency': 'USD',
  //     'payment_method_types[]': 'card',
  //   };
  //
  //   final response = await http.post(
  //     Uri.parse('https://api.stripe.com/v1/payment_intents'),
  //     body: body,
  //     headers: {
  //       'Authorization': 'Bearer $_stripeSecretKey',
  //       'Content-Type': 'application/x-www-form-urlencoded',
  //     },
  //   );
  //
  //   if (response.statusCode == 200) {
  //     return jsonDecode(response.body);
  //   } else {
  //     print('Failed to create payment intent: ${response.body}');
  //     throw Exception('Failed to create payment intent');
  //   }
  // }
  //
  // Future<void> displayPaymentSheet() async {
  //   try {
  //     await Stripe.instance.presentPaymentSheet();
  //     print('Payment successful');
  //   } on StripeException catch (e) {
  //     print('Error presenting payment sheet: $e');
  //   } catch (e) {
  //     print('Unknown error: $e');
  //   }
  // }

  Future<void> makePayment() async {
    try {
      paymentIntentData = await createPaymentInitNet();
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentData!['client_secret'],
          applePay: const PaymentSheetApplePay(
            merchantCountryCode: 'US',
          ),
          googlePay: const PaymentSheetGooglePay(
            merchantCountryCode: 'us',
            testEnv: true,
          ),
          //testEnv: true,
          merchantDisplayName: 'Almousleck',
          //merchantCountryCode: 'us'
        ),
      );
      await displayPaymentSheet();
    } catch (e) {
      print(e);
    }
  }

  createPaymentInitNet() async {
    try {
      Map<String, dynamic> body = {
        'amount': '1200',
        'currency': 'USD',
        'payment_method_types[]': 'card'
      };

      final response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization': 'Bearer $stripeSecretKey',
            'content_type': 'application/x-www-form-urlencoded'
          });
      return jsonDecode(response.body);
    } catch (e) {
      print(e);
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
    } catch (e) {
      print(e);
    }
  }
}
