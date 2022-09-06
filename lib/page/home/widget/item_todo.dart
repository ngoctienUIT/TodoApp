import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/model/todo_database.dart';
import 'package:todo_app/page/handle_todo/edit_todo_page.dart';
import 'package:todo_app/page/handle_todo/pick_function.dart';
import 'package:todo_app/page/home/bloc/todo_bloc.dart';
import 'package:todo_app/page/home/bloc/todo_event.dart';
import 'package:todo_app/page/home/widget/custom_button.dart';
import 'package:todo_app/values/app_styles.dart';

class ItemTodo extends StatefulWidget {
  const ItemTodo({Key? key, required this.todo, required this.filter})
      : super(key: key);
  final Todo todo;
  final bool filter;

  @override
  State<ItemTodo> createState() => _ItemTodoState();
}

class _ItemTodoState extends State<ItemTodo> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditTodoPage(todo: widget.todo),
          ),
        );
      },
      onLongPress: () {
        modalBottomSheetMenu();
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: widget.todo.status
            ? widget.todo.color.withOpacity(0.7)
            : widget.todo.color,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: IntrinsicHeight(
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    finishTask();
                    BlocProvider.of<TodoBloc>(context)
                        .add(CompleteEvent(todo: widget.todo));
                  },
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: widget.todo.status ? Colors.white54 : Colors.white,
                      borderRadius: BorderRadius.circular(90),
                    ),
                    child: widget.todo.status
                        ? Icon(
                            FontAwesomeIcons.check,
                            color: widget.todo.color,
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.todo.title,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: AppStyles.h4.copyWith(
                          color: widget.todo.status
                              ? Colors.white54
                              : Colors.white,
                          decoration: widget.todo.status
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      Divider(
                          color: widget.todo.status
                              ? Colors.white54
                              : Colors.white,
                          thickness: 1),
                      const SizedBox(height: 10),
                      if (!widget.filter)
                        Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  FontAwesomeIcons.calendarDays,
                                  size: 16,
                                  color: widget.todo.status
                                      ? Colors.white54
                                      : Colors.white,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  DateFormat("dd/MM/yyyy")
                                      .format(widget.todo.date),
                                  style: TextStyle(
                                    color: widget.todo.status
                                        ? Colors.white54
                                        : Colors.white,
                                    decoration: widget.todo.status
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 10)
                          ],
                        ),
                      Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.clock,
                            size: 16,
                            color: widget.todo.status
                                ? Colors.white54
                                : Colors.white,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            "${timeOfDateToString(widget.todo.startTime)} - ${timeOfDateToString(widget.todo.finishTime)}",
                            style: TextStyle(
                              color: widget.todo.status
                                  ? Colors.white54
                                  : Colors.white,
                              decoration: widget.todo.status
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.todo.content,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          color: widget.todo.status
                              ? Colors.white54
                              : Colors.white,
                          decoration: widget.todo.status
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                VerticalDivider(
                  thickness: 1,
                  width: 20,
                  color: widget.todo.status ? Colors.white54 : Colors.white,
                ),
                RotatedBox(
                  quarterTurns: -1,
                  child: Text(
                    widget.todo.status ? "FINISH" : "TODO",
                    style: TextStyle(
                      color: widget.todo.status ? Colors.white54 : Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 5)
              ],
            ),
          ),
        ),
      ),
    );
  }

  void finishTask() => setState(() {
        widget.todo.status = !widget.todo.status;
        TodoDatabase().updateTodo(widget.todo);
      });

  void modalBottomSheetMenu() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        builder: (builder) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(213, 210, 213, 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const Spacer(),
                customButton(
                    color: const Color.fromRGBO(60, 66, 194, 1),
                    action: () {
                      Navigator.pop(context);
                      finishTask();
                      BlocProvider.of<TodoBloc>(context)
                          .add(CompleteEvent(todo: widget.todo));
                    },
                    text: widget.todo.status ? "Todo" : "Finish"),
                const SizedBox(height: 15),
                customButton(
                    color: const Color.fromRGBO(184, 207, 72, 1),
                    action: () {
                      Navigator.pop(context);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditTodoPage(todo: widget.todo),
                        ),
                      );
                    },
                    text: "edit".tr),
                const SizedBox(height: 15),
                customButton(
                    color: const Color.fromRGBO(57, 126, 116, 1),
                    action: () async {
                      await Share.share("text");
                      if (!mounted) return;

                      Navigator.pop(context);
                    },
                    text: "share".tr),
                const SizedBox(height: 15),
                customButton(
                    color: Colors.red,
                    action: () {
                      BlocProvider.of<TodoBloc>(context)
                          .add(DeleteEvent(todo: widget.todo));
                      Navigator.pop(context);
                    },
                    text: "delete".tr),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: const BorderSide(color: Colors.red, width: 2),
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "close".tr,
                      style: AppStyles.h5.copyWith(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        });
  }
}
