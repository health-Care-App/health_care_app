import 'package:flutter/material.dart';

SnackBar customSnackBar(
    {required String text,
    required Color backgroundColor,
    required Color textColor}) {
  return SnackBar(
    backgroundColor: backgroundColor,
    content: Text(
      text,
      style: TextStyle(color: textColor, letterSpacing: 0.5),
    ),
  );
}
