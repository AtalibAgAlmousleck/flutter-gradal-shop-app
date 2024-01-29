import 'package:flutter/material.dart';
import 'package:gradal/widgets/app_bar_widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.red,
            expandedHeight: 140,
            flexibleSpace: LayoutBuilder(builder: (context, constraint) {
              return FlexibleSpaceBar(
                title: AnimatedOpacity(
                  duration: Duration(milliseconds: 200),
                  opacity: constraint.biggest.height <= 120 ? 1 : 0,
                  child: Text('Account'),
                ),
                centerTitle: true,
                background: Container(
                  decoration: BoxDecoration(
                    //gradient: Gradient
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
