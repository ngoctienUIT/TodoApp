import 'package:flutter/material.dart';
import 'package:todo_app/values/app_styles.dart';

Widget customButton(
    {required Color color, required Function action, required String text}) {
  return SizedBox(
    width: double.infinity,
    height: 50,
    child: ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(color),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      onPressed: () {
        action();
      },
      child: Text(
        text,
        style: AppStyles.h5,
      ),
    ),
  );
}
