// ignore_for_file: camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';

class event {
  final DateTime date;
  final String title;
  final String startTime;
  final String endTime;
  final String note;
  final int color;
  final String userUid;
  final String id;
  final String access;

  event(
      {required this.date,
      required this.id,
      required this.title,
      required this.startTime,
      required this.endTime,
      required this.note,
      required this.userUid,
      required this.color,
      required this.access
      //
      });
}

List<event> eventList = [];

Future initilaizeList() async {
  List<event> newList = [];
  await FirebaseFirestore.instance
      .collection("events")
      .get()
      .then((QuerySnapshot querySnapshot) {
    for (var doc in querySnapshot.docs) {
      newList.add(fromJsonEvent(doc));
    }
  });
  eventList = newList;
}

event fromJsonEvent(QueryDocumentSnapshot json) => event(
    date: (json['date'] as Timestamp).toDate(),
    title: json['title'],
    startTime: json['start Time'],
    endTime: json['end Time'],
    note: json['note'],
    color: json['Color'],
    userUid: json['user'],
    id: json.id,
    access: json["access"]);
