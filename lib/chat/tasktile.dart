// ignore_for_file: file_names, camel_case_types

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manager/chat/chat.dart';
import 'package:manager/themeData.dart';
import 'mainScreenChat.dart';

class chatTaskTile extends StatelessWidget {
  final Chat chat;
  const chatTaskTile({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => Get.to(ChatScreen(chat: chat)),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white12,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(20),
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.all(10),
            child: Container(
                padding: const EdgeInsets.all(5),
                //  width: SizeConfig.screenWidth * 0.78,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  chat.lobbyName,
                  style: subHeadingStyle,
                )),
          ),
        ),
      ],
    );
  }
}
