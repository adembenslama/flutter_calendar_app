// ignore_for_file: no_logic_in_create_state, non_constant_identifier_names, file_names, avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:manager/chat/tasktile.dart';
import 'package:manager/services/profileService.dart';
import 'package:manager/themeData.dart';

class MainChatScreen extends StatefulWidget {
  const MainChatScreen({super.key});

  @override
  State<MainChatScreen> createState() => _MainChatScreenState();
}

class _MainChatScreenState extends State<MainChatScreen> {
  void _showModalBottomSheet(BuildContext context) {
    TextEditingController _chat = TextEditingController();
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          decoration: const BoxDecoration(
              color: Color.fromARGB(255, 39, 39, 39),
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20), topLeft: Radius.circular(20))),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  label: Text("New Chat Group"),
                  prefixIcon: Icon(
                    Icons.chat,
                    color: RedClr,
                  ),
                  border: InputBorder.none,
                ),
                textInputAction: TextInputAction.done,
                controller: _chat,
              ),
              Container(
                height: 40,
                width: 100,
                alignment: Alignment.center,
                child: ElevatedButton(
                    onPressed: () {
                      if (_chat.text.trim() != "") {
                        FirebaseFirestore.instance
                            .collection("chatGroups")
                            .add({
                          "LobbyName": _chat.text.trim(),
                          "collectionName": _chat.text.trim()
                        });
                      } else {
                        Get.snackbar("enter Data", "");
                      }
                    },
                    child: Text(
                      "Create",
                      style: subHeadingStyle,
                    )),
              )
            ],
          ),
        );
      },
    );
  }

  CollectionReference chatGroups =
      FirebaseFirestore.instance.collection('chatGroups');

  List<Chat> chatsList = [];
  getChats() async {
    List<Chat> newList = [];
    await chatGroups.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        newList.add(fromJsonChat(doc));
      });
    });
    chatsList = newList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        backgroundColor: Colors.transparent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Text("Discussions", style: HeadingStyle),
            ),
            CurrentUserData.type == "admin"
                ? IconButton(
                    onPressed: () {
                      _showModalBottomSheet(context);
                    },
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ))
                : Container()
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Container(
          //     margin: const EdgeInsets.only(top: 16),
          //     child: Container(
          //       height: 52,
          //       margin: const EdgeInsets.only(top: 8),
          //       padding: const EdgeInsets.only(left: 14),
          //       decoration: BoxDecoration(
          //           borderRadius: BorderRadius.circular(12),
          //           border: Border.all(
          //             color: Colors.grey,
          //             width: 1.0,
          //           )),
          //       child: Row(
          //         children: [
          //           Expanded(
          //               child: TextFormField(
          //             autofocus: false,
          //             cursorColor: Colors.grey,
          //             decoration: const InputDecoration(
          //                 prefixIcon: Icon(Icons.search),
          //                 hintText: "Search",
          //                 border: InputBorder.none),
          //           )),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          // Container(
          //   constraints: const BoxConstraints(maxHeight: 150),
          //   child: ListView.builder(
          //       itemCount: usersList.length,
          //       scrollDirection: Axis.horizontal,
          //       itemBuilder: ((context, index) {
          //         return UsersTasktile(user: usersList[index]);
          //       })),
          // ),
          Expanded(
            child: FutureBuilder(
                future: getChats(),
                builder: (context, snapshot) {
                  return ListView.builder(
                    itemCount: chatsList.length,
                    itemBuilder: (context, index) {
                      return chatTaskTile(chat: chatsList[index]);
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }
}

class Chat {
  const Chat({
    required this.lobbyName,
    required this.collectionName,
  });

  final String lobbyName;
  final String collectionName;
}

Chat fromJsonChat(QueryDocumentSnapshot json) => Chat(
      lobbyName: json['LobbyName'],
      collectionName: json['collectionName'],
    );
