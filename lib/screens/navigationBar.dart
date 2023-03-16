// ignore_for_file: camel_case_types, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:lottie/lottie.dart';

import 'package:manager/chat/mainScreenChat.dart';

import 'package:manager/screens/HomePage.dart';
import 'package:manager/screens/setting.dart';
import 'package:manager/themeData.dart';

class homenavigationPage extends StatefulWidget {
  const homenavigationPage({super.key});

  @override
  State<homenavigationPage> createState() => _navigationPageState();
}

int currentIndex = 0;

class _navigationPageState extends State<homenavigationPage> {
  List<Widget> body = [
    const HomePage(),
    const MainChatScreen(),
    const SettingsPage()
  ];
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            child: Get.isDarkMode
                ? Lottie.asset('assets/lightback.json',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity)
                : Lottie.asset('assets/darkback.json',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity)),
        Scaffold(
          backgroundColor: Get.isDarkMode
              ? Color.fromARGB(118, 51, 51, 51)
              : Color.fromARGB(70, 232, 232, 232),
          bottomNavigationBar: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: const Color.fromARGB(0, 28, 34, 56),
            ),
            child: BottomNavigationBar(
              elevation: 0,
              backgroundColor: const Color.fromARGB(0, 28, 34, 56),
              unselectedItemColor: const Color.fromARGB(80, 158, 158, 158),
              selectedItemColor: Get.isDarkMode
                  ? Colors.white
                  : Color.fromARGB(255, 255, 255, 255),
              currentIndex: currentIndex,
              onTap: (int index) {
                setState(() {
                  currentIndex = index;
                });
              },
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.calendar_month), label: 'Calendar'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.chat_bubble), label: 'chat'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.settings), label: 'settings')
              ],
            ),
          ),
          body: body[currentIndex],
        ),
      ],
    );
  }
}
