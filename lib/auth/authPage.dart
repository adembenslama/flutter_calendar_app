// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:manager/auth/loginPage.dart';
import 'package:manager/auth/signupPage.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) => isLogin
      ? LoginPage(
          onClickedSignUp: toggle,
        )
      : SignUpPage(onClickedSignUp: toggle);

  void toggle() => setState(() => isLogin = !isLogin);
}
