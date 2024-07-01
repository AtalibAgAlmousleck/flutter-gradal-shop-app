import 'package:flutter/material.dart';
import 'package:gradal/categories/accessories_category.dart';
import 'package:gradal/categories/bags_category.dart';
import 'package:gradal/categories/beauty_category.dart';
import 'package:gradal/categories/electronics_category.dart';
import 'package:gradal/categories/garden_category.dart';
import 'package:gradal/categories/kids_categrory.dart';
import 'package:gradal/categories/men_category.dart';
import 'package:gradal/categories/shoes_category.dart';
import 'package:gradal/widgets/fake_search.dart';

import '../categories/women_category.dart';

List<ItemsData> items = [
  ItemsData(label: 'men'),
  ItemsData(label: 'women'),
  ItemsData(label: 'shoes'),
  // ItemsData(label: 'bags'),
  // ItemsData(label: 'electronic'),
  // ItemsData(label: 'accessories'),
  // ItemsData(label: 'garden'),
  ItemsData(label: 'kids'),
  ItemsData(label: 'beauty'),
];

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final PageController _pageController = PageController();

  //! reset the page to index = 0
  @override
  void initState() {
    for (var element in items) {
      element.isSelected = false;
    }
    setState(() {
      items[0].isSelected = true;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: FakeSearch(),
      ),
      body: Stack(
        children: [
          Positioned(bottom: 0, left: 0, child: sideNavigator(size)),
          Positioned(bottom: 0, right: 0, child: categoryView(size))
        ],
      ),
    );
  }

  Widget sideNavigator(Size size) {
    return SizedBox(
      height: size.height * 0.8,
      width: size.width * 0.2,
      //color: Colors.grey.shade300,
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              //! _pageController.jumpToPage(index);
              _pageController.animateToPage(
                index,
                duration: const Duration(microseconds: 1000),
                curve: Curves.bounceInOut,
              );
            },
            child: Container(
              color: items[index].isSelected == true
                  ? Colors.white
                  : Colors.grey.shade300,
              height: 100,
              child: Center(child: Text(items[index].label)),
            ),
          );
        },
      ),
    );
  }

  Widget categoryView(Size size) {
    return Container(
      height: size.height * 0.8,
      width: size.width * 0.8,
      color: Colors.white,
      child: PageView(
        controller: _pageController,
        onPageChanged: (value) {
          for (var element in items) {
            element.isSelected = false;
          }
          setState(() {
            items[value].isSelected = true;
          });
        },
        scrollDirection: Axis.vertical,
        children: const [
          MenCategroryScreen(),
          WomenCategroryScreen(),
          ShoesCategroryScreen(),
          // BagsCategory(),
          // ElectronicCategory(),
          // AccessoryCategory(),
          // GardenCategory(),
          KidsCategory(),
          BeautyCategory(),
        ],
      ),
    );
  }
}

class ItemsData {
  String label;
  bool isSelected;
  ItemsData({
    required this.label,
    this.isSelected = false,
  });
}
