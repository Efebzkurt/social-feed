import 'package:flutter/material.dart';
import 'package:fstore/constants/colors/colors.dart';
import 'package:hexcolor/hexcolor.dart';

class CustomSnackbar {
  static void show({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style:
              TextStyle(color: HexColor(AppColors.buttonColor), fontSize: 16),
        ),
        backgroundColor: HexColor(AppColors.textFieldBackgroundColor),
        duration: duration,
        action: action,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
