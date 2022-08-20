import 'package:flutter/material.dart';

Widget analyticButton({required String text, required Function action}) {
  return ElevatedButton(
    onPressed: () {
      action();
    },
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(
        const Color.fromRGBO(182, 190, 240, 1),
      ),
      padding: MaterialStateProperty.all(
        const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      ),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    ),
    child: Text(
      text,
    ),
  );
}
