import 'package:flutter/material.dart';
import 'package:gradal/widgets/app_bar_widgets.dart';

class CustomerOrder extends StatelessWidget {
  const CustomerOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: AppBarTitle(title: 'Customer Order'),
        centerTitle: true,
        leading: AppBarBackButton(),
      ),
    );
  }
}
