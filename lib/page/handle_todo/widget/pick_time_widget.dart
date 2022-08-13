import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/page/handle_todo/pick_file.dart';
import 'package:todo_app/page/handle_todo/widget/custom_popup_menu.dart';

Widget pickTimeWidget(BuildContext context,
    {required Function(DateTime dateTime) getDate,
    required Function(int id) getID,
    required DateTime dateTime,
    int id = 0}) {
  return Row(
    children: [
      const Spacer(),
      OutlinedButton.icon(
          onPressed: () async {
            var date = await pickDate(context, dateTime);
            if (date != null) {
              getDate(date);
            }
          },
          style: OutlinedButton.styleFrom(
            primary: const Color.fromRGBO(182, 190, 224, 1),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(90)),
            ),
          ),
          icon: const Icon(Icons.calendar_month_outlined),
          label: Text(dateTime.difference(DateTime.now()).inDays == 0
              ? "Today"
              : DateFormat("dd/MM/yyyy").format(dateTime))),
      const Spacer(),
      customPopupMenu((id) {
        getID(id);
      }, id),
      const Spacer(),
    ],
  );
}
