import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SupplierOrderModal extends StatelessWidget {
  const SupplierOrderModal({super.key, required this.order});

  final dynamic order;

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
                    child: Image.network(order['orderimage']),
                  ),
                ),
                //SizedBox(width: 15),
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        order['ordername'],
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
                                (order['orderprice'].toStringAsFixed(2))),
                            Text(('x ') + (order['orderqty'].toString())),
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
                order['deliverystatus'],
              ),
            ],
          ),
          children: <Widget>[
            Container(
              height: 230,
              width: double.infinity,
              decoration: BoxDecoration(
                //todo: color is here
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      ('Name: ') + (order['custname']),
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      ('Phone: ') + (order['phone']),
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      ('email: ') + (order['email']),
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      ('Address: ') + (order['address']),
                      style: TextStyle(fontSize: 15),
                    ),
                    Row(
                      children: [
                        Text(
                          ('Payment Status: '),
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          (order['paymentstatus']),
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
                          (order['deliverystatus']),
                          style: TextStyle(fontSize: 15, color: Colors.green),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          ('Order Date: '),
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          (DateFormat('yyyy-MM-dd')
                              .format(order['orderdate'].toDate())
                              .toString()),
                          style: TextStyle(fontSize: 15, color: Colors.green),
                        ),
                      ],
                    ),
                    //todo change delivery state
                   order['deliverystatus'] == 'delivered' ?
                   const Text('This order has been already delivered.') : Row(
                      children: [
                        Text(
                          ('Change Delivery State To: '),
                          style: TextStyle(fontSize: 15),
                        ),
                      order['deliverystatus'] == 'preparing' ?  TextButton(
                          onPressed: () {
                            // DatePicker.showDatePicker(context,
                            //   minTime: DateTime.now(),
                            //   maxTime: DateTime.now().add(
                            //     const Duration(days: 365)
                            //   ),
                            //   onConfirm: (date) async {
                            //   await FirebaseFirestore.instance.collection('orders')
                            //   .doc(order['orderid']).update({
                            //     'deliverystatus': 'shipping',
                            //     'deliverydate': date,
                            //   });
                            //   }
                            // );
                            _selectDateAndUpdateStatus(context, order['orderid']);
                          },
                          child: Text('shipping ?'),
                        ) :
                      TextButton(
                        onPressed: () async {
                          await FirebaseFirestore.instance.collection('orders')
                          .doc(order['orderid']).update({
                            'deliverystatus': 'delivered',
                          });
                          //_updateDeliveryStatus(context, order['orderid']);
                        },
                        child: Text('delivered ?'),
                      )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  void _selectDateAndUpdateStatus(BuildContext context, String orderId) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (selectedDate != null) {
      await FirebaseFirestore.instance.collection('orders').doc(orderId).update({
        'deliverystatus': 'shipping',
        'deliverydate': selectedDate,
      });
    }
  }

  void _updateDeliveryStatus(BuildContext context, String orderId) async {
    await FirebaseFirestore.instance.collection('orders').doc(orderId).update({
      'deliverystatus': 'delivered',
    });
  }
}
