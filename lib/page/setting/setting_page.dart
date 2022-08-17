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
      appBar: AppBar(
        leading: IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: () {
            widget.action();
          },
          icon: const Icon(FontAwesomeIcons.bars),
        ),
      ),
      body: Container(),
    );
  }
}
