import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../widgets/auth_widget.dart';
import '../widgets/snack_bar.dart';

class CustomerLogin extends StatefulWidget {
  const CustomerLogin({Key? key}) : super(key: key);

  @override
  State<CustomerLogin> createState() => _CustomerLoginState();
}

class _CustomerLoginState extends State<CustomerLogin> {
  CollectionReference customers =
      FirebaseFirestore.instance.collection('customers');

  Future<bool> checkIfDocExists(String docId) async {
    try {
      var doc = await customers.doc(docId).get();
      return doc.exists;
    } catch (e) {
      print(e);
      return false;
    }
  }

  bool dockExists = false;

  // setUserId(User user) {
  //   context.read<IdProvider>().setCustomerId(user);
  // }

  // google sign in
  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
    return await FirebaseAuth.instance
        .signInWithCredential(credential)
        .whenComplete(() async {
      User user = FirebaseAuth.instance.currentUser!;
      dockExists = await checkIfDocExists(user.uid);

      dockExists == false ?
      await customers.doc(user.uid).set({
        'name': user.displayName,
        'email': user.email,
        'profileimage': user.photoURL,
        'phone': '',
        'address': '',
        'cid': user.uid,
      }).then(
          (value) => navigate()) : navigate();
    });
  }

  void navigate() {
    Navigator.pushReplacementNamed(context, '/customer_home');
  }
  bool passwordVisibility = false;
  late String email;
  late String password;
  bool processing = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  void login() async {
    setState(() {
      processing = true;
    });
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        _formKey.currentState!.reset();
        //! navigate to customer home screen
        await Future.delayed(Duration(microseconds: 100)).whenComplete(
            () => Navigator.pushReplacementNamed(context, '/customer_home'));
      } on FirebaseAuthException catch (e) {
        setState(() {
          processing = false;
        });
        if (e.code == 'user-not-found') {
          MyMessageHandler.showSnackBar(
              _scaffoldKey, 'No user found with that email.');
        } else if (e.code == 'wrong-password') {
          MyMessageHandler.showSnackBar(
              _scaffoldKey, 'Username or password is incorrect.');
        } else {
          MyMessageHandler.showSnackBar(
              _scaffoldKey, 'Username or password is incorrect.');
        }
      } catch (e) {
        setState(() {
          processing = false;
        });
        MyMessageHandler.showSnackBar(_scaffoldKey,
            'An unexpected error occurred, please try again later.');
      }
    } else {
      setState(() {
        processing = false;
      });
      MyMessageHandler.showSnackBar(
        _scaffoldKey,
        'Please fill all fields',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              reverse: true,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AuthHeaderLabel(
                        headerLabel: 'Login',
                      ),
                      SizedBox(height: 50),
                      //! started text form for the login form.
                      //! email
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Email is required";
                            } else if (!value.isValidEmail()) {
                              return 'Invalid email';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            email = value;
                          },
                          // controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: textFormDecoration.copyWith(
                              labelText: 'Email', hintText: 'Enter your email'),
                        ),
                      ),
                      //! password
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Password is required";
                            }
                            return null;
                          },
                          onChanged: (value) {
                            password = value;
                          },
                          //controller: _passwordController,
                          obscureText: !passwordVisibility,
                          decoration: textFormDecoration.copyWith(
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  passwordVisibility = !passwordVisibility;
                                });
                              },
                              icon: Icon(
                                passwordVisibility
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                            labelText: 'Password',
                            hintText: 'Enter your password',
                          ),
                        ),
                      ),
                      //! forget password:
                      TextButton(
                        onPressed: () {
                          // Implement logic for forgotten password
                        },
                        child: Text(
                          'Forget password ?',
                          style: TextStyle(
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      //! text to login
                      HaveAccount(
                        haveAccount: "don't have an account? ",
                        actionLabel: 'Sign Up',
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, '/customer_signup');
                        },
                      ),
                      //! button
                      processing
                          ? Center(
                              child: const CircularProgressIndicator(
                                color: Colors.purple,
                              ),
                            )
                          : AuthButton(
                              //! registration button
                              onPressed: login,
                              textLabel: 'Login',
                            ),
                      divider(),
                      googleLogInButton(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget divider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          SizedBox(
            width: 80,
            child: Divider(
              color: Colors.grey,
              thickness: 1,
            ),
          ),
          Text(
            '  Or  ',
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(
            width: 80,
            child: Divider(
              color: Colors.grey,
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget googleLogInButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(50, 50, 50, 20),
      child: Material(
        elevation: 3,
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(15),
        child: MaterialButton(
          onPressed: () {
            signInWithGoogle();
          },
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Icon(
                  FontAwesomeIcons.google,
                  color: Colors.red,
                ),
                Text(
                  'Sign In With Google',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                )
              ]),
        ),
      ),
    );
  }
}
