import 'package:flutter/material.dart';
import 'package:gradal/categories/women_category.dart';
import 'package:gradal/galleries/beauty_gallery.dart';
import 'package:gradal/galleries/kids_gallery.dart';
import 'package:gradal/galleries/men_gallery.dart';
import 'package:gradal/galleries/shoes_gallery.dart';
import 'package:gradal/galleries/women_gallery.dart';
import 'package:gradal/widgets/fake_search.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: Colors.blueGrey.shade100.withOpacity(0.5),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: FakeSearch(),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Colors.yellow,
            indicatorWeight: 8,
            isScrollable: true,
            tabs: const [
              RepeatedTab(label: 'Men'),
              RepeatedTab(label: 'Women'),
              RepeatedTab(label: 'Shoes'),
              // RepeatedTab(label: 'Bags'),
              // RepeatedTab(label: 'Electronics'),
              // RepeatedTab(label: 'Accessories'),
              // RepeatedTab(label: 'Garden'),
              RepeatedTab(label: 'Kids'),
              RepeatedTab(label: 'Beauty'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            MenGalleryScreen(),
            WomenGalleryScreen(),
            ShoesGalleryScreen(),
            // Center(child: Text('Bags screen')),
            // Center(child: Text('Electronics screen')),
            // Center(child: Text('Accessories screen')),
            // Center(child: Text('Garden screen')),
            KidsGalleryScreen(),
            BeautyGalleryScreen(),
          ],
        ),
      ),
    );
  }
}

class RepeatedTab extends StatelessWidget {
  const RepeatedTab({Key? key, required this.label}) : super(key: key);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Text(
        label,
        style: TextStyle(
          color: Colors.grey.shade600,
        ),
      ),
    );
  }
}
