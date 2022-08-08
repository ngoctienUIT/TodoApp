import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyHome extends StatelessWidget {
  const MyHome({Key? key, required this.action}) : super(key: key);
  final Function action;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(250, 250, 255, 1),
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(
            color: Color.fromRGBO(159, 161, 184, 1), size: 16),
        backgroundColor: const Color.fromRGBO(250, 250, 255, 1),
        actions: [
          IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () {},
            icon: const Icon(FontAwesomeIcons.magnifyingGlass),
          ),
          IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () {},
            icon: const Icon(FontAwesomeIcons.bell),
          )
        ],
        leading: IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: () {
            action();
          },
          icon: const Icon(FontAwesomeIcons.bars),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add_rounded),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "What's up, TNT",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(77, 80, 108, 1),
                ),
              ),
              SizedBox(height: 30),
              Text(
                "Category",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(156, 166, 201, 1),
                ),
              ),
              SizedBox(height: 30),
              Text(
                "TODAY'S TASK",
                style: TextStyle(
                  color: Color.fromRGBO(156, 166, 201, 1),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
