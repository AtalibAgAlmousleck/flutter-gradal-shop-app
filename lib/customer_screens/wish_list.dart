import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gradal/providers/wish_list_provider.dart';
import 'package:gradal/widgets/app_bar_widgets.dart';
import 'package:provider/provider.dart';

import '../models/wish_list_modal.dart';
import '../widgets/alert-dialog.dart';

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
            actions: [
              context.watch<WishList>().getWishList.isEmpty ?
              const SizedBox() :
              IconButton(
                onPressed: () {
                  MyAlertDialog.showMyDialog(
                      context: context,
                      title: 'Warning',
                      content: 'Are you sure you want to clear your wishlist ?',
                      tabNo: () {
                        Navigator.pop(context);
                      },
                      tabYes: () {
                        context.read<WishList>().clearWishList();
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
            return WishListModal(product: product);
          },
        );
      },
    );
  }
}

