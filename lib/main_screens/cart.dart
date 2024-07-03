import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gradal/providers/cart_provider.dart';
import 'package:gradal/widgets/alert-dialog.dart';
import 'package:gradal/widgets/app_bar_widgets.dart';
import 'package:provider/provider.dart';

import '../widgets/yellow_button.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key, this.back});

  final Widget? back;

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
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
              context.watch<Cart>().getItems.isEmpty ?
                  const SizedBox() :
              IconButton(
                onPressed: () {
                  MyAlertDialog.showMyDialog(
                      context: context,
                      title: 'Warning',
                      content: 'Are you sure you want to clear the cart ?',
                      tabNo: () {
                        Navigator.pop(context);
                      },
                      tabYes: () {
                        context.read<Cart>().clearCart();
                        Navigator.pop(context);
                      }
                  );

                },
                icon: Icon(
                  Icons.delete_forever,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          body: context.watch<Cart>().getItems.isNotEmpty ?
          CartItems() :
          EmptyCart(),
          bottomSheet: Padding(
            padding: const EdgeInsets.all(24),
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
                YellowButton(
                  width: 0.45,
                  label: 'Check Out',
                  onPressed: () {},
                )
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
            style: TextStyle(
              fontSize: 30.0,
              fontStyle: FontStyle.italic
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
                Navigator.canPop(context) ? Navigator.pop(context) :
                Navigator.pushReplacementNamed(context, '/customer_home');
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
            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: Card(
                child: SizedBox(
                  height: 100,
                  child: Row(
                    children: [
                      SizedBox(
                        height: 100, width: 120,
                        child: Image.network(
                          product.imagesUrl.first,
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(product.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                //color: Colors.grey.shade700
                              ),),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(product.price.toStringAsFixed(2),
                                  style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),),
                                  Container(
                                    //width: 70,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: Row(
                                      children: [
                                       product.quantity == 1 ? IconButton(
                                          onPressed: (){
                                            cart.removeItem(product);
                                          },
                                          icon: Icon(Icons.delete_forever, size: 18,),
                                        ) : IconButton(
                                         onPressed: (){
                                           cart.decrement(product);
                                         },
                                         icon: Icon(FontAwesomeIcons.circleMinus, size: 18,),
                                       ),
                                        Text(
                                          product.quantity.toString(),
                                          style: product.quantity ==
                                             product.bigQuantity ? TextStyle(
                                              fontSize: 20, color: Colors.red)
                                          : TextStyle(fontSize: 20),
                                        ),
                                        IconButton(
                                          onPressed: product.quantity ==
                                                  product.bigQuantity ? null : (){
                                            cart.increment(product);

                                          },
                                          icon: Icon(FontAwesomeIcons.circlePlus, size: 18,),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],

                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}