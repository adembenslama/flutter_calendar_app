// ignore_for_file: camel_case_types, constant_identifier_names, non_constant_identifier_names, file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color RedClr = Color(0xFFCC2936);
const Color bluishClr = Color(0xFF6667AB);
const Color yelloClr = Color(0xFFFFB746);
const Color pinkClr = Color(0xFFff4667);
const Color white = Colors.white;
const primaryClr = RedClr;
const Color darkGreyClr = Color(0xFF121212);
Color darkHeaderColor = const Color(0xFF424242);

class themes {
  static final light = ThemeData(
      primarySwatch: Colors.red,
      primaryColor: RedClr,
      brightness: Brightness.light,
      useMaterial3: true);
  static final dark = ThemeData(
      primarySwatch: Colors.red,
      primaryColor: darkGreyClr,
      brightness: Brightness.dark,
      useMaterial3: true);
}

TextStyle get subHeadingStyle {
  return GoogleFonts.lato(
      textStyle: const TextStyle(
    fontSize: 20,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  ));
}

TextStyle get HeadingStyle {
  return GoogleFonts.lato(
      textStyle: const TextStyle(
    fontSize: 30,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  ));
}
