import 'package:flutter/material.dart';
import 'package:gradal/widgets/app_bar_widgets.dart';

class SupplierBalance extends StatelessWidget {
  const SupplierBalance({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: AppBarTitle(title: 'Balance'),
        centerTitle: true,
        leading: AppBarBackButton(),
      ),
    );
  }
}
