import 'package:flutter/material.dart';
import 'package:fstore/core/navigation/navigation.dart';

import 'package:fstore/screens/auth/register_page.dart';

class ExtraContent extends StatelessWidget {
  const ExtraContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 40),
        Text(
          "If you don't have an account, register",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
        ),
        Row(children: [
          Text(
            "You can ",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
          ),
          TextButton(
              onPressed: () {
                Navigation.push(page: RegisterPage());
              },
              child: Text(
                "Register here!",
                style: TextStyle(fontWeight: FontWeight.w700),
              ))
        ]),
      ],
    );
  }
}
