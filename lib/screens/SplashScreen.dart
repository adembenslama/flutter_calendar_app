// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:manager/auth/authPage.dart';
import 'package:manager/auth/loadDataPage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(),
                Image.asset("assets/LOGO.png"),
                const CircularProgressIndicator(),
                const SizedBox()
              ],
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Someting went wrong'),
            );
          } else if (snapshot.hasData) {
            return const UserdatatLoadingPage();
          } else {
            return const AuthPage();
          }
        }),
      ),
    );
  }
}
