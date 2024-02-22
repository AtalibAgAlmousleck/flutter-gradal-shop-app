import 'package:flutter/cupertino.dart';

class MyAlertDialog {
  static void showMyDialog({
    required BuildContext context,
    required String title,
    required String content,
    required Function() tabNo,
    required Function() tabYes,
  }) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: Text(title),
              content: Text(content),
              actions: <CupertinoDialogAction>[
                CupertinoDialogAction(
                  child: Text('No'),
                  onPressed: tabNo,
                ),
                CupertinoDialogAction(
                  child: Text('Yes'),
                  isDestructiveAction: true,
                  onPressed: tabYes,
                ),
              ],
            ));
  }
}