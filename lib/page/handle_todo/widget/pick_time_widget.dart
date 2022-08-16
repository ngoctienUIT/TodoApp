import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/page/handle_todo/pick_function.dart';
import 'package:todo_app/page/handle_todo/widget/custom_popup_menu.dart';

Widget pickTimeWidget(BuildContext context,
    {required Function(DateTime dateTime) getStartTime,
    required Function(DateTime dateTime) getFinishTime,
    required Function(int id) getID,
    required DateTime startTime,
    required DateTime finishTime,
    int id = 0}) {
  return Column(
    children: [
      Row(
        children: [
          const Spacer(),
          Column(
            children: [
              const Text(
                "Start:",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(182, 190, 224, 1),
                ),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () async {
                  var date = await pickDate(context, initDate: startTime);
                  if (date != null) {
                    getStartTime(date);
                    if (date.difference(finishTime).inDays >= 0) {
                      getFinishTime(date);
                    }
                  }
                },
                style: OutlinedButton.styleFrom(
                  primary: const Color.fromRGBO(182, 190, 224, 1),
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                icon: const Icon(Icons.calendar_month_outlined),
                label: Text(
                  startTime.difference(DateTime.now()).inDays == 0
                      ? "Today"
                      : DateFormat("dd/MM/yyyy").format(startTime),
                ),
              ),
            ],
          ),
          const Spacer(),
          Column(
            children: [
              const Text(
                "Finish:",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(182, 190, 224, 1),
                ),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () async {
                  var date = await pickDate(context,
                      initDate: finishTime, firstDate: startTime);
                  if (date != null) {
                    getFinishTime(date);
                  }
                },
                style: OutlinedButton.styleFrom(
                  primary: const Color.fromRGBO(182, 190, 224, 1),
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                icon: const Icon(Icons.calendar_month_outlined),
                label: Text(
                  finishTime.difference(DateTime.now()).inDays == 0
                      ? "Today"
                      : DateFormat("dd/MM/yyyy").format(finishTime),
                ),
              ),
            ],
          ),
          const Spacer(),
        ],
      ),
      const SizedBox(height: 30),
      customPopupMenu((id) {
        getID(id);
      }, id),
    ],
  );
}
