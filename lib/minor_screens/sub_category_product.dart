import 'package:flutter/material.dart';

import '../widgets/app_bar_widgets.dart';

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
        leading: AppBarBackButton(),
        title: AppBarTitle(title: subcategoryName),
        centerTitle: true,
      ),
      body: Center(
        child: Text(mencategoryName),
      ),
    );
  }
}