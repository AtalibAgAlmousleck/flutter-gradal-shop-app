import 'package:flutter/material.dart';
import 'package:gradal/authentication/customer_login.dart';
import 'package:gradal/authentication/customer_signup.dart';
import 'package:gradal/authentication/supplier_login.dart';
import 'package:gradal/authentication/supplier_signup.dart';
import 'package:gradal/main_screens/customer_home_screen.dart';
import 'package:gradal/main_screens/onboarding_screen.dart';
import 'package:gradal/main_screens/supplier_home.dart';
import 'package:gradal/main_screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gradal/providers/cart_provider.dart';
import 'package:gradal/providers/employee_provider.dart';
import 'package:gradal/providers/id_provider.dart';
import 'package:gradal/providers/strip_id.dart';
import 'package:gradal/providers/wish_list_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = stripePublishableKey;
  Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings();

  //WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => Cart()),
      ChangeNotifierProvider(create: (_) => WishList()),
      ChangeNotifierProvider(create: (_) => EmployeeProvider()),
      ChangeNotifierProvider(create: (_) => IdProvider()),
    ], child: MyApp()),
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
        '/onboarding_screen': (context) => const Onboardingscreen(),
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
