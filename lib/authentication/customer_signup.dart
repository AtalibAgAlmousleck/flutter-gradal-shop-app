// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

import '../widgets/auth_widget.dart';
import '../widgets/snackBar.dart';

// final TextEditingController _nameController = TextEditingController();
// final TextEditingController _emailController = TextEditingController();
// final TextEditingController _passwordController = TextEditingController();

class CustomerRegister extends StatefulWidget {
  const CustomerRegister({super.key});

  @override
  State<CustomerRegister> createState() => _CustomerRegisterState();
}

class _CustomerRegisterState extends State<CustomerRegister> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  bool passwordVisibility = false;
  late String name;
  late String email;
  late String password;
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
                    children: [
                      AuthHeaderLabel(
                        headerLabel: 'SignUp',
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 40,
                            ),
                            child: CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.purpleAccent,
                            ),
                          ),
                          Column(
                            children: [
                              //! first container camera
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.purple,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                  ),
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    print('Pick image from camera');
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              //!second container galary
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.purple,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(15),
                                  ),
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.photo,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    print('Pick image from galary');
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      //! started text form for the registration form.
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Username is required";
                            }
                            return null;
                          },
                          onChanged: (value) {
                            name = value;
                          },
                          //controller: _nameController,
                          decoration: textFormDecoration.copyWith(
                              labelText: 'Full name',
                              hintText: 'Enter your Full name'),
                        ),
                      ),
                      //! email
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Email is required";
                            } else if (value.isValidEmail() == false) {
                              return 'Invalid email';
                            } else if (value.isValidEmail() == true) {
                              return null;
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
                          obscureText: passwordVisibility,
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
                      //! text to login
                      HaveAccount(
                        haveAccount: 'Have an account?',
                        actionLabel: 'Login',
                        onPressed: () {},
                      ),
                      //! button
                      AuthButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            print('valid');
                            setState(() {
                              // name = _nameController.text;
                              // email = _emailController.text;
                              // password = _passwordController.text;
                            });
                            print(name);
                            print(email);
                            print(password);
                          } else {
                            MyMessageHandler.showSnackBar(
                              _scaffoldKey,
                              'All fields are required',
                            );
                          }
                        },
                        textLabel: 'Sing Up',
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
