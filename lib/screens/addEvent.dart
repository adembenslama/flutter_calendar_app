// ignore_for_file: unused_element, dead_code, no_leading_underscores_for_local_identifiers, file_names, non_constant_identifier_names, use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:manager/services/events.dart';
import 'package:manager/services/profileService.dart';
import 'package:manager/themeData.dart';
import 'package:manager/ui/widgets/button.dart';
import 'package:manager/ui/widgets/myInput.Dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:manager/ui/customAppBar.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../OneSignalNotification/usersList.dart';

class AddEvent extends StatefulWidget {
  const AddEvent({super.key});

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  bool isAddButtonActiv = false;
  final currentUser = FirebaseAuth.instance.currentUser!;
  CollectionReference events = FirebaseFirestore.instance.collection('events');
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _endTime = "12:00";
  String _startTime = DateFormat("HH:mm ").format(DateTime.now()).toString();
  int _selectedValue = 1;
  int _colorIndex = 1;
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const myAppBar(
        leading: BackButton(),
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Add event ",
              style: HeadingStyle,
            ),
            //first field

            MyInputField(
              title: "Title",
              hint: "enter the title",
              controller: _titleController,
            ),
            // second
            MyInputField(
              title: "Description",
              hint: "Add a description",
              controller: _noteController,
            ),
            //third
            MyInputField(
              title: "Date",
              hint: DateFormat.yMd().format(_selectedDate),
              widget: IconButton(
                icon: const Icon(
                  Icons.calendar_today_outlined,
                  color: Colors.grey,
                ),
                onPressed: () {
                  _getDateFromUser();
                },
              ),
            ),
            //fourth
            Row(
              children: [
                Expanded(
                  child: MyInputField(
                    hint: _startTime,
                    readOnly: true,
                    title: "Start Time",
                    widget: IconButton(
                      icon: const Icon(
                        Icons.access_time_outlined,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        _getTimeFromUser(true);
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: MyInputField(
                    hint: _endTime,
                    title: "End Time ",
                    readOnly: true,
                    widget: IconButton(
                      icon: const Icon(
                        Icons.access_time_outlined,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        _getTimeFromUser(false);
                      },
                    ),
                  ),
                ),
              ],
            ),
            //fifth
            CurrentUserData.type != "user"
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Acess",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 15),
                      ),
                      Row(
                        children: [
                          Radio(
                            value: 1,
                            groupValue: _selectedValue,
                            onChanged: (value) {
                              setState(() {
                                _selectedValue = value!;
                              });
                            },
                          ),
                          const Text(
                            "everyone",
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 15),
                          ),
                          Radio(
                            value: 2,
                            groupValue: _selectedValue,
                            onChanged: (value) {
                              setState(() {
                                _selectedValue = value!;
                              });
                            },
                          ),
                          const Text("Mangers",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 15)),
                        ],
                      ),
                    ],
                  )
                : Container(),
            //seventh
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(" Color",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 15)),
                    Wrap(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _colorIndex = 1;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              radius: 14,
                              backgroundColor: Colors.blue,
                              child: _colorIndex == 1
                                  ? const Icon(
                                      Icons.done,
                                      color: Colors.white,
                                    )
                                  : Container(),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _colorIndex = 2;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              radius: 14,
                              backgroundColor: Colors.yellow,
                              child: _colorIndex == 2
                                  ? const Icon(
                                      Icons.done,
                                      color: Colors.white,
                                    )
                                  : Container(),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _colorIndex = 3;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              radius: 14,
                              backgroundColor: Colors.red,
                              child: _colorIndex == 3
                                  ? const Icon(
                                      Icons.done,
                                      color: Colors.white,
                                    )
                                  : Container(),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                //myButton(label: "Save", onTaped: () => _validateForm())
                Container(
                  height: 60,
                  width: 100,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(30)),
                  child: Expanded(
                      child: MyButton(
                    onTap: isAddButtonActiv == true
                        ? null
                        : (() async {
                            setState(() {
                              isAddButtonActiv = true;
                            });
                            await _validateForm();
                            await initilaizeList();
                            _notifyUsers();
                            setState(() {});
                            Get.back();
                          }),
                    label: "validate",
                  )),
                )
              ],
            ),
          ],
        )),
      ),
    );
  }

  _validateForm() async {
    if (_noteController.text.isNotEmpty && _titleController.text.isNotEmpty) {
      await events.doc(DateTime.now().toString()).set({
        'title': _titleController.text,
        'note': _noteController.text,
        'date': _selectedDate,
        'start Time': _startTime,
        'end Time': _endTime,
        'Color': _colorIndex,
        'user': CurrentUserData.uid,
        'access': _selectedValue == 1 ? "all" : "Managers",
      }).then((value) => print('user added'));
    } else if (_noteController.text.isEmpty || _titleController.text.isEmpty) {
      print("ez");
    }
    var notification = OSCreateNotification(
      content: '${CurrentUserData.name} added a new event ! ',
      playerIds:
          _selectedValue == 1 ? usersListOneSignal : managersListOneSignal,
    );

    OneSignal.shared.postNotification(notification);
  }

  _getTimeFromUser(bool isStartTime) async {
    var _pickedTime = await _showTimePicker();
    String _formattedTime = _pickedTime.format(context);
    if (_pickedTime == null) {
      print("nonononononononono");
    } else if (isStartTime == true) {
      setState(() {
        _startTime = _formattedTime;
      });
    } else {
      setState(() {
        _endTime = _formattedTime;
      });
    }
  }

  _showTimePicker() async {
    return await showTimePicker(
        context: context,
        initialTime: TimeOfDay(
            hour: int.parse(_startTime.split(":")[0]),
            minute: int.parse(_startTime.split(":")[1][1])),
        initialEntryMode: TimePickerEntryMode.input);
  }

  _notifyUsers() {
    var notification = OSCreateNotification(
      content: '${CurrentUserData.name} added a new event ! ',
      playerIds: ["c8dda79e-b088-4c43-8e47-79bd2ac81fcb"],
    );

    OneSignal.shared.postNotification(notification);
  }

  _getDateFromUser() async {
    // ignore: unused_local_variable,
    DateTime? _pickerDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2035));
    if (_pickerDate != null) {
      setState(() {
        _selectedDate = _pickerDate;
      });
    }
  }
}
