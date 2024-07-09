import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradal/widgets/app_bar_widgets.dart';
import 'package:gradal/widgets/yellow_button.dart';

class SupplierBalance extends StatelessWidget {
  const SupplierBalance({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('sid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Material(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          //total of balance and out of stock item
          double totalPrice = 0.0;
          for (var item in snapshot.data!.docs) {
            totalPrice += item['orderqty'] * item['orderprice'];
          }

          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              title: AppBarTitle(title: 'Statics'),
              centerTitle: true,
              leading: AppBarBackButton(),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  StaticsModel(
                    label: 'Total Balance',
                    value: totalPrice,
                    decimal: 2,
                  ),
                  SizedBox(height: 100),
                  Container(
                    height: 45,
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                      color: Colors.pink,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: MaterialButton(
                      onPressed: () {},
                      child: Text('Get My Money !',
                      style: TextStyle(color: Colors.white,
                      fontSize: 20),),
                    ),
                  ),
                  SizedBox(height: 60),
                ],
              ),
            ),
          );
        });
  }
}

class StaticsModel extends StatelessWidget {
  const StaticsModel(
      {super.key,
        required this.label,
        required this.value,
        required this.decimal});

  final String label;
  final dynamic value;
  final int decimal;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 60,
          width: MediaQuery.of(context).size.width * 0.55,
          decoration: BoxDecoration(
            color: Colors.blueGrey,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: Center(
            child: Text(label.toUpperCase(),
                style: TextStyle(color: Colors.white, fontSize: 20)),
          ),
        ),
        //todo second container
        Container(
          height: 90,
          width: MediaQuery.of(context).size.width * 0.7,
          decoration: BoxDecoration(
            color: Colors.blueGrey.shade100,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
          ),
          child: AnimatedCounter(count: value, decimal: decimal),
        ),
      ],
    );
  }
}

class AnimatedCounter extends StatefulWidget {
  const AnimatedCounter(
      {super.key, required this.count, required this.decimal});

  final dynamic count;
  final dynamic decimal;

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animation = _controller;
    setState(() {
      _animation = Tween(begin: _animation.value, end: widget.count)
          .animate(_controller);
    });
    _controller.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Center(
          child: Text(
            _animation.value.toStringAsFixed(widget.decimal),
            style: TextStyle(
              color: Colors.pink,
              fontSize: 40,
              letterSpacing: 2,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      },
    );
  }
}
