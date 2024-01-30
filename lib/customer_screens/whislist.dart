import 'package:flutter/material.dart';
import 'package:gradal/widgets/app_bar_widgets.dart';

class WhisListScreen extends StatelessWidget {
  const WhisListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: AppBarTitle(title: 'WishList'),
        centerTitle: true,
        leading: AppBarBackButton(),
      ),
    );
  }
}
