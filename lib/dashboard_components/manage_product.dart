import 'package:flutter/material.dart';
import 'package:gradal/widgets/app_bar_widgets.dart';

class ManageProduct extends StatelessWidget {
  const ManageProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: AppBarTitle(title: 'Manage Product'),
        centerTitle: true,
        leading: AppBarBackButton(),
      ),
    );
  }
}
