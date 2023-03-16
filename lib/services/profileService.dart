// ignore_for_file: non_constant_identifier_names, file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  String name;
  String uid;
  String pfp;
  String type;

  UserProfile(
    this.name,
    this.uid,
    this.pfp,
    this.type,
  );
}

UserProfile CurrentUserData = UserProfile(
    "null",
    "uid",
    "https://firebasestorage.googleapis.com/v0/b/peaksource-team.appspot.com/o/pngwing.com.png?alt=media&token=d83b6a33-be25-4f78-bddc-bba204a9cded",
    'type');
List<UserProfile> usersList = [];
Future initilaizeUsesList() async {
  List<UserProfile> newList = [];
  await FirebaseFirestore.instance
      .collection("users")
      .get()
      .then((QuerySnapshot querySnapshot) {
    for (var doc in querySnapshot.docs) {
      newList.add(fromJsonUser(doc));
    }
  });
  usersList = newList;
}

UserProfile fromJsonUser(QueryDocumentSnapshot json) {
  return UserProfile(json['name'], json.id, json['pfp'], json['type']);
}
