// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';

class MyMessageHandler {
  static showSnackBar(var _scaffoldKey, String message) {
    _scaffoldKey.currentState!.hideCurrentSnackBar();
    _scaffoldKey.currentState!.showSnackBar(
      SnackBar(
        duration: Duration(seconds: 2),
        backgroundColor: Colors.deepPurpleAccent,
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
