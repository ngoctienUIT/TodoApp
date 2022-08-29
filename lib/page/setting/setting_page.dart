import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:todo_app/page/setting/widget/modal_bottom_sheet_language.dart';
import 'package:todo_app/resources/localization_service.dart';

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
      // backgroundColor: const Color.fromRGBO(250, 250, 255, 1),
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(
            color: Color.fromRGBO(159, 161, 184, 1), size: 25),
        // backgroundColor: const Color.fromRGBO(250, 250, 255, 1),
        title: Text(
          "setting".tr,
          style: const TextStyle(color: Color.fromRGBO(156, 166, 201, 1)),
        ),
        // centerTitle: true,
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
        children: [languageSetting(), notifySetting()],
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
            style: const TextStyle(fontSize: 20),
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
            Text(
              "language".tr,
              style: const TextStyle(fontSize: 20),
            ),
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
