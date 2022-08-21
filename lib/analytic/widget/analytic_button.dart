import 'package:flutter/material.dart';

Widget analyticButton(
    {required String text,
    required Function action,
    required Color backColor,
    required Color textColor,
    required IconData icon}) {
  return SizedBox(
    width: 150,
    height: 50,
    child: ElevatedButton.icon(
      icon: Icon(
        icon,
        color: textColor,
      ),
      onPressed: () {
        action();
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(backColor),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(90),
          ),
        ),
      ),
      label: Text(
        text,
        style: TextStyle(color: textColor, fontSize: 16),
      ),
    ),
  );
}
