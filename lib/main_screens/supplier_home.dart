import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradal/main_screens/category_screen.dart';
import 'package:gradal/main_screens/dashboard.dart';
import 'package:gradal/main_screens/home_screen.dart';
import 'package:gradal/main_screens/stores.dart';
import 'package:gradal/main_screens/upload_product_screen.dart';
import 'package:badges/badges.dart' as badges;

class SupplierHomeScreen extends StatefulWidget {
  const SupplierHomeScreen({super.key});

  @override
  State<SupplierHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<SupplierHomeScreen> {
  int _selectedIndex = 0;
  final List<Widget> _tabs = [
    HomeScreen(),
    CategoryScreen(),
    StoresScreen(),
    DashboardScreen(),
    UploadProductScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('sid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .where('deliverystatus', isEqualTo: 'preparing') //preparing
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Material(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
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
                BottomNavigationBarItem(
                    icon: Icon(Icons.search), label: 'Category'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.shop), label: 'Stores'),
                BottomNavigationBarItem(
                    icon: badges.Badge(
                      showBadge: snapshot.data!.docs.isEmpty ? false : true,
                      badgeStyle: badges.BadgeStyle(
                        badgeColor: Colors.yellow,
                        padding: EdgeInsets.all(4),
                      ),
                      badgeContent: Text(
                        snapshot.data!.docs.length.toString(),
                        style: TextStyle(fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                      child: Icon(Icons.dashboard,)),
                      label: 'Dashboard'
                    ),

                    //,
                BottomNavigationBarItem(
                    icon: Icon(Icons.upload), label: 'Upload'),
              ],
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          );
        });
  }
}
