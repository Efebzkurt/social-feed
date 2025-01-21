import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fstore/core/navigation/navigation.dart';
import 'package:fstore/core/size/device_size.dart';
import 'package:fstore/screens/auth/login_page.dart';
import 'package:fstore/theme/app_theme.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final DeviceSize deviceSize = DeviceSize();
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: Navigation.navigationKey,
        theme: AppTheme.theme,
        home: Builder(
          builder: (context) {
            deviceSize.init(context);
            return const LoginPage();
          },
        ));
  }
}
