import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:todo_app/page/handle_todo/pick_function.dart';

Widget pickTimeWidgetItem(BuildContext context,
    {required String title,
    required Function(TimeOfDay time) action,
    required TimeOfDay time}) {
  return Column(
    children: [
      Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color.fromRGBO(182, 190, 224, 1),
        ),
      ),
      const SizedBox(height: 10),
      OutlinedButton.icon(
        onPressed: () async {
          var time = await pickTime(context);
          if (time != null) {
            action(time);
          }
        },
        style: OutlinedButton.styleFrom(
          primary: const Color.fromRGBO(182, 190, 224, 1),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        icon: const Icon(FontAwesomeIcons.clock),
        label: Text(
          timeOfDateToString(time),
          style: const TextStyle(fontSize: 16),
        ),
      ),
    ],
  );
}
