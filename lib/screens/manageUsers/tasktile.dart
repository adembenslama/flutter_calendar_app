// ignore_for_file: file_names, avoid_function_literals_in_foreach_calls
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:manager/services/profileService.dart';
import 'package:manager/themeData.dart';

class UserTile extends StatefulWidget {
  final UserProfile eve;
  final String status;
  const UserTile({super.key, required this.eve, required this.status});

  @override
  State<UserTile> createState() => _UserTileState();
}

class _UserTileState extends State<UserTile> {
  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          decoration: const BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        minRadius: 20,
                        maxRadius: 30,
                        foregroundImage: CachedNetworkImageProvider(
                          widget.eve.pfp,
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Text(
                        widget.eve.name,
                        style: subHeadingStyle,
                      ),
                    ],
                  ),
                  widget.status == "active"
                      ? ElevatedButton(
                          onPressed: () async {
                            try {
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(widget.eve.uid)
                                  .update({"status": "banned"});
                            } catch (e) {}
                          },
                          child: Text("ban user"))
                      : widget.status == "pending"
                          ? ElevatedButton(
                              onPressed: () async {
                                try {
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(widget.eve.uid)
                                      .update({"status": "active"});
                                } catch (e) {}
                              },
                              child: Text("Activate Account"))
                          : ElevatedButton(
                              onPressed: () async {
                                try {
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(widget.eve.uid)
                                      .update({"status": "active"});
                                } catch (e) {}
                              },
                              child: Text("remove ban "))
                ],
              ),
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
        width: MediaQuery.of(context).size.width * 0.9,
        margin: const EdgeInsets.only(bottom: 12),
        child: Container(
          padding: const EdgeInsets.all(16),
          //  width: SizeConfig.screenWidth * 0.78,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: const Color.fromARGB(90, 92, 86, 86)),
          child: Row(children: [
            CircleAvatar(
              foregroundImage: CachedNetworkImageProvider(widget.eve.pfp),
            ),
            const SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.eve.name),
                Text(widget.eve.type),
              ],
            ),
            Expanded(
              child: Container(),
            ),
            CircleAvatar(
              backgroundColor: widget.status == "pending"
                  ? Colors.orange
                  : widget.status == "banned"
                      ? Colors.red
                      : Colors.green,
            )
          ]),
        ),
      ),
    );
  }
}
