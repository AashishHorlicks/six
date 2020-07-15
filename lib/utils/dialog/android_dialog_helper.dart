import 'package:flutter/material.dart';

class AndroidDialogHelper {
  void showMessage(BuildContext context, String title, String message,
      VoidCallback onOKPressed) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          actions: <Widget>[
            FlatButton(
              child: Text('OK', style: TextStyle(color: Colors.black)),
              onPressed: onOKPressed,
            ),
          ],
          title: Text(title, style: TextStyle(color: Colors.black)),
          content: SingleChildScrollView(
            child: Text(message, style: TextStyle(color: Colors.black)),
          ),
        );
      },
    );
  }

  void showConfirm(BuildContext context, String title, String message,
      Function onOkayPressed, String okButtonText) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel', style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(okButtonText, style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
                onOkayPressed();
              },
            ),
          ],
          title: Text(title, style: TextStyle(color: Colors.black)),
          content: SingleChildScrollView(
            child: Text(message),
          ),
        );
      },
    );
  }
}
