// ignore_for_file: use_build_context_synchronously, unnecessary_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gradal/customer_screens/customer_order.dart';
import 'package:gradal/customer_screens/wish_list.dart';
import 'package:gradal/main_screens/cart.dart';
import 'package:gradal/widgets/app_bar_widgets.dart';

import '../widgets/alert-dialog.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.documentId});

  final String documentId;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  CollectionReference customers =
      FirebaseFirestore.instance.collection('customers');

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: customers.doc(widget.documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            backgroundColor: Colors.grey.shade300,
            body: Stack(children: [
              Container(
                height: 230,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: const [
                    Colors.yellow,
                    Colors.brown,
                  ]),
                ),
              ),
              CustomScrollView(
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    centerTitle: true,
                    elevation: 0,
                    backgroundColor: Colors.white,
                    expandedHeight: 140,
                    flexibleSpace:
                        LayoutBuilder(builder: (context, constraint) {
                      return FlexibleSpaceBar(
                        title: AnimatedOpacity(
                          duration: Duration(milliseconds: 200),
                          opacity: constraint.biggest.height <= 120 ? 1 : 0,
                          child: Text(
                            'Account Information',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        background: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: const [
                              Colors.yellow,
                              Colors.brown,
                            ]),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 25,
                              left: 30,
                            ),
                            child: Row(
                              children: <Widget>[
                                CircleAvatar(
                                  radius: 50,
                                  backgroundImage: NetworkImage(
                                    data['profileimage'],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 25.0),
                                  child: Text(
                                    data['name'],//.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  SliverToBoxAdapter(
                      child: Column(
                    children: <Widget>[
                      Container(
                        height: 80,
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  bottomLeft: Radius.circular(30),
                                ),
                              ),
                              child: TextButton(
                                child: SizedBox(
                                  height: 40,
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  child: Center(
                                    child: Text(
                                      'Cart',
                                      style: TextStyle(
                                        color: Colors.yellow,
                                        fontSize: 24,
                                      ),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CartScreen(
                                        back: AppBarBackButton(),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Container(
                              color: Colors.yellow,
                              child: TextButton(
                                child: SizedBox(
                                  height: 40,
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  child: Center(
                                    child: Text(
                                      'Orders',
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 24,
                                      ),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CustomerOrder(),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(30),
                                  bottomRight: Radius.circular(30),
                                ),
                              ),
                              child: TextButton(
                                child: SizedBox(
                                  height: 40,
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  child: Center(
                                    child: Text(
                                      'wishlist',
                                      style: TextStyle(
                                        color: Colors.yellow,
                                        fontSize: 24,
                                      ),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WishListScreen(),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.grey.shade300,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 150,
                              child: Image(
                                image: AssetImage('images/inapp/logo.jpg'),
                              ),
                            ),
                            ProfileHeaderLabel(
                              headerLabel: '  Account Information  ',
                            ),
                            Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Container(
                                height: 260,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  children: [
                                    RepeatedListTitle(
                                      title: 'Email address',
                                      subTitle: data['email'].toString(),
                                      icon: Icons.email,
                                    ),
                                    YellowDivider(),
                                    RepeatedListTitle(
                                      title: 'Phone No.',
                                      subTitle: data['phone'].toString(),
                                      icon: Icons.phone,
                                    ),
                                    YellowDivider(),
                                    RepeatedListTitle(
                                      title: 'Address',
                                      subTitle: data['address'].toString(),
                                      icon: Icons.location_pin,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ProfileHeaderLabel(
                                headerLabel: '  Account Settings  '),
                            Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Container(
                                height: 260,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  children: [
                                    RepeatedListTitle(
                                      title: 'Edit Profile',
                                      icon: Icons.edit,
                                      onPressed: () {},
                                    ),
                                    YellowDivider(),
                                    RepeatedListTitle(
                                      title: 'Change Password',
                                      icon: Icons.lock,
                                      onPressed: () {},
                                    ),
                                    YellowDivider(),
                                    RepeatedListTitle(
                                      title: 'Logout',
                                      icon: Icons.logout,
                                      onPressed: () async {
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
                                            Future.delayed(Duration(microseconds: 100)).whenComplete(() {
                                              Navigator.pop(context);
                                              Navigator.pushReplacementNamed(
                                                  context, '/welcome_screen');
                                            });

                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
                ],
              ),
            ]),
          );

          //Text("Full Name: ${data['full_name']} ${data['last_name']}");
        }

        return const Center(
          child: CircularProgressIndicator(
            color: Colors.purple,
          ),
        );
      },
    );
  }
}

class YellowDivider extends StatelessWidget {
  const YellowDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Divider(color: Colors.yellow, thickness: 1),
    );
  }
}

class RepeatedListTitle extends StatelessWidget {
  const RepeatedListTitle({
    super.key,
    required this.title,
    this.subTitle = '',
    required this.icon,
    this.onPressed,
  });

  final String title;
  final String? subTitle;
  final IconData icon;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: ListTile(
        title: Text(title),
        subtitle: Text(subTitle!),
        leading: Icon(icon),
      ),
    );
  }
}

class ProfileHeaderLabel extends StatelessWidget {
  const ProfileHeaderLabel({super.key, required this.headerLabel});

  final String headerLabel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              color: Colors.grey,
              thickness: 1,
            ),
          ),
          Text(
            headerLabel,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              color: Colors.grey,
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}
