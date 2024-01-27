import 'package:flutter/material.dart';
import 'package:gradal/minor_screens/serach_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 9,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SearchScreen()));
            },
            child: Container(
              height: 35,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.yellow, width: 1.4),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        'What are you looking for?',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 32,
                    width: 75,
                    decoration: BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Center(
                      child: Text(
                        'Search',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          centerTitle: true,
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: Colors.yellow,
            indicatorWeight: 8,
            tabs: const [
              RepeatedTab(label: 'Men'),
              RepeatedTab(label: 'Women'),
              RepeatedTab(label: 'Shoes'),
              RepeatedTab(label: 'Bags'),
              RepeatedTab(label: 'Electronics'),
              RepeatedTab(label: 'Accessories'),
              RepeatedTab(label: 'Home & Garden'),
              RepeatedTab(label: 'Kids'),
              RepeatedTab(label: 'Beauty'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Center(child: Text('Men screen')),
            Center(child: Text('Women screen')),
            Center(child: Text('Shoes screen')),
            Center(child: Text('Bags screen')),
            Center(child: Text('Electronics screen')),
            Center(child: Text('Accessories screen')),
            Center(child: Text('Home & Garden screen')),
            Center(child: Text('Kids screen')),
            Center(child: Text('Beauty screen')),
          ],
        ),
      ),
    );
  }
}

class RepeatedTab extends StatelessWidget {
  const RepeatedTab({super.key, required this.label});

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
