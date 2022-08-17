import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/page/handle_todo/pick_function.dart';
import 'package:todo_app/page/handle_todo/widget/custom_popup_menu.dart';

class PickTimeWidget extends StatelessWidget {
  const PickTimeWidget({Key? key, required this.todo, required this.action})
      : super(key: key);

  final Function(Todo todo) action;
  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Spacer(),
            InkWell(
              onTap: () async {
                var date = await pickDate(context, initDate: todo.date);
                if (date != null) {
                  todo.date = date;
                  action(todo);
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
                      todo.date.difference(getDateNow()).inDays == 0
                          ? "Today"
                          : DateFormat("dd/MM/yyyy").format(todo.date),
                      style: const TextStyle(
                          color: Color.fromRGBO(182, 190, 224, 1)),
                    )
                  ],
                ),
              ),
            ),
            const Spacer(),
            customPopupMenu((id) {
              todo.repeat = id;
              action(todo);
            }, todo.repeat),
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
                      todo.startTime = time;
                      action(todo);
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    primary: const Color.fromRGBO(182, 190, 224, 1),
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 15),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  icon: const Icon(Icons.calendar_month_outlined),
                  label: Text(timeOfDateToString(todo.startTime)),
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
                      todo.finishTime = time;
                      action(todo);
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    primary: const Color.fromRGBO(182, 190, 224, 1),
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 15),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  icon: const Icon(Icons.calendar_month_outlined),
                  label: Text(timeOfDateToString(todo.finishTime)),
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
}
