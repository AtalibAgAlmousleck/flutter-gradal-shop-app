import 'package:flutter/material.dart';
import 'package:gradal/authentication/customer_login.dart';
import 'package:gradal/authentication/customer_signup.dart';
import 'package:gradal/authentication/supplier_login.dart';
import 'package:gradal/authentication/supplier_signup.dart';
import 'package:gradal/main_screens/customer_home_screen.dart';
import 'package:gradal/main_screens/supplier_home.dart';
import 'package:gradal/main_screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gradal/providers/cart_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => Cart())
        ],
          child: MyApp()
      )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //home: WelcomeScreen(),
      initialRoute: '/welcome_screen',
      routes: {
        '/welcome_screen': (content) => WelcomeScreen(),
        '/customer_home': (context) => CustomerHomeScreen(),
        '/supplier_home': (context) => SupplierHomeScreen(),
        '/customer_signup': (context) => CustomerRegister(),
        '/customer_login': (context) => CustomerLogin(),
        '/supplier_signup': (context) => SupplierSignup(),
        '/supplier_login': (context) => SupplierLogin(),
      },
    );
  }
}
