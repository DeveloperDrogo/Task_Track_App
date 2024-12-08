import 'package:flutter/material.dart';

class LoadingDialog {
  static bool _isVisible = false;

  static void show(BuildContext context) {
    if (!_isVisible) {
      _isVisible = true;
      showDialog(
        context: context,
        barrierDismissible: false,
        
        builder: (BuildContext context) {
          return const AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 5),
                CircularProgressIndicator(),
                SizedBox(height: 16.0),
                Text('Please wait...'),
              ],
            ),
          );
        },
      );
    }
  }

  static void dismiss(BuildContext context) {
    if (_isVisible) {
      _isVisible = false;
      Navigator.of(context, rootNavigator: true).pop();
    }
  }
}
