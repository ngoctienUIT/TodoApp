import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/model/todo_database.dart';
import 'package:todo_app/page/handle_todo/edit_todo_page.dart';
import 'package:todo_app/page/home/bloc/todo_bloc.dart';
import 'package:todo_app/page/home/bloc/todo_event.dart';

class ItemTodo extends StatefulWidget {
  const ItemTodo({Key? key, required this.todo}) : super(key: key);
  final Todo todo;

  @override
  State<ItemTodo> createState() => _ItemTodoState();
}

class _ItemTodoState extends State<ItemTodo> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditTodoPage(todo: widget.todo),
          ),
        );
      },
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditTodoPage(todo: widget.todo),
                  ),
                );
              },
              backgroundColor: const Color(0xFF7BC043),
              foregroundColor: Colors.white,
              icon: FontAwesomeIcons.penToSquare,
              borderRadius: BorderRadius.circular(10),
            ),
            SlidableAction(
              onPressed: (context) async {
                Share.share(widget.todo.content);
              },
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              icon: FontAwesomeIcons.share,
              borderRadius: BorderRadius.circular(10),
            ),
            SlidableAction(
              onPressed: (context) async {
                await TodoDatabase().deleteTodo(widget.todo.id);
                if (!mounted) return;
                BlocProvider.of<TodoBloc>(context).add(DeleteEvent());
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: FontAwesomeIcons.trashCan,
              borderRadius: BorderRadius.circular(10),
            ),
          ],
        ),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      widget.todo.status = !widget.todo.status;
                      TodoDatabase().updateTodo(widget.todo);
                    });
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
                  child: Text(
                    widget.todo.content,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18,
                      color: widget.todo.status ? Colors.black54 : Colors.black,
                      decoration: widget.todo.status
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                ),
                const SizedBox(width: 10)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
