import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gradal/galleries/shoes_gallery.dart';
import 'package:gradal/minor_screens/hot_deals.dart';
import 'package:gradal/minor_screens/sub_category_product.dart';

enum Offer {
  watches,
  shoes,
  sale,
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  Timer? countDownTimer;
  int seconds = 5;
  List<int> discountList = [];
  int? maxDiscount;

  @override
  void initState() {
    startTimer();
    getDiscount();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void startTimer() {
    countDownTimer = Timer.periodic(Duration(seconds: 1), (time) {
      setState(() {
        seconds--;
      });
      if (seconds < 0) {
        stopTimer();
        Navigator.pushReplacementNamed(context, '/customer_home');
      }
    });
  }

  void stopTimer() {
    countDownTimer!.cancel();
  }

  void getDiscount() {
    FirebaseFirestore.instance.collection('products').get()
        .then((QuerySnapshot querySnapshot){
      for (var doc in querySnapshot.docs) {
        discountList.add(doc['discount']);
      }
    }).whenComplete(() => setState(() {
      maxDiscount = discountList.reduce(max);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(0),
              child: GestureDetector(
                onTap: () {
                  stopTimer();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HotDeals(
                        fromOnBoarding: true,
                        maxDiscount: maxDiscount!.toString(),
                      ),
                    ), (Route route) => false,
                  );
                  // Navigator.pushAndRemoveUntil(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => ShoesGalleryScreen(
                  //       fromOnBoarding: true,
                  //     ),
                  //   ), (Route route) => false,
                  // );
                  // Navigator.pushAndRemoveUntil(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => SubCategoryProduct(
                  //       fromOnBoarding: true,
                  //       subcategoryName: 'girls top',
                  //       mainCategoryName: 'kids',
                  //     ),
                  //   ), (Route route) => false,
                  // );
                },
                child: Image.asset(
                  'images/onboard/sale.JPEG',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            top: 60,
            right: 30,
            child: Container(
              height: 35,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.grey.shade600.withOpacity(0.5),
                borderRadius: BorderRadius.circular(15),
              ),
              child: MaterialButton(
                onPressed: () {
                  stopTimer();
                  Navigator.pushReplacementNamed(context, '/customer_home');
                },
                child: seconds < 1 ? Text('Skip') : Text('Skip $seconds'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
