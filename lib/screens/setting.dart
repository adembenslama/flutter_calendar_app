import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:manager/screens/SplashScreen.dart';
import 'package:manager/screens/manageAccount.dart';
import 'package:manager/services/profileService.dart';
import 'package:manager/services/themeS.dart';
import 'package:manager/themeData.dart';
import 'package:manager/ui/customAppBar.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'manageUsers/usersLIST.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
  }

  bool sw = true;
  bool notif = false;
  Icon darkModeIcon = Get.isDarkMode
      ? const Icon(Icons.nightlight_round)
      : const Icon(Icons.wb_sunny);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: myAppBar(
        leading: Container(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () => Get.to(const EditProfile()),
              child: GlassContainer(
                width: MediaQuery.of(context).size.width * 0.95,
                blur: 5,
                color: const Color.fromARGB(55, 255, 255, 255),
                height: 150,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            maxRadius: 60,
                            minRadius: 50,
                            backgroundImage: CachedNetworkImageProvider(
                              CurrentUserData.pfp,
                            ),
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            CurrentUserData.name,
                            style: HeadingStyle,
                          ),
                          Text(
                            CurrentUserData.type,
                            style: subHeadingStyle,
                          ),
                        ],
                      )
                    ]),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ListTile(
                leading: darkModeIcon,
                title: const Text("Swith themes"),
                trailing: Switch(
                  value: sw,
                  onChanged: (bo) {
                    ThemeService().switchTheme();
                    setState(() {
                      sw = !sw;
                    });
                  },
                )),
            ListTile(
                leading: const Icon(Icons.notifications),
                title: const Text("Disable Notifications"),
                trailing: Switch(
                  value: notif,
                  onChanged: (bo) async {
                    var devState = await OneSignal.shared.getDeviceState();
                    bool test = devState!.pushDisabled;

                    OneSignal.shared.disablePush(!test);
                    var dev = await OneSignal.shared.getDeviceState();
                    bool wa = dev!.pushDisabled;
                    setState(() {
                      notif = !notif;
                    });
                    Get.snackbar(
                        "Notifications ", wa ? "disabled" : "enababled");
                  },
                )),
            CurrentUserData.type == "admin"
                ? ListTile(
                    title: Text('Manage Users'),
                    leading: Icon(Icons.group),
                    onTap: () => Get.to(const UsersListPage()),
                  )
                : Container(),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              height: 60,
              child: ElevatedButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Get.to(const SplashScreen());
                  },
                  child: const Text("logout")),
            ),
          ],
        ),
      ),
    );
  }

  Widget profileInfo = SizedBox(
    width: double.infinity,
    height: 90,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CurrentUserData.pfp == "pfp"
            ? GestureDetector(
                onTap: () {},
                child: const CircleAvatar(
                    minRadius: 50,
                    maxRadius: 70,
                    backgroundImage: AssetImage("assets/user.png")),
              )
            : GestureDetector(
                onTap: () {},
                child: CircleAvatar(
                  minRadius: 60,
                  maxRadius: 70,
                  backgroundImage: NetworkImage(
                    CurrentUserData.pfp,
                  ),
                ),
              ),
        Column(
          children: [
            Text(CurrentUserData.name),
            Text("${CurrentUserData.type} account")
          ],
        ),
        IconButton(
            onPressed: () => Get.to(() => const EditProfile()),
            icon: const Icon(
              Icons.edit,
              color: Colors.red,
              size: 40,
            ))
      ],
    ),
  );
}
