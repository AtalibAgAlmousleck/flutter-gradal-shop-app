import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  const AuthButton(
      {super.key, required this.textLabel, required this.onPressed});

  final String textLabel;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Material(
        color: Colors.purple,
        borderRadius: BorderRadius.circular(15),
        child: MaterialButton(
          minWidth: double.infinity,
          onPressed: onPressed,
          child: Text(
            textLabel,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontStyle: FontStyle.italic,
              letterSpacing: 1.5
            ),
          ),
        ),
      ),
    );
  }
}

class HaveAccount extends StatelessWidget {
  const HaveAccount({
    super.key,
    required this.haveAccount,
    required this.actionLabel,
    required this.onPressed,
  });

  final String haveAccount;
  final String actionLabel;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          haveAccount,
          style: TextStyle(
            fontSize: 16,
            fontStyle: FontStyle.italic,
          ),
        ),
        TextButton(
          onPressed: onPressed,
          child: Text(
            actionLabel,
            style: TextStyle(
              fontSize: 20,
              color: Colors.purple,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class AuthHeaderLabel extends StatelessWidget {
  const AuthHeaderLabel({super.key, required this.headerLabel});

  final String headerLabel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            headerLabel,
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/welcome_screen');
            },
            icon: Icon(
              Icons.home_work,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }
}

var textFormDecoration = InputDecoration(
  labelText: 'Full name',
  hintText: 'Please enter full name',
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(25),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.purple,
      width: 1,
    ),
    borderRadius: BorderRadius.circular(25),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.deepPurpleAccent,
      width: 2,
    ),
    borderRadius: BorderRadius.circular(25),
  ),
);

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^([a-zA-Z0-9]+)([\-\_\.]*)([a-zA-Z0-9]*)([@])([a-zA-Z0-9]{2,})([\.][a-zA-Z]{2,3})$')
        .hasMatch(this);
    //r'^([a-zA-Z0-9]+)([\-\_\.]*)([a-zA-Z0-9]*)([@])([a-zA-Z0-9]{2,})([\.][a-zA-Z]{2,3})$')
    //r'^[a-zA-Z0-9]+[\-\_\.]*[a-zA-Z0-9]*[@][a-zA-Z0-9]{2,}[\.][a-zA-Z0-9]{2,3}$'
  }
}
