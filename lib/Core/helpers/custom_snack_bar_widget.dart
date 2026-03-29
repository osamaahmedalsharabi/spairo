import 'package:flutter/material.dart';

class CustomSnackBarWidget {
  static void showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16),
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }
}
