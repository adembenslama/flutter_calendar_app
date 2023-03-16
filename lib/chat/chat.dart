// ignore_for_file: library_private_types_in_public_api, avoid_print, must_be_immutable

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:manager/chat/mainScreenChat.dart';
import 'package:manager/services/profileService.dart';
import 'package:manager/themeData.dart';
import 'package:manager/ui/customAppBar.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../OneSignalNotification/usersList.dart';

class ChatScreen extends StatefulWidget {
  Chat chat;
  ChatScreen({super.key, required this.chat});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    notifyUsers(String username, String message, bool isImage) {
      var notification = OSCreateNotification(
        content: '$username : ',
        bigPicture: message,
        playerIds: usersListOneSignal,
      );

      OneSignal.shared.postNotification(notification);
    }

    PickedFile? _image;
    UploadTask? uploadTask;
    Future uploadFile() async {
      final path = '${widget.chat.collectionName}/${_image!.path}';

      final file = File(_image!.path);
      final ref = FirebaseStorage.instance.ref().child(path);
      uploadTask = ref.putFile(file);
      final snapshot = await uploadTask!.whenComplete(() {});
      final urlDownload = await snapshot.ref.getDownloadURL();
      await _firestore.collection(widget.chat.collectionName).add({
        'text': urlDownload,
        'sender': CurrentUserData.uid,
        'type': "image",
        'time': DateTime.now().millisecondsSinceEpoch,
      });
      notifyUsers(CurrentUserData.name, urlDownload, true);
    }

    void selectFile() async {
      var image = await ImagePicker.platform
          .pickImage(source: ImageSource.gallery, imageQuality: 50);

      setState(() {
        _image = image;
      });
      uploadFile();
    }

    return Scaffold(
      appBar: myAppBar(
        Texte: widget.chat.lobbyName,
        cornerWidget: const Icon(Icons.settings),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(
              chat: widget.chat,
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(
                    width: 10,
                  ),
                  IconButton(
                      onPressed: () {
                        selectFile();
                      },
                      icon: const Icon(
                        Icons.image,
                        color: Colors.red,
                      )),
                  Expanded(
                    child: TextField(
                      controller: _textController,
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (_textController.text != "") {
                          _firestore
                              .collection(widget.chat.collectionName)
                              .add({
                            'text': _textController.text,
                            'sender': CurrentUserData.uid,
                            'type': "text",
                            'time': DateTime.now().millisecondsSinceEpoch,
                          });
                          notifyUsers(CurrentUserData.name,
                              _textController.text, false);
                        }
                        _textController.clear();
                      },
                      child: const Icon(Icons.send)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  Chat chat;
  MessageStream({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(chat.collectionName)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }

        final messages = snapshot.data?.docs;
        List<MessageBubble> messageBubbles = [];

        messages?.forEach((message) async {
          final messageText = message['text'];
          final messageSender = message['sender'];
          final messageType = message['type'];
          final int time = message['time'];

          final messageBubble = MessageBubble(
            type: messageType,
            collectionName: chat.collectionName,
            id: message.id,
            sender: messageSender,
            text: messageText,
            time: time,
          );
          messageBubbles.add(messageBubble);
          messageBubbles.sort((b, a) => a.time.compareTo(b.time));
        });

        return Expanded(
          child: ListView.builder(
            reverse: true,
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            itemCount: messageBubbles.length,
            itemBuilder: (context, index) {
              if (index == messageBubbles.length - 1) {
                return Column(
                  children: [
                    ShowDate(
                      time: messageBubbles[index].time,
                    ),
                    messageBubbles[index]
                  ],
                );
              }
              if (messageBubbles[index].time - messageBubbles[index + 1].time >
                  3600000) {
                return Column(
                  children: [
                    ShowDate(
                      time: messageBubbles[index].time,
                    ),
                    messageBubbles[index]
                  ],
                );
              } else {
                return messageBubbles[index];
              }
            },
          ),
        );
      },
    );
  }
}

class ShowDate extends StatefulWidget {
  final int time;
  const ShowDate({required this.time, super.key});

  @override
  State<ShowDate> createState() => _ShowDateState();
}

class _ShowDateState extends State<ShowDate> {
  DateTime now = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: now.day == DateTime.fromMillisecondsSinceEpoch(widget.time).day
          ? Text(DateFormat.Hm()
              .format(DateTime.fromMillisecondsSinceEpoch(widget.time))
              .toString())
          : Text(DateFormat.MMMEd()
                  .format(DateTime.fromMillisecondsSinceEpoch(widget.time))
                  .toString() +
              "   " +
              DateFormat.Hm()
                  .format(DateTime.fromMillisecondsSinceEpoch(widget.time))
                  .toString()),
    );
  }
}

