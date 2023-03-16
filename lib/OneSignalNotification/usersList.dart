// ignore_for_file: camel_case_types, file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:manager/services/profileService.dart';

class oneSignalNote {
  final String id;
  final String type;

  oneSignalNote({
    required this.type,
    required this.id,

    //
  });
}

List<String> managersListOneSignal = [];
List<String> usersListOneSignal = [];

Future initializeOneSignalLists() async {
  List<String> newUsersList = [];
  List<String> managersNewList = [];
  await FirebaseFirestore.instance
      .collection("OneSignalIDs")
      .get()
      .then((QuerySnapshot querySnapshot) {
    for (var doc in querySnapshot.docs) {
      if (doc.id != CurrentUserData.uid) {
        oneSignalNote aux = fromJsonOneSignal(doc);
        newUsersList.add(aux.id);
        if (aux.type != "user") {
          managersNewList.add(aux.id);
        }
      }
    }
  });
  usersListOneSignal = newUsersList;
  managersListOneSignal = managersNewList;
}

oneSignalNote fromJsonOneSignal(QueryDocumentSnapshot json) => oneSignalNote(
      id: json['id'],
      type: json['admin'],
    );
