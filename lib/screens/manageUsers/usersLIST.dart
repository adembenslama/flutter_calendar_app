import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:manager/screens/manageUsers/tasktile.dart';
import 'package:manager/services/profileService.dart';
import 'package:manager/themeData.dart';
import 'package:manager/ui/customAppBar.dart';

class UsersListPage extends StatefulWidget {
  const UsersListPage({super.key});

  @override
  State<UsersListPage> createState() => _UsersListPageState();
}

class _UsersListPageState extends State<UsersListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const myAppBar(),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("users").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.red),
            );
          }
          return LiquidPullToRefresh(
            backgroundColor: Colors.white,
            color: Colors.transparent,
            showChildOpacityTransition: false,
            onRefresh: () async {
              setState(() {});
            },
            child: ListView.builder(
              itemCount: snapshot.data!.size,
              itemBuilder: (context, index) {
                String pfp = snapshot.data!.docs[index]['pfp'];
                String nom = snapshot.data!.docs[index]['name'];
                String type = snapshot.data!.docs[index]['type'];
                String status = snapshot.data!.docs[index]['status'];
                String id = snapshot.data!.docs[index].id;
                return UserTile(
                  eve: UserProfile(nom, id, pfp, type),
                  status: status,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
