import 'package:flutter/material.dart';
import 'package:fstore/constants/colors/colors.dart';
import 'package:fstore/service/auth.dart';
import 'package:fstore/widgets/custom_textfield.dart';
import 'package:hexcolor/hexcolor.dart';

class RegisterComponentWidget extends StatefulWidget {
  final String appBarTitle;
  final String appBarContent;
  final String buttonTitle;
  final void Function()? onTextButtonPressed;
  final void Function() onElevatedButtonPressed;
  final Widget? extraContent;
  final TextEditingController mailController;
  final TextEditingController passwordController;

  const RegisterComponentWidget({
    super.key,
    this.extraContent,
    required this.onElevatedButtonPressed,
    required this.passwordController,
    required this.mailController,
    required this.appBarTitle,
    required this.appBarContent,
    required this.buttonTitle,
    this.onTextButtonPressed,
  });

  @override
  State<RegisterComponentWidget> createState() =>
      _RegisterComponentWidgetState();
}

class _RegisterComponentWidgetState extends State<RegisterComponentWidget> {
  final Auth auth = Auth();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.all(35),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.appBarTitle,
                    style: const TextStyle(
                        fontSize: 26, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    widget.appBarContent,
                    style: const TextStyle(
                        fontSize: 21, fontWeight: FontWeight.w500),
                  ),
                  widget.extraContent ?? const SizedBox(),
                  const SizedBox(height: 50),
                  CustomTextField(
                    hintText: "Enter e-mail",
                    controller: widget.mailController,
                    obsecureText: false,
                  ),
                  const SizedBox(height: 40),
                  CustomTextField(
                    controller: widget.passwordController,
                    hintText: "Password",
                    obsecureText: true,
                  ),
                  const SizedBox(height: 80),
                  Center(
                    child: ElevatedButton(
                      onPressed: widget.onElevatedButtonPressed,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9)),
                        elevation: 10,
                        fixedSize: const Size(double.maxFinite, 60),
                        backgroundColor: HexColor(AppColors.buttonColor),
                      ),
                      child: Text(
                        widget.buttonTitle,
                        style: TextStyle(
                            color: HexColor(AppColors.buttonTextColor),
                            fontSize: 15),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
