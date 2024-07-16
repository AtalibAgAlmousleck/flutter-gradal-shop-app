// ignore_for_file: avoid_print, use_build_context_synchronously
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradal/providers/auth_repo.dart';
import 'package:gradal/widgets/yellow_button.dart';

import '../widgets/auth_widget.dart';
import '../widgets/snack_bar.dart';
import 'forgot_password.dart';

class SupplierLogin extends StatefulWidget {
  const SupplierLogin({Key? key}) : super(key: key);

  @override
  State<SupplierLogin> createState() => _SupplierLoginState();
}

class _SupplierLoginState extends State<SupplierLogin> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  bool passwordVisibility = false;
  late String email;
  late String password;
  bool processing = false;
  bool reSendEmail = false;

  void login() async {
    setState(() {
      processing = true;
    });
    if (_formKey.currentState!.validate()) {
      try {
        await AuthRepo.singInWithEmailAndPassword(email, password);

        await AuthRepo.reloadUserData();
        if (await AuthRepo.checkEmailVerification()) {
          _formKey.currentState!.reset();
          await Future.delayed(Duration(microseconds: 100)).whenComplete(() {
            Navigator.pushReplacementNamed(context, '/supplier_home');
          });
        } else {
          MyMessageHandler.showSnackBar(
            _scaffoldKey,
            'Please check your email to verified your email.',
          );
          setState(() {
            processing = false;
            //reSendEmail = true;
          });
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          processing = false;
        });
        MyMessageHandler.showSnackBar(_scaffoldKey, e.message.toString());
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
                        headerLabel: 'Login Supplier',
                      ),
                      SizedBox(
                        height: 50,
                        child: reSendEmail == true
                            ? YellowButton(
                                label: 'Resend',
                                onPressed: () async {
                                  try {
                                    await FirebaseAuth.instance.currentUser!
                                        .sendEmailVerification();
                                  } catch (e) {
                                    print(e);
                                  }
                                  Future.delayed(Duration(seconds: 3))
                                      .whenComplete(() {
                                    setState(() {
                                      reSendEmail = false;
                                    });
                                  });
                                },
                                width: 0.6,
                              )
                            : SizedBox(),
                      ),
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ForgotPassword(),
                            ),
                          );
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
                              context, '/supplier_signup');
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
}
