// ignore_for_file: use_build_context_synchronously, file_names

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:manager/services/profileService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:manager/ui/customAppBar.dart';
import 'package:quickalert/quickalert.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final currentUser = FirebaseAuth.instance.currentUser!;
  PickedFile? _image;
  UploadTask? uploadTask;

  void selectFile() async {
    var image = await ImagePicker.platform
        .pickImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = image;
    });

    uploadFile();
  }

  Future uploadFile() async {
    final path = 'files/$CurrentUserData';

    final file = File(_image!.path);
    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);
    final snapshot = await uploadTask!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    await users.doc(currentUser.uid).update({'pfp': urlDownload});
    setState(() {
      CurrentUserData.pfp = urlDownload;
    });
  }

  Future updateUsername() async {
    try {
      await users
          .doc(currentUser.uid)
          .update({'name': _usernameController.text});
      QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: "new Username ${_usernameController.text}");
      setState(() {
        CurrentUserData.name = _usernameController.text;
        _usernameController.clear();
      });
    } catch (e) {
      QuickAlert.show(
          context: context, type: QuickAlertType.error, text: e.toString());
    }
  }

  Future updatePass() async {
    try {
      await currentUser.updatePassword(_passwordController.text.trim());
      QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: "Password Updated");
      setState(() {
        _passwordController.clear();
      });
    } catch (e) {
      QuickAlert.show(
          context: context, type: QuickAlertType.error, text: e.toString());
    }
  }

  Future updateEmail() async {
    try {
      await currentUser.updateEmail(_emailController.text.trim());
      QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: "new email ${_emailController.text}");
      setState(() {
        _emailController.clear();
      });
    } catch (e) {
      QuickAlert.show(
          context: context, type: QuickAlertType.error, text: e.toString());
    }
  }

  //controllers
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 12, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CurrentUserData.pfp == "pfp"
                        ? GestureDetector(
                            onTap: () {},
                            child: const CircleAvatar(
                                minRadius: 80,
                                maxRadius: 100,
                                backgroundImage: AssetImage("assets/user.png")),
                          )
                        : GestureDetector(
                            onTap: () => null,
                            child: CircleAvatar(
                              minRadius: 80,
                              maxRadius: 100,
                              backgroundImage: NetworkImage(
                                CurrentUserData.pfp,
                              ),
                            ),
                          ),
                    IconButton(
                        onPressed: () {
                          selectFile();
                        },
                        icon: const Icon(
                          Icons.edit,
                          size: 30,
                          color: Colors.white,
                        ))
                  ],
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Username",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 52,
                        width: MediaQuery.of(context).size.width * 0.7,
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.only(left: 14),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey,
                              width: 0.0,
                            )),
                        child: TextFormField(
                          autofocus: false,
                          cursorColor: Colors.grey,
                          controller: _usernameController,
                          decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.person),
                              hintText: CurrentUserData.name,
                              border: InputBorder.none),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.red),
                              foregroundColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.white)),
                          onPressed: () {
                            updateUsername();
                          },
                          child: const Text("save"),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Email",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 52,
                        width: MediaQuery.of(context).size.width * 0.7,
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.only(left: 14),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey,
                              width: 0.0,
                            )),
                        child: TextFormField(
                          autofocus: false,
                          cursorColor: Colors.grey,
                          controller: _emailController,
                          decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.mail),
                              hintText:
                                  FirebaseAuth.instance.currentUser!.email,
                              border: InputBorder.none),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.red),
                              foregroundColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.white)),
                          onPressed: () {
                            updateEmail();
                          },
                          child: const Text("save"),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Password",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 52,
                        width: MediaQuery.of(context).size.width * 0.7,
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.only(left: 14),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey,
                              width: 0.0,
                            )),
                        child: TextFormField(
                          obscureText: true,
                          autofocus: false,
                          cursorColor: Colors.grey,
                          controller: _passwordController,
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.lock),
                              hintText: "enter Password",
                              border: InputBorder.none),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.red),
                              foregroundColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.white)),
                          onPressed: () {
                            updatePass();
                          },
                          child: const Text("save"),
                        ),
                      )
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
