// ignore_for_file: file_names, avoid_function_literals_in_foreach_calls
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:manager/services/events.dart';
import 'package:manager/services/profileService.dart';
import 'package:manager/themeData.dart';

class TaskTile extends StatefulWidget {
  final event eve;
  const TaskTile({super.key, required this.eve});

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        UserProfile creator = usersList[usersList
            .indexWhere((element) => element.uid == widget.eve.userUid)];
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    minRadius: 20,
                    maxRadius: 30,
                    foregroundImage: CachedNetworkImageProvider(
                      creator.pfp,
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    creator.name,
                    style: subHeadingStyle,
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                " ${widget.eve.title}",
                style: HeadingStyle,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    color: Colors.grey[200],
                    size: 25,
                  ),
                  const SizedBox(width: 4),
                  Text("${widget.eve.startTime} - ${widget.eve.endTime}",
                      style: subHeadingStyle),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.calendar_month,
                    color: Colors.grey[200],
                    size: 25,
                  ),
                  const SizedBox(width: 10),
                  Text(
                      "Date : ${DateFormat.MMMMEEEEd().format(widget.eve.date)}",
                      style: subHeadingStyle),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Note : ${widget.eve.note}",
                style: subHeadingStyle,
              ),
              Expanded(
                child: Container(),
              ),
              Row(
                children: [
                  widget.eve.userUid == CurrentUserData.uid ||
                          CurrentUserData.type == "admin"
                      ? ElevatedButton(
                          onPressed: () {}, child: const Text("Edit"))
                      : Container(),
                  widget.eve.userUid == CurrentUserData.uid ||
                          CurrentUserData.type == "admin"
                      ? ElevatedButton(
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection("events")
                                .doc(widget.eve.id)
                                .delete();
                            setState(() {
                              eventList.remove(widget.eve);
                            });

                            Navigator.pop(context);
                          },
                          child: const Text("Delete"))
                      : Container(),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showModalBottomSheet(context);
      },
      child: Container(
        padding: const EdgeInsets.only(left: 10),
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(bottom: 12),
        child: Container(
          padding: const EdgeInsets.all(16),
          //  width: SizeConfig.screenWidth * 0.78,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  _getBGClr(widget.eve.color),
                  _getBGClr2(widget.eve.color),
                ]),
          ),
          child: Row(children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            color: Colors.grey[200],
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "${widget.eve.startTime} - ${widget.eve.endTime}",
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                  fontSize: 13, color: Colors.grey[100]),
                            ),
                          ),
                        ],
                      ),
                      CircleAvatar(
                        foregroundImage: CachedNetworkImageProvider(usersList[
                                usersList.indexWhere((element) =>
                                    element.uid == widget.eve.userUid)]
                            .pfp),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    widget.eve.title,
                    style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.eve.note,
                    style: GoogleFonts.lato(
                      textStyle:
                          TextStyle(fontSize: 15, color: Colors.grey[100]),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              height: 60,
              width: 0.5,
              color: Colors.grey[200]!.withOpacity(0.7),
            ),
            // RotatedBox(
            //   quarterTurns: 3,
            //   child: Text(
            //     eve.isCompleted == 1 ? "COMPLETED" : "TODO",
            //     style: GoogleFonts.lato(
            //       textStyle: TextStyle(
            //           fontSize: 10,
            //           fontWeight: FontWeight.bold,
            //           color: Colors.white),
            //     ),
            //   ),
            // ),
          ]),
        ),
      ),
    );
  }

  Color _getBGClr(int no) {
    switch (no) {
      case 1:
        return bluishClr;
      case 2:
        return yelloClr;
      case 3:
        return RedClr;
      default:
        return bluishClr;
    }
  }

  Color _getBGClr2(int no) {
    switch (no) {
      case 1:
        return const Color.fromARGB(255, 75, 76, 172);
      case 2:
        return const Color.fromARGB(255, 230, 162, 53);
      case 3:
        return const Color.fromARGB(255, 230, 43, 59);
      default:
        return const Color.fromARGB(255, 75, 76, 172);
    }
  }
}
