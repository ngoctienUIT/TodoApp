import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:todo_app/model/data_sql.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/model/todo_database.dart';
import 'package:todo_app/page/handle_todo/pick_file.dart';
import 'package:todo_app/page/handle_todo/widget/add_file_widget.dart';
import 'package:todo_app/page/handle_todo/widget/custom_popup_menu.dart';
import 'package:todo_app/page/handle_todo/widget/image_list_widget.dart';
import 'package:todo_app/page/home/bloc/todo_bloc.dart';
import 'package:todo_app/page/home/bloc/todo_event.dart';

class EditTodoPage extends StatefulWidget {
  const EditTodoPage({Key? key, required this.todo}) : super(key: key);
  final Todo todo;

  @override
  State<EditTodoPage> createState() => _EditTodoPageState();
}

class _EditTodoPageState extends State<EditTodoPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.todo.content;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          widget.todo.content = _controller.text;
          await TodoDatabase().updateTodo(widget.todo);
          if (!mounted) return;
          BlocProvider.of<TodoBloc>(context).add(UpdateEvent());
          Navigator.pop(context);
        },
        label: Row(
          children: const [
            Text("Update task"),
            SizedBox(width: 10),
            Icon(
              FontAwesomeIcons.angleUp,
              size: 20,
            )
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      primary: Colors.black87,
                      fixedSize: const Size(55, 55),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(90)),
                      ),
                    ),
                    child: const Icon(Icons.close_rounded),
                  ),
                  const SizedBox(width: 30),
                ],
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    labelStyle: TextStyle(fontSize: 16),
                    hintStyle: TextStyle(fontSize: 16),
                    hintText: 'Enter new task',
                  ),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                ),
              ),
              FutureBuilder<List<DataSql>>(
                future: TodoDatabase().getImageData(widget.todo.id),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.isNotEmpty) {
                      return imageListWidget(
                          snapshot.data!.map((data) => data.link).toList());
                    }
                  }
                  return Container();
                },
              ),
              const SizedBox(height: 20),
              FutureBuilder<List<DataSql>>(
                  future: TodoDatabase().getFileData(widget.todo.id),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return imageListWidget(
                          snapshot.data!.map((data) => data.link).toList());
                    }
                    return Container();
                  }),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Spacer(),
                  OutlinedButton.icon(
                    onPressed: () async {
                      var date = await pickDate(context, widget.todo.time);
                      if (date != null) {
                        setState(() {
                          widget.todo.time = date;
                        });
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      primary: const Color.fromRGBO(182, 190, 224, 1),
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 15),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(90)),
                      ),
                    ),
                    icon: const Icon(Icons.calendar_month_outlined),
                    label: const Text("Today"),
                  ),
                  const Spacer(),
                  customPopupMenu((index) {
                    setState(() {
                      widget.todo.repeat = index;
                    });
                  }, widget.todo.repeat),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 30),
              addFileWidget(
                getImage: (list) => setState(() {
                  widget.todo.images.addAll(list);
                }),
                getFile: (list) => setState(() {
                  widget.todo.files.addAll(list);
                }),
                isListening: true,
              ),
              const SizedBox(height: 50)
            ],
          ),
        ),
      ),
    );
  }
}
