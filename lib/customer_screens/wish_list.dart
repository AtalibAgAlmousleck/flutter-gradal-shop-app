import 'package:flutter/material.dart';
import 'package:gradal/providers/wish_list_provider.dart';
import 'package:gradal/widgets/app_bar_widgets.dart';
import 'package:provider/provider.dart';

class WishListScreen extends StatefulWidget {
  const WishListScreen({super.key});

  @override
  State<WishListScreen> createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey.shade200,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            //leading: widget.back,
            title: AppBarTitle(title: 'WishList'),
            centerTitle: true,
            // actions: [
            //   context.watch<Cart>().getItems.isEmpty ?
            //   const SizedBox() :
            //   IconButton(
            //     onPressed: () {
            //       MyAlertDialog.showMyDialog(
            //           context: context,
            //           title: 'Warning',
            //           content: 'Are you sure you want to clear the cart ?',
            //           tabNo: () {
            //             Navigator.pop(context);
            //           },
            //           tabYes: () {
            //             context.read<Cart>().clearCart();
            //             Navigator.pop(context);
            //           }
            //       );
            //
            //     },
            //     icon: Icon(
            //       Icons.delete_forever,
            //       color: Colors.black,
            //     ),
            //   ),
            // ],
          ),
          body: context.watch<WishList>().getWishList.isNotEmpty ?
          WishItems() :
          EmptyWishList(),
        ),
      ),
    );
  }
}

class EmptyWishList extends StatelessWidget {
  const EmptyWishList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            'Ops! Your WishList Is Empty!',
            style: TextStyle(
                fontSize: 30.0,
                fontStyle: FontStyle.italic
            ),
          ),
        ],
      ),
    );
  }
}

class WishItems extends StatelessWidget {
  const WishItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<WishList>(
      builder: (context, wish, child) {
        return ListView.builder(
          itemCount: wish.count,
          itemBuilder: (context, index) {
            final product = wish.getWishList[index];
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
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(

                                        onPressed: () {
                                          context.read<WishList>()
                                              .removeItem(product);
                                        },
                                        icon: Icon(Icons.delete_forever),
                                      ),
                                      SizedBox(width: 10),
                                      IconButton(
                                        onPressed: () {},
                                        icon: Icon(Icons.add_shopping_cart),
                                      ),
                                    ],
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