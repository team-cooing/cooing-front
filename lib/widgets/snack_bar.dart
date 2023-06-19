import 'package:cooing_front/model/config/palette.dart';
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Palette.mainPurple,
      content: Text(message),
      duration: Duration(seconds: 4),
    ),
  );
}