class MessageBubble extends StatefulWidget {
  final String collectionName;

  const MessageBubble(
      {super.key,
      required this.sender,
      required this.type,
      required this.text,
      required this.time,
      required this.collectionName,
      required this.id});
  final String id;
  final String sender;
  final String type;
  final String text;
  final int time;

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: widget.sender == CurrentUserData.uid
            ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        CurrentUserData.name,
                        style: const TextStyle(
                          fontSize: 12.0,
                        ),
                      ),
                      GestureDetector(
                        onLongPress: () {
                          showOptions(
                              context, widget.id, widget.collectionName);
                        },
                        child: widget.type == "text"
                            ? Material(
                                borderRadius: BorderRadius.circular(30.0),
                                elevation: 5.0,
                                color: Colors.lightBlueAccent,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 20.0),
                                  child: Container(
                                      constraints: BoxConstraints(
                                          maxWidth: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5),
                                      child: Text(widget.text,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 15.0,
                                          ))),
                                ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: CachedNetworkImage(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  imageUrl: widget.text,
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) =>
                                          CircularProgressIndicator(
                                              value: downloadProgress.progress),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                      CurrentUserData.pfp,
                    ),
                  )
                ],
              )
            : StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.sender)
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  UserProfile senderData =
                      UserProfile("name", "uid", "pfp", "user");

                  try {
                    senderData.name = snapshot.data['name'];
                    senderData.uid = widget.sender;
                    senderData.type = snapshot.data['type'];
                    senderData.pfp = snapshot.data['pfp'];
                  } catch (e) {
                    print(e.toString());
                  }

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(
                          senderData.pfp,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            senderData.name,
                            style: const TextStyle(
                              fontSize: 12.0,
                            ),
                          ),
                          widget.type == "text"
                              ? Material(
                                  borderRadius: BorderRadius.circular(30.0),
                                  elevation: 5.0,
                                  color: Colors.lightBlueAccent,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 20.0),
                                    child: Container(
                                        constraints: BoxConstraints(
                                            maxWidth: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.5),
                                        child: Text(widget.text,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 15.0,
                                            ))),
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: CachedNetworkImage(
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    imageUrl: widget.text,
                                    progressIndicatorBuilder: (context, url,
                                            downloadProgress) =>
                                        CircularProgressIndicator(
                                            value: downloadProgress.progress),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                        ],
                      ),
                    ],
                  );
                },
              ));
  }
}

void showOptions(BuildContext context, String chat, String collectionName) {
  showModalBottomSheet(
    context: context,
    builder: (context) => Wrap(
      children: [
        ListTile(
          leading: const Icon(Icons.delete),
          title: const Text('Delete'),
          onTap: () {
            // Perform delete action
            deleteMessage(chat, collectionName);
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}

void deleteMessage(String chat, String collectionName) {
  FirebaseFirestore.instance.collection(collectionName).doc(chat).delete();
}

BoxDecoration kMessageContainerDecoration = const BoxDecoration(
  border: Border(
    top: BorderSide(color: RedClr, width: 1.0),
  ),
);

Future<UserProfile> getSenderData(String uid) async {
  DocumentSnapshot stm =
      await FirebaseFirestore.instance.collection("users").doc(uid).get();
  return UserProfile(stm['name'], uid, stm['pfp'], stm['isManager']);
}
