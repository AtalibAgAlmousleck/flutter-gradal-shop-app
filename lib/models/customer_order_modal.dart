import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradal/widgets/yellow_button.dart';
import 'package:intl/intl.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CustomerOrderModal extends StatefulWidget {
  const CustomerOrderModal({super.key, required this.order});

  final dynamic order;

  @override
  State<CustomerOrderModal> createState() => _CustomerOrderModalState();
}

class _CustomerOrderModalState extends State<CustomerOrderModal> {
  late double rate;
  late String comment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue),
          borderRadius: BorderRadius.circular(15),
        ),
        child: ExpansionTile(
          title: Container(
            constraints: BoxConstraints(maxHeight: 80),
            width: double.infinity,
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Container(
                    constraints: BoxConstraints(
                      maxHeight: 80,
                      maxWidth: 80,
                    ),
                    child: Image.network(widget.order['orderimage']),
                  ),
                ),
                //SizedBox(width: 15),
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        widget.order['ordername'],
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w600),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(('\$ ') +
                                (widget.order['orderprice']
                                    .toStringAsFixed(2))),
                            Text(
                                ('x ') + (widget.order['orderqty'].toString())),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('See More...'),
              Text(
                widget.order['deliverystatus'],
              ),
            ],
          ),
          children: <Widget>[
            Container(
              //height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                //todo: color is here
                color: widget.order['deliverystatus'] == 'delivered'
                    ? Colors.brown.withOpacity(0.2)
                    : Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      ('Name: ') + (widget.order['custname']),
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      ('Phone: ') + (widget.order['phone']),
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      ('email: ') + (widget.order['email']),
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      ('Address: ') + (widget.order['address']),
                      style: TextStyle(fontSize: 15),
                    ),
                    Row(
                      children: [
                        Text(
                          ('Payment Status: '),
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          (widget.order['paymentstatus']),
                          style: TextStyle(fontSize: 15, color: Colors.purple),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          ('Delivery Status: '),
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          (widget.order['deliverystatus']),
                          style: TextStyle(fontSize: 15, color: Colors.green),
                        ),
                      ],
                    ),
                    widget.order['deliverystatus'] == 'shipping'
                        ? Text(
                            ('Estimated Delivery: ') +
                                (DateFormat('yyy-MM-dd').format(
                                        widget.order['deliverydate'].toDate()))
                                    .toString(),
                            style: TextStyle(fontSize: 15),
                          )
                        : const Text(''),
                    widget.order['deliverystatus'] == 'delivered' &&
                            widget.order['orderreview'] == false
                        ? TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => Center(
                                  child: Material(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 20),
                                        child: Column(
                                          //mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            RatingBar.builder(
                                              initialRating: 1,
                                              minRating: 1,
                                              allowHalfRating: true,
                                              itemBuilder: (context, _) {
                                                return Icon(Icons.star,
                                                    color: Colors.amber);
                                              },
                                              onRatingUpdate: (value) {
                                                rate = value;
                                              },
                                            ),
                                            SizedBox(height: 15),
                                            TextField(
                                              decoration: InputDecoration(
                                                hintText: 'Enter your review',
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.grey,
                                                      width: 1),
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Colors.amber,
                                                    width: 2,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                              ),
                                              onChanged: (value) {
                                                comment = value;
                                              },
                                            ),
                                            SizedBox(height: 15),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                YellowButton(
                                                  label: 'Cancel',
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  width: 0.3,
                                                ),
                                                SizedBox(width: 20),
                                                YellowButton(
                                                  label: 'Publish',
                                                  onPressed: () async {
                                                    CollectionReference
                                                        collectionReference =
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'products')
                                                            .doc(widget
                                                                .order['proid'])
                                                            .collection(
                                                                'review');
                                                    //
                                                    await collectionReference
                                                        .doc(FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .uid)
                                                        .set({
                                                      'name': widget.order['custname'],
                                                      'email': widget.order['email'],
                                                      'rate': rate,
                                                      'comment': comment,
                                                      'profileimage': widget.order['profilemage']
                                                    }).whenComplete(() async {
                                                      await FirebaseFirestore.instance.runTransaction((transaction) async {
                                                        DocumentReference documentRef = FirebaseFirestore.instance.collection('orders')
                                                        .doc(widget.order['orderid']);
                                                        transaction.update(documentRef, {
                                                          'orderreview': true
                                                        });
                                                      });
                                                    });
                                                    await Future.delayed(Duration(microseconds: 100))
                                                    .whenComplete(() => Navigator.pop(context),);
                                                  },
                                                  width: 0.3,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              'Write review',
                              style: TextStyle(color: Colors.blue),
                            ),
                          )
                        : const Text(''),
                    widget.order['deliverystatus'] == 'delivered' &&
                            widget.order['orderreview'] == true
                        ? Row(
                            children: const <Widget>[
                              Icon(
                                Icons.check,
                                color: Colors.blue,
                              ),
                              Text(
                                'Review Added',
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.blue),
                              ),
                            ],
                          )
                        : const Text(''),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
