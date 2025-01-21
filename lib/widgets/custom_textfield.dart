import 'package:flutter/material.dart';
import 'package:fstore/constants/colors/colors.dart';
import 'package:hexcolor/hexcolor.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    required this.controller,
    required this.hintText,
    required this.obsecureText,
    super.key,
  });
  final String hintText;
  final TextEditingController controller;
  final bool obsecureText;
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 10),
        height: 62,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: HexColor(AppColors.textFieldBackgroundColor),
        ),
        child: Center(
            child: TextField(
          obscureText: obsecureText,
          controller: controller,
          decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent)),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent)),
              hintText: hintText,
              hintStyle:
                  TextStyle(color: HexColor(AppColors.textFieldTextColor))),
        )));
  }
}
