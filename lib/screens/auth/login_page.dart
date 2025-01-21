import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fstore/core/navigation/navigation.dart';
import 'package:fstore/screens/auth/page_component.dart';
import 'package:fstore/screens/auth/register_page.dart';
import 'package:fstore/screens/home_page.dart.dart';
import 'package:fstore/service/auth.dart';
import 'package:fstore/widgets/custom_snackbar.dart';
import 'package:fstore/widgets/extra_content.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController mailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? errorMessage = '';
  String? successMessage = '';

  @override
  Widget build(BuildContext context) {
    return RegisterComponentWidget(
      onTextButtonPressed: () {
        Navigation.push(page: RegisterPage());
      },
      extraContent: ExtraContent(),
      onElevatedButtonPressed: loginUser,
      mailController: mailController,
      passwordController: passwordController,
      appBarTitle: 'Sign in',
      appBarContent: 'Sign in to get started',
      buttonTitle: 'Sign-in',
    );
  }

  Future<void> loginUser() async {
    try {
      await Auth().loginUser(
          email: mailController.text, password: passwordController.text);

      final user = FirebaseAuth.instance.currentUser;

      if (user != null && user.emailVerified) {
        Navigation.push(page: HomePage());
      } else {
        CustomSnackbar.show(
            context: context, message: "Please verify your e-mail");
      }
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
