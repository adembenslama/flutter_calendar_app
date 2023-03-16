// ignore_for_file: file_names, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manager/OneSignalNotification/usersList.dart';
import 'package:manager/auth/authPage.dart';
import 'package:manager/auth/loginPage.dart';
import 'package:manager/services/events.dart';

import 'package:manager/services/profileService.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../screens/navigationBar.dart';

class UserdatatLoadingPage extends StatefulWidget {
  const UserdatatLoadingPage({Key? key}) : super(key: key);

  @override
  State<UserdatatLoadingPage> createState() => _UserdatatLoadingPageState();
}

class _UserdatatLoadingPageState extends State<UserdatatLoadingPage> {
  @override
  void initState() {
    super.initState();
    initilaizeList();
    initilaizeUsesList();
    initializeOneSignalLists();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        try {
          CurrentUserData.name = snapshot.data['name'];
          CurrentUserData.uid = FirebaseAuth.instance.currentUser!.uid;
          CurrentUserData.type = snapshot.data['type'];
          CurrentUserData.pfp = snapshot.data['pfp'];
        } catch (e) {
          print(e.toString());
        }
        print("hi");
        OneSignal.shared.getDeviceState().then((status) {
          String playerId = status!.userId.toString();
          print('OneSignal Player ID: $playerId');
          FirebaseFirestore.instance
              .collection("OneSignalIDs")
              .doc(CurrentUserData.uid)
              .set({'id': playerId, 'admin': CurrentUserData.type});
        }).catchError((error) {
          print('Error getting OneSignal player ID: $error');
        });

        try {
          String status = snapshot.data['status'];
          print("${status}66666666666666666666666666666666666666666666");
          if (status == "banned") {
            suspended = true;
            FirebaseAuth.instance.signOut();
          }
          if (status == "pending") {
            pending = true;
            FirebaseAuth.instance.signOut();
          }
        } catch (e) {
          print(e.toString());
        }
        if (FirebaseAuth.instance.currentUser != null) {
          return const homenavigationPage();
        } else {
          return const AuthPage();
        }
      },
    );
  }
}
