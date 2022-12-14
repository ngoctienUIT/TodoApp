import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:todo_app/page/setting/change_profile_page.dart';
import 'package:todo_app/page/setting/widget/modal_bottom_sheet_language.dart';
import 'package:todo_app/resources/localization_service.dart';
import 'package:todo_app/values/app_styles.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key, required this.action}) : super(key: key);
  final Function action;

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("setting".tr),
        leading: IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: () {
            widget.action();
          },
          icon: const Icon(FontAwesomeIcons.bars),
        ),
      ),
      body: Column(
        children: [
          if (FirebaseAuth.instance.currentUser != null)
            itemSetting(
              action: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChangeProfilePage(),
                  ),
                );
              },
              icon: Icons.person,
              text: "Account",
            ),
          languageSetting(),
          notifySetting()
        ],
      ),
    );
  }

  Widget notifySetting() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: Colors.orange, borderRadius: BorderRadius.circular(90)),
            child: const Icon(
              Icons.notifications_rounded,
              size: 30,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 20),
          Text(
            "notification".tr,
            style: AppStyles.p,
          ),
          const Spacer(),
          Switch(
            value: false,
            onChanged: (value) {},
          ),
        ],
      ),
    );
  }

  Widget itemSetting(
      {required Function action,
      required String text,
      required IconData icon}) {
    return InkWell(
      onTap: () {
        action();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(90)),
              child: Icon(icon, size: 30, color: Colors.white),
            ),
            const SizedBox(width: 20),
            Text(text, style: AppStyles.p),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  Widget languageSetting() {
    return InkWell(
      onTap: () {
        modalBottomSheetLanguage(
          context,
          (location) {
            LocalizationService.changeLocale(location);
            Navigator.pop(context);
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(90)),
              child: const Icon(
                Icons.translate_rounded,
                size: 30,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 20),
            Text("language".tr, style: AppStyles.p),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.orange,
            ),
          ],
        ),
      ),
    );
  }
}
