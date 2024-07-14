import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradal/widgets/app_bar_widgets.dart';
import 'package:gradal/widgets/snack_bar.dart';
import 'package:gradal/widgets/yellow_button.dart';
import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:uuid/uuid.dart';

class AddAddress extends StatefulWidget {
  const AddAddress({super.key});

  @override
  State<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  late String firstName;
  late String lastName;
  late String phone;
  String countryValue = 'Choose Country';
  String stateValue = 'Choose State';
  String cityValue = 'Choose City';

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: AppBarBackButton(),
          title: AppBarTitle(
            title: 'Add Address',
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(15), //symmetric(vertical: 10),
                      child: SizedBox(
                        //width: MediaQuery.of(context).size.width * 0.50,
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please enter first name';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            firstName = value!;
                          },
                          //controller
                          decoration: textFormDecoration.copyWith(
                            labelText: 'First name',
                            hintText: 'Enter fist name',
                          ),
                        ),
                      ),
                    ),
                    // last name
                    Padding(
                      padding: EdgeInsets.all(15), //symmetric(vertical: 10),
                      child: SizedBox(
                        //width: MediaQuery.of(context).size.width * 0.50,
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please enter last name';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            lastName = value!;
                          },
                          //controller
                          decoration: textFormDecoration.copyWith(
                            labelText: 'Last name',
                            hintText: 'Enter last name',
                          ),
                        ),
                      ),
                    ),
                    // phone number
                    Padding(
                      padding: EdgeInsets.all(15), //symmetric(vertical: 10),
                      child: SizedBox(
                        //width: MediaQuery.of(context).size.width * 0.50,
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please phone number';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            phone = value!;
                          },
                          //controller
                          decoration: textFormDecoration.copyWith(
                            labelText: 'Phone number',
                            hintText: 'Enter phone number',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(25),
                  child: SelectState(
                    onCountryChanged: (value) {
                      setState(() {
                        countryValue = value;
                      });
                    },
                    onStateChanged: (value) {
                      setState(() {
                        stateValue = value;
                      });
                    },
                    onCityChanged: (value) {
                      setState(() {
                        cityValue = value;
                      });
                    },
                  ),
                ),
                SizedBox(height: 20),
                YellowButton(
                  label: 'Add New Address',
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      if (countryValue != 'Choose Country' &&
                          stateValue != 'Choose State' &&
                          cityValue != 'Choose City') {
                        formKey.currentState!.save();
                        CollectionReference addressRef = FirebaseFirestore.instance
                            .collection('customers')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection('address');
                        var addressId = Uuid().v4();
                        await addressRef.doc(addressId).set({
                          'addressid': addressId,
                          'firstname': firstName,
                          'lastname': lastName,
                          'phone': phone,
                          'country': countryValue,
                          'state': stateValue,
                          'city': cityValue,
                          'default': true,
                        }).whenComplete(() => Navigator.pop(context));
                      } else {
                        MyMessageHandler.showSnackBar(
                            _scaffoldKey, 'Please select your location');
                      }
                    } else {
                      MyMessageHandler.showSnackBar(
                          _scaffoldKey, 'Please fill all fields.');
                    }
                  },
                  width: 0.8,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

var textFormDecoration = InputDecoration(
  labelText: 'Price',
  hintText: 'Price \$',
  labelStyle: const TextStyle(color: Colors.purple),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.pink, width: 1),
    borderRadius: BorderRadius.circular(10),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 2),
    borderRadius: BorderRadius.circular(10),
  ),
);
