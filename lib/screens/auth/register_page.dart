import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fstore/screens/auth/page_component.dart';
import 'package:fstore/service/auth.dart';
import 'package:fstore/widgets/custom_snackbar.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController mailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  String? errorMessage = '';
  String? successMessage = '';

  @override
  Widget build(BuildContext context) {
    return RegisterComponentWidget(
      onElevatedButtonPressed: createUser,
      mailController: mailController,
      passwordController: passwordController,
      appBarTitle: 'Register',
      appBarContent: 'Register to get started',
      buttonTitle: 'Register',
    );
  }

  Future<void> createUser() async {
    try {
      await Auth().createUser(
        email: mailController.text,
        password: passwordController.text,
      );
      CustomSnackbar.show(context: context, message: "Verification email sent");
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message;
      CustomSnackbar.show(context: context, message: errorMessage!);
    }
    setState(() {
      mailController.clear();
      passwordController.clear();
    });
  }
}
