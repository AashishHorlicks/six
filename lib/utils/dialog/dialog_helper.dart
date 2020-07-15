import 'package:flutter/material.dart';

import 'android_dialog_helper.dart';
import 'ios_dialog_helper.dart';

class DialogHelper {
  void showMessage(BuildContext context, String title, String message,
      VoidCallback onOKPressed) {
    if (Theme.of(context).platform == TargetPlatform.iOS)
      IosDialogHelper().showMessage(context, title, message);
    else
      AndroidDialogHelper().showMessage(context, title, message, onOKPressed);
  }

  void showConfirm(BuildContext context, String title, String message,
      Function onOkayPressed, String okButtonText) {
    if (Theme.of(context).platform == TargetPlatform.iOS)
      IosDialogHelper()
          .showConfirm(context, title, message, onOkayPressed, okButtonText);
    else
      AndroidDialogHelper()
          .showConfirm(context, title, message, onOkayPressed, okButtonText);
  }
}
