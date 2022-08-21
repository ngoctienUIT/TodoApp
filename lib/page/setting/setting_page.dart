import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
      backgroundColor: const Color.fromRGBO(250, 250, 255, 1),
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(
            color: Color.fromRGBO(159, 161, 184, 1), size: 25),
        backgroundColor: const Color.fromRGBO(250, 250, 255, 1),
        title: const Text(
          "Setting",
          style: TextStyle(color: Color.fromRGBO(156, 166, 201, 1)),
        ),
        centerTitle: true,
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
          const SizedBox(height: 20),
          Row(
            children: [
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(90)),
                child: const Icon(
                  Icons.notifications_rounded,
                  size: 30,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 20),
              const Text(
                "Thông báo",
                style: TextStyle(fontSize: 20),
              ),
              const Spacer(),
              Switch(
                value: false,
                onChanged: (value) {},
              ),
              const SizedBox(width: 20)
            ],
          )
        ],
      ),
    );
  }
}
