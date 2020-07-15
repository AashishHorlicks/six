import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IosDialogHelper {
  void showMessage(BuildContext context, String title, String message) {
    showDialog<String>(
        context: context,
        barrierDismissible: true,
        builder: (context) => CupertinoAlertDialog(
              title: Text(title, style: TextStyle(color: Colors.black)),
              content: Text(message, style: TextStyle(color: Colors.black)),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.pop(context, 'Discard');
                  },
                )
              ],
            ));
  }

  void showConfirm(BuildContext context, String title, String message,
      Function onOkayPressed, String okButtonText) {
    showDialog<String>(
        context: context,
        barrierDismissible: true,
        builder: (context) => CupertinoAlertDialog(
              title: Text(title),
              content: Text(message),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: const Text('Cancel',
                      style: TextStyle(color: Colors.black)),
                  onPressed: () {
                    Navigator.pop(context, 'Discard');
                  },
                ),
                CupertinoDialogAction(
                  child:
                      Text(okButtonText, style: TextStyle(color: Colors.black)),
                  onPressed: () {
                    Navigator.of(context).pop();
                    onOkayPressed();
                  },
                ),
              ],
            ));
  }
}
