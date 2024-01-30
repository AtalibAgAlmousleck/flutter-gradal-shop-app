import 'package:flutter/material.dart';
import 'package:gradal/widgets/app_bar_widgets.dart';

class SupplierOrder extends StatelessWidget {
  const SupplierOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: AppBarTitle(title: 'Supplier Orders'),
        centerTitle: true,
        leading: AppBarBackButton(),
      ),
    );
  }
}
