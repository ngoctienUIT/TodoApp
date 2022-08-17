import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:todo_app/model/local_notification_manager.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/model/todo_database.dart';
import 'package:todo_app/page/handle_todo/edit_todo_page.dart';
import 'package:todo_app/page/handle_todo/pick_function.dart';
import 'package:todo_app/page/home/bloc/todo_bloc.dart';
import 'package:todo_app/page/home/bloc/todo_event.dart';
import 'package:todo_app/page/home/widget/custom_button.dart';

class ItemTodo extends StatefulWidget {
  const ItemTodo({Key? key, required this.todo}) : super(key: key);
  final Todo todo;

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
        color: widget.todo.color,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: IntrinsicHeight(
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    finsishTask();
                  },
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: widget.todo.status == true
                          ? Colors.blue
                          : Colors.white,
                      borderRadius: BorderRadius.circular(90),
                      border: Border.all(color: Colors.blue, width: 2),
                    ),
                    child: widget.todo.status == true
                        ? const Icon(
                            FontAwesomeIcons.check,
                            color: Colors.white,
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
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: widget.todo.status
                              ? Colors.black54
                              : Colors.black,
                          decoration: widget.todo.status
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(FontAwesomeIcons.clock, size: 16),
                          const SizedBox(width: 5),
                          Text(
                              "${timeOfDateToString(widget.todo.startTime)} - ${timeOfDateToString(widget.todo.finishTime)}")
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
                              ? Colors.black54
                              : Colors.black,
                          decoration: widget.todo.status
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                const VerticalDivider(
                  thickness: 1,
                  width: 20,
                  color: Colors.black,
                ),
                RotatedBox(
                  quarterTurns: -1,
                  child: Text(widget.todo.status ? "FINISH" : "TODO"),
                ),
                const SizedBox(width: 5)
              ],
            ),
          ),
        ),
      ),
    );
  }

  void finsishTask() => setState(() {
        widget.todo.status = !widget.todo.status;
        TodoDatabase().updateTodo(widget.todo);

        LocalNotificationManager localNotificationManager =
            LocalNotificationManager.init();
        localNotificationManager.cancelNotification(widget.todo.id.hashCode);
        localNotificationManager.showNotification(
            id: widget.todo.id.hashCode - 1,
            title: "Hoàn thành",
            body: widget.todo.content);
      });

  void modalBottomSheetMenu() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        builder: (builder) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
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
                      finsishTask();
                    },
                    text: "Finish"),
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
                    text: "Edit"),
                const SizedBox(height: 15),
                customButton(
                    color: const Color.fromRGBO(57, 126, 116, 1),
                    action: () async {
                      await Share.share("text");
                      if (!mounted) return;

                      Navigator.pop(context);
                    },
                    text: "Share"),
                const SizedBox(height: 15),
                customButton(
                    color: Colors.red,
                    action: () async {
                      await TodoDatabase().deleteTodo(widget.todo.id);
                      if (!mounted) return;
                      BlocProvider.of<TodoBloc>(context).add(DeleteEvent());
                      Navigator.pop(context);
                    },
                    text: "Delete"),
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
                            side:
                                const BorderSide(color: Colors.red, width: 2)),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Close",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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
