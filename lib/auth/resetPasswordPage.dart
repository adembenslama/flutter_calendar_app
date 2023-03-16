// ignore_for_file: use_build_context_synchronously, no_leading_underscores_for_local_identifiers, file_names

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:manager/themeData.dart';
import 'package:manager/ui/customAppBar.dart';
import 'package:quickalert/quickalert.dart';

class ResetPass extends StatefulWidget {
  const ResetPass({super.key});

  @override
  State<ResetPass> createState() => RestPassState();
}

class RestPassState extends State<ResetPass> {
  @override
  Widget build(BuildContext context) {
    Future resetPass(String email) async {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            text: "an Email was sent check your email");
      } catch (e) {
        QuickAlert.show(
            context: context, type: QuickAlertType.error, text: e.toString());
      }
    }

    TextEditingController _emailController = TextEditingController();
    return Scaffold(
      appBar: const myAppBar(
        leading: BackButton(),
      ),
      body: Column(
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
              controller: _emailController,
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
          ElevatedButton(
            onPressed: () => resetPass(_emailController.text),
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateColor.resolveWith((states) => RedClr)),
            child: const Text(
              "send Email ",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
