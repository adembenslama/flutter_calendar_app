// ignore_for_file: file_names, avoid_print
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:get/get.dart';
import 'package:manager/themeData.dart';
import 'resetPasswordPage.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onClickedSignUp;
  const LoginPage({super.key, required this.onClickedSignUp});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

bool suspended = false;
bool pending = false;

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // do something
      if (suspended == true) {
        Get.snackbar("Suspended", "This account is suspended.",
            backgroundColor: Colors.white, colorText: RedClr);
      }
      if (pending == true) {
        Get.snackbar("account not activated",
            "contact the admin to activate your account.",
            backgroundColor: Colors.white, colorText: RedClr);
      }

      print("Build Completed");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
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
                        letterSpacing: 2),
                  ),
                  Text(
                    "Login ",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w400,
                      color: RedClr,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white,
                        width: 0.0,
                      )),
                  child: TextFormField(
                    controller: emailController,
                    textInputAction: TextInputAction.next,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (email) =>
                        email != null && !EmailValidator.validate(email)
                            ? 'enter valid email'
                            : null,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.mail,
                        color: RedClr,
                      ),
                      label: Text("E-mail"),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(width: 0, color: Colors.white)),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      label: Text("Password"),
                      prefixIcon: Icon(
                        Icons.lock,
                        color: RedClr,
                      ),
                      border: InputBorder.none,
                    ),
                    textInputAction: TextInputAction.done,
                    controller: passwordController,
                    obscureText: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) =>
                        value != null && value.length < 8 ? 'too short' : null,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GestureDetector(
                    onTap: () => Get.to(const ResetPass()),
                    child: const Text(
                      "Forgot Password?",
                      style:
                          TextStyle(color: RedClr, fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              child: ElevatedButton(
                onPressed: signIn,
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateColor.resolveWith((states) => RedClr)),
                child: const Text(
                  "Login ",
                  style: TextStyle(color: Colors.white),
                ),
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
                    text: 'dont have an Account ? ',
                    children: [
                  TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = widget.onClickedSignUp,
                      text: 'create one ',
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

  Future signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Get.snackbar("incorrect ", "Email not Found",
            backgroundColor: Colors.white, colorText: RedClr);
      } else if (e.code == 'wrong-password') {
        Get.snackbar("Incorrect Password ", "Try Again ",
            backgroundColor: Colors.white, colorText: RedClr);
      }
    }
  }
}
