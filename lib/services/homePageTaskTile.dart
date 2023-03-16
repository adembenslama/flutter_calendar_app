// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:manager/services/events.dart';
import 'package:manager/services/eventsDetails.dart';
import 'package:manager/services/profileService.dart';
import 'package:manager/themeData.dart';

class HomeTaskTile extends StatelessWidget {
  final int heroTag;
  final event eve;
  const HomeTaskTile({super.key, required this.eve, required this.heroTag});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => EventsDetails(
            heroTag: heroTag,
            eve: eve,
          )),
      child: Container(
        padding: const EdgeInsets.only(left: 10),
        width: MediaQuery.of(context).size.width * 0.6,
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
                    _getBGClr(eve.color),
                    _getBGClr2(eve.color),
                  ])),
          child: Row(children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        eve.title,
                        style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      CircleAvatar(
                        foregroundImage: NetworkImage(usersList[
                                usersList.indexWhere(
                                    (element) => element.uid == eve.userUid)]
                            .pfp),
                        maxRadius: 14,
                      )
                    ],
                  ),
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
                        "${eve.startTime} - ${eve.endTime}",
                        style: GoogleFonts.lato(
                          textStyle:
                              TextStyle(fontSize: 13, color: Colors.grey[100]),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    DateFormat.yMEd().format(eve.date),
                    style: GoogleFonts.lato(
                      textStyle:
                          TextStyle(fontSize: 15, color: Colors.grey[100]),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    eve.note,
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
