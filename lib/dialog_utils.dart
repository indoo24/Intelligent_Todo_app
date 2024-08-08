import 'package:flutter/material.dart';

class DialogUtils {
  static void showLoading(BuildContext context, String message) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(message),
                ),
              ],
            ),
          );
        });
  }

  static void hideLoading(BuildContext context) {
    Navigator.pop(context);
  }

  static showMessage(
      {required BuildContext context,
      required String content,
      String title = '',
      String button = 'ok',
      Function? function}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(content),
            title: Text(
              title,
              style: TextStyle(color: Colors.black),
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop;
                    function?.call();
                  },
                  child: Text(button)),
            ],
          );
        });
  }
}
