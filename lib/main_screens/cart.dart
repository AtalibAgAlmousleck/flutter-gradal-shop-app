import 'package:flutter/material.dart';
import 'package:gradal/main_screens/customer_home_screen.dart';
import 'package:gradal/widgets/app_bar_widgets.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: AppBarTitle(title: 'Cart'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.delete_forever,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Your Cart Is Empty!',
              style: TextStyle(
                fontSize: 30.0,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Material(
              color: Colors.lightBlueAccent,
              borderRadius: BorderRadius.circular(25),
              child: MaterialButton(
                minWidth: MediaQuery.of(context).size.width * 0.6,
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CustomerHomeScreen(),
                    ),
                  );
                },
                child: Text(
                  'Continue shopping',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: const [
                Text(
                  'Total: \$ ',
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  '00.00',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            Container(
              height: 35,
              width: MediaQuery.of(context).size.width * 0.45,
              decoration: BoxDecoration(
                color: Colors.yellow,
                borderRadius: BorderRadius.circular(25),
              ),
              child: MaterialButton(
                onPressed: () {},
                child: Text('Check Out'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
