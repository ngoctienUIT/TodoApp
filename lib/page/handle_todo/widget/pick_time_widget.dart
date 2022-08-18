import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/page/handle_todo/pick_function.dart';
import 'package:todo_app/page/handle_todo/widget/custom_popup.dart';
import 'package:todo_app/page/handle_todo/widget/pick_time_widget_item.dart';

class PickTimeWidget extends StatelessWidget {
  PickTimeWidget({Key? key, required this.todo, required this.action})
      : super(key: key);

  final Function(Todo todo) action;
  final Todo todo;

  final List<String> remindList = [
    "Không Lặp",
    "1 Phút",
    "5 Phút",
    "10 Phút",
    "15 phút",
    "30 phút",
    "1 giờ"
  ];

  final List<String> repeatList = [
    "Không Lặp",
    "Mỗi Ngày",
    "Mỗi Tuần",
    "Mỗi Tháng",
    "Mỗi Năm"
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: InkWell(
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
                  const Icon(
                    Icons.calendar_month_outlined,
                    size: 28,
                    color: Color.fromRGBO(182, 190, 224, 1),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    todo.date.difference(getDateNow()).inDays == 0
                        ? "Today"
                        : DateFormat("dd/MM/yyyy").format(todo.date),
                    style: const TextStyle(
                        color: Color.fromRGBO(182, 190, 224, 1), fontSize: 16),
                  )
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 30),
        Row(
          children: [
            const Spacer(),
            pickTimeWidgetItem(context, title: "Start:", action: (time) {
              todo.startTime = time;
              action(todo);
            }, time: todo.startTime),
            const Spacer(),
            pickTimeWidgetItem(context, title: "Finish:", action: (time) {
              todo.finishTime = time;
              action(todo);
            }, time: todo.finishTime),
            const Spacer(),
          ],
        ),
        const SizedBox(height: 30),
        Row(
          children: [
            const Spacer(),
            customPopup(context, list: remindList, action: (id) {
              todo.remind = id;
              action(todo);
            }, index: todo.remind),
            const Spacer(),
            customPopup(context, list: repeatList, action: (id) {
              todo.repeat = id;
              action(todo);
            }, index: todo.repeat, icon: FontAwesomeIcons.repeat),
            const Spacer(),
          ],
        ),
      ],
    );
  }
}
