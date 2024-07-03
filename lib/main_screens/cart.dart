import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gradal/providers/cart_provider.dart';
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
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.delete_forever,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          body: Consumer<Cart>(
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
                                padding: const EdgeInsets.all(6.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                          height: 30,
                                          decoration: BoxDecoration(
                                            //color: Colors.grey.shade600,
                                            borderRadius: BorderRadius.circular(25),
                                          ),
                                          child: Row(
                                            children: [
                                             product.quantity == 1 ? IconButton(
                                                onPressed: (){
                                                },
                                                icon: Icon(Icons.delete_forever, size: 18,),
                                              ) : IconButton(
                                               onPressed: (){
                                                 cart.decrement(product);
                                               },
                                               icon: Icon(FontAwesomeIcons.minus, size: 18,),
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
                                                icon: Icon(FontAwesomeIcons.plus, size: 18,),
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
          ),

          // Center(
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Text(
          //         'Your Cart Is Empty!',
          //         style: TextStyle(
          //           fontSize: 30.0,
          //         ),
          //       ),
          //       SizedBox(
          //         height: 50,
          //       ),
          //       Material(
          //         color: Colors.lightBlueAccent,
          //         borderRadius: BorderRadius.circular(25),
          //         child: MaterialButton(
          //           minWidth: MediaQuery.of(context).size.width * 0.6,
          //           onPressed: () {
          //             Navigator.canPop(context) ? Navigator.pop(context) :
          //             Navigator.pushReplacementNamed(context, '/customer_home');
          //           },
          //           child: Text(
          //             'Continue shopping',
          //             style: TextStyle(fontSize: 18, color: Colors.white),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),

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