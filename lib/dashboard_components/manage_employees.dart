import 'package:flutter/material.dart';
import 'package:gradal/widgets/app_bar_widgets.dart';

class ManageEmployees extends StatelessWidget {
  const ManageEmployees({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: AppBarTitle(title: 'Manage Employees'),
        centerTitle: true,
        leading: AppBarBackButton(),
      ),
    );
  }
}
