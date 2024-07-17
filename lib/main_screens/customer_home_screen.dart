import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradal/main_screens/cart.dart';
import 'package:gradal/main_screens/category_screen.dart';
import 'package:gradal/main_screens/home_screen.dart';
import 'package:gradal/main_screens/profile.dart';
import 'package:gradal/main_screens/stores.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  int _selectedIndex = 0;
  final List<Widget> _tabs = [
    HomeScreen(),
    CategoryScreen(),
    StoresScreen(),
    CartScreen(),
    const ProfileScreen(
      //documentId: FirebaseAuth.instance.currentUser!.uid,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        selectedItemColor: Colors.black,
        //unselectedItemColor: Colors.red,
        currentIndex: _selectedIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Category'),
          BottomNavigationBarItem(icon: Icon(Icons.shop), label: 'Stores'),
          BottomNavigationBarItem(
            icon: badges.Badge(
              showBadge: context.read<Cart>()
              .getItems.isEmpty ? false : true,
              badgeStyle: badges.BadgeStyle(
                badgeColor: Colors.yellow,
                padding: EdgeInsets.all(4),
              ),
              badgeContent: Text(
                context.watch<Cart>().getItems.length.toString(),
                style: TextStyle(fontSize: 16,
                    fontWeight: FontWeight.w400),
              ),
        child: Icon(Icons.shopping_cart),
      ),
              //Icon(Icons.shopping_cart),
              label: 'Cart',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
