// ignore_for_file: file_names, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:get/get.dart';
import 'package:manager/themeData.dart';

class SignUpPage extends StatefulWidget {
  final VoidCallback onClickedSignUp;
  const SignUpPage({super.key, required this.onClickedSignUp});

  @override
  State<SignUpPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<SignUpPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.3,
                decoration: const BoxDecoration(
                    color: RedClr,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30))),
                child: Center(
                  child: Image.asset(
                    "assets/LOGO.png",
                    width: MediaQuery.of(context).size.width * 0.3,
                  ),
                ),
              ),
            ]),
            const SizedBox(
              height: 60,
            ),
            Container(
              margin: const EdgeInsets.only(left: 30),
              alignment: Alignment.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Hello!",
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: RedClr,
                    ),
                  ),
                  Text(
                    "sign up ",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w400,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(40),
              child: Column(
                children: [
                  TextFormField(
                    controller: emailController,
                    textInputAction: TextInputAction.next,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (email) =>
                        email != null && !EmailValidator.validate(email)
                            ? 'enter valid email'
                            : null,
                    decoration: const InputDecoration(
                        label: Text("E-mail"),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 1.0))),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(label: Text("Password")),
                    textInputAction: TextInputAction.done,
                    controller: passwordController,
                    obscureText: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) =>
                        value != null && value.length < 8 ? 'too short' : null,
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: signUp,
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateColor.resolveWith((states) => RedClr)),
              child: const Text(
                "Sign Up ",
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            RichText(
                text: TextSpan(
                    style: const TextStyle(
                      color: Colors.black45,
                    ),
                    text: 'Have an Account ? ',
                    children: [
                  TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = widget.onClickedSignUp,
                      text: 'login ',
                      style: (const TextStyle(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w500,
                          color: Colors.red)))
                ]))
          ],
        ),
      ),
    );
  }

  Future addUser(String uid) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        "name": "NoName",
        "status": "pending",
        'pfp':
            "https://firebasestorage.googleapis.com/v0/b/peaksource-team.appspot.com/o/pngwing.com.png?alt=media&token=d83b6a33-be25-4f78-bddc-bba204a9cded",
        "type": "user"
      });
    } catch (e) {}
  }

  Future signUp() async {
    String uid = "";
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      uid = FirebaseAuth.instance.currentUser!.uid;
      FirebaseAuth.instance.signOut();
      print("loggedIn");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Get.snackbar("title", "message");
      } else if (e.code == 'email-already-in-use') {
        Get.snackbar("title", "message");
      }
      print("Adding");
      if (uid != "") {
        addUser(uid);
        Get.snackbar("Account Created", "Wait for admin approval.");
      }
    }
  }
}
