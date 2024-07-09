import 'package:flutter/material.dart';
import 'package:gradal/dashboard_components/delivered_order.dart';
import 'package:gradal/dashboard_components/preparing_oder.dart';
import 'package:gradal/dashboard_components/shipping_order.dart';
import 'package:gradal/widgets/app_bar_widgets.dart';

class SupplierOrder extends StatelessWidget {
  const SupplierOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: AppBarBackButton(),
          title: AppBarTitle(title: 'Manage Orders'),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Colors.blue,
            indicatorWeight: 8,
            tabs: const [
              RepeatedTab(label: 'Preparing'),
              RepeatedTab(label: 'Shipping'),
              RepeatedTab(label: 'Delivered'),
            ],
          ),
        ),
        body: TabBarView(
          children: const [
            PreparingOder(),
            ShippingOrder(),
            DeliveredOrder()
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
      child: Center(
        child: Text(
          label, style: TextStyle(
          color: Colors.grey
        ),
        ),
      ),
    );
  }
}

