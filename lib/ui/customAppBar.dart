// ignore_for_file: non_constant_identifier_names, file_names

import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:manager/screens/navigationBar.dart';

// ignore: camel_case_types
class myAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String Texte;
  final Widget? leading;
  final Widget? titleWidget;
  final Widget? cornerWidget;

  const myAppBar({
    Key? key,
    this.Texte = "",
    this.leading,
    this.cornerWidget,
    this.titleWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.all(8),
      child: Stack(
        children: [
          Positioned.fill(
              child: titleWidget == null
                  ? Center(
                      child: Text(Texte),
                    )
                  : Center(
                      child: titleWidget!,
                    )),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              leading ??
                  Transform.translate(
                    offset: const Offset(-14, 0),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new),
                      onPressed: () => Get.to(() => const homenavigationPage()),
                    ),
                  ),
            ],
          ),
          cornerWidget != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [cornerWidget!],
                )
              : Container()
        ],
      ),
    ));
  }

  @override
  Size get preferredSize => const Size(double.maxFinite, 60);
}
