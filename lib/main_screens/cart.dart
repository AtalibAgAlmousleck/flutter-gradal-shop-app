import 'package:flutter/material.dart';
import 'package:gradal/providers/cart_provider.dart';
import 'package:gradal/widgets/alert-dialog.dart';
import 'package:gradal/widgets/app_bar_widgets.dart';
import 'package:provider/provider.dart';

import '../minor_screens/place_order.dart';
import '../models/cart_item_modal.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key, this.back});

  final Widget? back;

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    double total = context.watch<Cart>().totalPrice;
    return Material(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey.shade200,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            leading: widget.back,
            title: AppBarTitle(title: 'Cart'),
            centerTitle: true,
            actions: [
              context.watch<Cart>().getItems.isEmpty
                  ? const SizedBox()
                  : IconButton(
                      onPressed: () {
                        MyAlertDialog.showMyDialog(
                            context: context,
                            title: 'Warning',
                            content:
                                'Are you sure you want to clear the cart ?',
                            tabNo: () {
                              Navigator.pop(context);
                            },
                            tabYes: () {
                              context.read<Cart>().clearCart();
                              Navigator.pop(context);
                            });
                      },
                      icon: Icon(
                        Icons.delete_forever,
                        color: Colors.black,
                      ),
                    ),
            ],
          ),
          body: context.watch<Cart>().getItems.isNotEmpty
              ? CartItems()
              : EmptyCart(),
          bottomSheet: Padding(
            padding: EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'Total: \$ ',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      //todo: calculate item together
                      total.toStringAsFixed(2),
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
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: MaterialButton(
                    onPressed: total == 0.0
                        ? null
                        : () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PlaceOrderScreen()));
                          },
                    child: const Text('CHECK OUT'),
                  ),
                ),
                // YellowButton(
                //   width: 0.45,
                //   label: 'Check Out',
                //   onPressed: total == 0.0 ? null : () {},
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EmptyCart extends StatelessWidget {
  const EmptyCart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Ops! Your Cart Is Empty!',
            style: TextStyle(fontSize: 30.0, fontStyle: FontStyle.italic),
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
                Navigator.canPop(context)
                    ? Navigator.pop(context)
                    : Navigator.pushReplacementNamed(context, '/customer_home');
              },
              child: Text(
                'Continue shopping',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CartItems extends StatelessWidget {
  const CartItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
      builder: (context, cart, child) {
        return ListView.builder(
          itemCount: cart.count,
          itemBuilder: (context, index) {
            final product = cart.getItems[index];
            return CartItemModal(
              product: product,
              cart: context.read<Cart>(),
            );
          },
        );
      },
    );
  }
}
