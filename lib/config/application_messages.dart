import 'package:flutter/material.dart';

class ApplicationMessages {
  BuildContext context;

  ApplicationMessages({Key? key, required this.context});

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}
