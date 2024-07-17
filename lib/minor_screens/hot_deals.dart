import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gradal/widgets/app_bar_widgets.dart';
import '../models/products_model.dart';

class HotDealsScreen extends StatefulWidget {
  final bool fromOnBoarding;
  final String maxDiscount;

  const HotDealsScreen(
      {Key? key, this.fromOnBoarding = false, required this.maxDiscount})
      : super(key: key);

  @override
  State<HotDealsScreen> createState() => _HotDealsScreenState();
}

class _HotDealsScreenState extends State<HotDealsScreen> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> productsStream = FirebaseFirestore.instance
        .collection('products')
        .where('discount', isNotEqualTo: 0)
        .snapshots();

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        leading: widget.fromOnBoarding
            ? IconButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/customer_home');
                },
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.yellow,
                ),
              )
            : const YellowBarBackButton(),
        title: SizedBox(
          height: 160,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 70,
                child: DefaultTextStyle(
                  style: const TextStyle(
                      height: 1.2,
                      color: Colors.yellowAccent,
                      fontSize: 30,
                      fontFamily: 'PressStart2P'),
                  child: AnimatedTextKit(
                    totalRepeatCount: 5,
                    animatedTexts: [
                      TypewriterAnimatedText('Hot Deals ',
                          speed: const Duration(milliseconds: 60), cursor: '|'),
                      TypewriterAnimatedText(
                          'up to ${widget.maxDiscount} % off ',
                          speed: const Duration(milliseconds: 60),
                          cursor: '|',
                          textStyle: const TextStyle(fontSize: 20)),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            height: 60,
            color: Colors.black,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: StreamBuilder<QuerySnapshot>(
                stream: productsStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text('Something went wrong'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                        child: Text(
                      'This category \n\n has no items yet !',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 26,
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Acme',
                          letterSpacing: 1.5),
                    ));
                  }

                  return Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: StaggeredGrid.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      children: List.generate(snapshot.data?.docs.length ?? 0,
                          (index) {
                        var doc = snapshot.data!.docs[index];
                        return StaggeredGridTile.fit(
                          crossAxisCellCount: 1,
                          child: ProductModel(
                            products: doc,
                          ),
                        );
                      }),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
