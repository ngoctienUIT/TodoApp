import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/page/handle_todo/pick_function.dart';
import 'package:todo_app/page/handle_todo/widget/custom_popup_menu.dart';

Widget pickTimeWidget(BuildContext context,
    {required Function(TimeOfDay dateTime) getStartTime,
    required Function(TimeOfDay dateTime) getFinishTime,
    required Function(int id) getID,
    required Function(DateTime dateTime) getDate,
    required TimeOfDay startTime,
    required TimeOfDay finishTime,
    required DateTime dateTime,
    int id = 0}) {
  return Column(
    children: [
      Row(
        children: [
          const Spacer(),
          InkWell(
            onTap: () async {
              var date = await pickDate(context, initDate: dateTime);
              if (date != null) {
                getDate(date);
              }
            },
            child: Container(
              height: 65,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.transparent,
                border:
                    Border.all(color: const Color.fromRGBO(182, 190, 224, 1)),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.calendar_month_outlined,
                      color: Color.fromRGBO(182, 190, 224, 1)),
                  const SizedBox(width: 10),
                  Text(
                    dateTime.difference(DateTime.now()).inDays == 0
                        ? "Today"
                        : DateFormat("dd/MM/yyyy").format(dateTime),
                    style: const TextStyle(
                        color: Color.fromRGBO(182, 190, 224, 1)),
                  )
                ],
              ),
            ),
          ),
          const Spacer(),
          customPopupMenu((id) {
            getID(id);
          }, id),
          const Spacer(),
        ],
      ),
      const SizedBox(height: 30),
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
                  var time = await pickTime(context);
                  if (time != null) {
                    getStartTime(time);
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
                label: Text(timeOfDateToString(startTime)),
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
                  var time = await pickTime(context);
                  if (time != null) {
                    getFinishTime(time);
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
                label: Text(timeOfDateToString(finishTime)),
              ),
            ],
          ),
          const Spacer(),
        ],
      ),
      const SizedBox(height: 30),
    ],
  );
}
