import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key, required this.action}) : super(key: key);
  final Function action;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(250, 250, 255, 1),
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(
            color: Color.fromRGBO(159, 161, 184, 1), size: 25),
        backgroundColor: const Color.fromRGBO(250, 250, 255, 1),
        title: Text(
          "about".tr,
          style: const TextStyle(
              color: Color.fromRGBO(156, 166, 201, 1),
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: () {
            action();
          },
          icon: const Icon(FontAwesomeIcons.bars),
        ),
      ),
      body: Container(),
    );
  }
}
