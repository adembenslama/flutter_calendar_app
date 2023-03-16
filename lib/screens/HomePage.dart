// ignore_for_file: file_names, unused_field, override_on_non_overriding_member, avoid_function_literals_in_foreach_calls, sort_child_properties_last, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

// ignore: depend_on_referenced_packages
import 'package:simple_gesture_detector/simple_gesture_detector.dart';
import 'package:intl/intl.dart';
import 'package:manager/screens/addEvent.dart';
import 'package:manager/services/events.dart';
import 'package:manager/services/profileService.dart';
import 'package:manager/services/tasktile.dart';

import 'package:manager/themeData.dart';
import 'package:manager/ui/customAppBar.dart';

import 'package:table_calendar/table_calendar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.now();
  CollectionReference events = FirebaseFirestore.instance.collection('events');
  int _firstDayCount = 0;
  int secondDayCount = 0;
  CalendarFormat format = CalendarFormat.month;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
          backgroundColor: RedClr,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () => Get.to(AddEvent())),
      appBar: myAppBar(
        titleWidget: Text(
          "Home Page",
          style: subHeadingStyle,
        ),
        leading: Container(),
      ),
      body: LiquidPullToRefresh(
        backgroundColor: Colors.white,
        color: Colors.transparent,
        showChildOpacityTransition: false,
        onRefresh: () async {
          await initilaizeList();
          setState(() {});
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Column(children: [
              const SizedBox(
                height: 10,
              ),
              Container(
                margin: const EdgeInsets.only(left: 12),
                child: GlassContainer(
                  blur: 2,
                  color: Color.fromARGB(70, 255, 255, 255),
                  borderRadius: BorderRadius.circular(20),
                  child: Column(
                    children: [
                      TableCalendar(
                        locale: 'en_US',
                        formatAnimationDuration:
                            const Duration(milliseconds: 500),
                        formatAnimationCurve: Curves.fastOutSlowIn,
                        daysOfWeekStyle: DaysOfWeekStyle(
                            weekdayStyle: GoogleFonts.lato(
                                textStyle: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            )),
                            weekendStyle: GoogleFonts.lato(
                                textStyle: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ))),
                        headerStyle: const HeaderStyle(
                            titleCentered: true, formatButtonVisible: false),
                        availableGestures: AvailableGestures.all,
                        selectedDayPredicate: (day) =>
                            isSameDay(day, _selectedDate),
                        firstDay: DateTime.utc(2022, 1, 1),
                        lastDay: DateTime.utc(2030, 3, 14),
                        focusedDay: _selectedDate,
                        calendarFormat: format,
                        onDaySelected: (date, focusedDate) {
                          setState(() {
                            _selectedDate = date;
                          });
                          print(_selectedDate.toString());
                        },
                      ),
                      SimpleGestureDetector(
                        onTap: () {
                          print("object");
                          if (format == CalendarFormat.month) {
                            setState(() {
                              format = CalendarFormat.twoWeeks;
                              print(format.toString());
                            });
                          } else if (format == CalendarFormat.twoWeeks) {
                            setState(() {
                              format = CalendarFormat.week;
                              print(format.toString());
                            });
                          } else {
                            setState(() {
                              format = CalendarFormat.month;
                              print(format.toString());
                            });
                          }
                        },
                        child: Container(
                          height: 25,
                          width: 150,
                          color: Colors.transparent,
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Container(
                              width: 150,
                              height: 10,
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        const SizedBox(
                          height: 7,
                        ),
                        Text(
                          _selectedDate.day.toString(),
                          style: subHeadingStyle,
                        ),
                        Text(
                          DateFormat.E().format(_selectedDate).toString(),
                          style: subHeadingStyle,
                        ),
                      ],
                    ),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        DateFormat.yMd().format(_selectedDate) ==
                                DateFormat.yMd().format(DateTime.now())
                            ? Text(
                                "Today",
                                style: HeadingStyle,
                              )
                            : DateFormat.yMd().format(_selectedDate) ==
                                    DateFormat.yMd().format(DateTime.now()
                                        .add(const Duration(days: 1)))
                                ? Text(
                                    "Tomorrow",
                                    style: HeadingStyle,
                                  )
                                : Text(
                                    DateFormat.MMMM().format(_selectedDate),
                                    style: HeadingStyle,
                                  ),
                      ],
                    ),
                  ],
                ),
              ),
              ListView.builder(
                  itemCount: eventList.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: ((context, index) {
                    DateTime date = eventList[index].date;

                    if (date.day == _selectedDate.day &&
                        date.month == _selectedDate.month &&
                        date.year == _selectedDate.year &&
                        CurrentUserData.type == "user" &&
                        "all" == eventList[index].access) {
                      _firstDayCount++;

                      return TaskTile(
                        eve:eventList[index],
                      );
                    } else if (CurrentUserData.type != "user" &&
                        date.day==_selectedDate.day &&
                        date.month==_selectedDate.month &&
                        date.year==_selectedDate.year) {
                      _firstDayCount++;
                      return TaskTile(
                        eve: eventList[index],
                      );
                    }
                    return Container();

                    // ListTile(
                    //   // title: Text(eventList[index].title),
                    //   // leading: IconButton(
                    //   //   icon: Icon(
                    //   //     Icons.delete_forever_outlined,
                    //   //     color: Colors.grey,
                    //   //   ),
                    //   //   onPressed: () {
                    //   //     setState(() {});
                    //   //   },
                    //   // ),

                    // );
                  })),
              Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  width: double.infinity,
                  height: 2,
                  color: const Color.fromARGB(113, 255, 255, 255)),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        const SizedBox(
                          height: 7,
                        ),
                        Text(
                          _selectedDate
                              .add(const Duration(days: 1))
                              .day
                              .toString(),
                          style: subHeadingStyle,
                        ),
                        Text(
                          DateFormat.E()
                              .format(
                                  _selectedDate.add(const Duration(days: 1)))
                              .toString(),
                          style: subHeadingStyle,
                        ),
                      ],
                    ),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        DateFormat.yMd().format(_selectedDate
                                    .add(const Duration(days: 1))) ==
                                DateFormat.yMd().format(DateTime.now())
                            ? Text(
                                "Today",
                                style: HeadingStyle,
                              )
                            : DateFormat.yMd().format(_selectedDate
                                        .add(const Duration(days: 1))) ==
                                    DateFormat.yMd().format(DateTime.now()
                                        .add(const Duration(days: 1)))
                                ? Text(
                                    "Tomorrow",
                                    style: HeadingStyle,
                                  )
                                : Text(
                                    DateFormat.MMMM().format(_selectedDate
                                        .add(const Duration(days: 1))),
                                    style: HeadingStyle,
                                  ),
                      ],
                    ),
                  ],
                ),
              ),
              ListView.builder(
                  itemCount: eventList.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: ((context, index) {
                    DateTime date = eventList[index].date;

                    if (date.day ==
                            _selectedDate.add(const Duration(days: 1)).day &&
                        date.month ==
                            _selectedDate.add(const Duration(days: 1)).month &&
                        date.year ==
                            _selectedDate.add(const Duration(days: 1)).year &&
                        CurrentUserData.type == "user" &&
                        "all" == eventList[index].access) {
                      secondDayCount++;
                      return TaskTile(
                        eve: eventList[index],
                      );
                    } else if (CurrentUserData.type == "user" &&
                        date.day ==
                            _selectedDate.add(const Duration(days: 1)).day &&
                        date.month ==
                            _selectedDate.add(const Duration(days: 1)).month &&
                        date.year ==
                            _selectedDate.add(const Duration(days: 1)).year) {
                      secondDayCount++;
                      return TaskTile(
                        eve: eventList[index],
                      );
                    }
                    return Container();
                  })),
            ]),
          ),
        ),
      ),
    );
  }
}
