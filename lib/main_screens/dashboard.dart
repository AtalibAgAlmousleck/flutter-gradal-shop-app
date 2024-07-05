import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradal/dashboard_components/edit_business.dart';
import 'package:gradal/dashboard_components/manage_product.dart';
import 'package:gradal/dashboard_components/supplier_balance.dart';
import 'package:gradal/dashboard_components/supplier_order.dart';
import 'package:gradal/dashboard_components/supplier_static.dart';
import 'package:gradal/minor_screens/visit_store.dart';
import 'package:gradal/widgets/app_bar_widgets.dart';

import '../widgets/alert-dialog.dart';

List<String> labels = [
  'my store',
  'orders',
  'profile',
  'products',
  'balance',
  'statics',
];

List<IconData> icons = [
  Icons.store,
  Icons.shop_2_outlined,
  Icons.edit,
  Icons.settings,
  Icons.attach_money,
  Icons.show_chart,
];

List<Widget> pages = [
  //MyStore(),
  VisitStore(suppId: FirebaseAuth.instance.currentUser!.uid),
  SupplierOrder(),
  EditBusiness(),
  ManageProduct(),
  SupplierBalance(),
  SupplierStatic()
];

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: AppBarTitle(title: 'Dashboard'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              //Navigator.pushReplacementNamed(context, '/welcome_screen');
              MyAlertDialog.showMyDialog(
                context: context,
                title: 'Log Out',
                content: 'Are you sure you want to log out ?',
                tabNo: () {
                  Navigator.pop(context);
                },
                tabYes: () async {
                  await FirebaseAuth.instance
                      .signOut();
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(
                      // ignore: use_build_context_synchronously
                      context, '/welcome_screen');
                },
              );
            },
            icon: Icon(
              Icons.logout,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: GridView.count(
          mainAxisSpacing: 25,
          crossAxisSpacing: 25,
          crossAxisCount: 2,
          children: List.generate(
            6,
            (index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => pages[index]),
                  );
                },
                child: Card(
                  elevation: 25,
                  shadowColor: Colors.purpleAccent.shade200,
                  color: Colors.blueGrey.withOpacity(0.7),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(
                        icons[index],
                        color: Colors.yellowAccent,
                        size: 50,
                      ),
                      Text(
                        labels[index].toUpperCase(),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.yellowAccent,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

void navigateToScreens(BuildContext context, Widget screen) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return screen;
  }));
}
