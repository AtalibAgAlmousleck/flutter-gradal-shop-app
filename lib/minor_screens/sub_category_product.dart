import 'package:flutter/material.dart';

class SubCategoryProduct extends StatelessWidget {
  const SubCategoryProduct({
    super.key,
    required this.subcategoryName,
    required this.mencategoryName,
  });
  final String subcategoryName;
  final String mencategoryName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          subcategoryName,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Text(mencategoryName),
      ),
    );
  }
}
