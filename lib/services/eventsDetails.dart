// ignore_for_file: file_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:manager/services/events.dart';
import 'package:manager/services/profileService.dart';
import 'package:manager/themeData.dart';
import 'package:manager/ui/customAppBar.dart';

class EventsDetails extends StatelessWidget {
  final event eve;
  final int heroTag;
  const EventsDetails({super.key, required this.eve, required this.heroTag});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const myAppBar(
        leading: BackButton(),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Hero(
              tag: "tag-$heroTag",
              child: Container(
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                    color: _getBGClr(eve.color),
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          CircleAvatar(
                            foregroundImage: CachedNetworkImageProvider(
                                usersList[usersList.indexWhere((element) =>
                                        element.uid == eve.userUid)]
                                    .pfp),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            usersList[usersList.indexWhere(
                                    (element) => element.uid == eve.userUid)]
                                .name,
                            style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            )),
                          )
                        ],
                      ),
                      Text(
                        eve.title,
                        style: GoogleFonts.lato(
                            textStyle: const TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        )),
                      ),
                      Text(
                        eve.note,
                        style: GoogleFonts.lato(
                            textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        )),
                      ),
                      Text("${eve.startTime} - ${eve.endTime}",
                          style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ))),
                      Text(
                        DateFormat.yMMMMEEEEd().format(eve.date).toString(),
                        style: GoogleFonts.lato(
                            textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        )),
                      ),
                      eve.access == "Managers"
                          ? Text(
                              eve.access,
                              style: GoogleFonts.lato(
                                  textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              )),
                            )
                          : Container()
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
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
}
