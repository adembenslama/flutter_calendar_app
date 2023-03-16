// ignore_for_file: file_names
// // ignore_for_file: file_names, camel_case_types
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:manager/services/profileService.dart';

// class UsersTasktile extends StatelessWidget {
//   final UserProfile user;
//   const UsersTasktile({super.key, required this.user});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(5),
//       margin: const EdgeInsets.symmetric(horizontal: 10),
//       child: Column(
//         children: [
//           CircleAvatar(
//               minRadius: 30,
//               maxRadius: 40,
//               backgroundImage: NetworkImage(user.pfp)),
//           const SizedBox(
//             height: 5,
//           ),
//           Text(
//             user.name,
//             style: GoogleFonts.lato(
//                 textStyle: const TextStyle(
//               fontSize: 15,
//               fontWeight: FontWeight.w600,
//             )),
//           )
//         ],
//       ),
//     );
//   }
// }
