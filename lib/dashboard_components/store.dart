import 'package:flutter/material.dart';
import 'package:gradal/widgets/app_bar_widgets.dart';

class MyStore extends StatelessWidget {
  const MyStore({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: AppBarTitle(title: 'My Store'),
        centerTitle: true,
        leading: AppBarBackButton(),
      ),
    );
  }
}
