import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:todo_app/model/data_sql.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/model/todo_database.dart';
import 'package:todo_app/page/handle_todo/widget/add_file_widget.dart';
import 'package:todo_app/page/handle_todo/widget/file_list_widget.dart';
import 'package:todo_app/page/handle_todo/widget/image_list_widget.dart';
import 'package:todo_app/page/handle_todo/widget/pick_time_widget.dart';
import 'package:todo_app/page/handle_todo/widget/title_todo.dart';
import 'package:todo_app/page/home/bloc/todo_bloc.dart';
import 'package:todo_app/page/home/bloc/todo_event.dart';

class EditTodoPage extends StatefulWidget {
  const EditTodoPage({Key? key, required this.todo}) : super(key: key);
  final Todo todo;

  @override
  State<EditTodoPage> createState() => _EditTodoPageState();
}

class _EditTodoPageState extends State<EditTodoPage> {
  final TextEditingController _contentController = TextEditingController();

  final TextEditingController _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _contentController.text = widget.todo.content;
    _titleController.text = widget.todo.title;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          FocusManager.instance.primaryFocus?.unfocus();
          widget.todo.content = _contentController.text;
          widget.todo.title = _titleController.text;
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
        child: Column(
          children: [
            const SizedBox(height: 30),
            titleTodo(
              titleController: _titleController,
              action: () {
                Navigator.pop(context);
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        controller: _contentController,
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
                            return imageListWidget(snapshot.data!
                                .map((data) => data.link)
                                .toList());
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
                            return fileListWidget(snapshot.data!
                                .map((data) => data.link)
                                .toList());
                          }
                          return Container();
                        }),
                    const SizedBox(height: 20),
                    PickTimeWidget(
                      todo: widget.todo,
                      action: (todo) {
                        setState(() {
                          widget.todo.repeat = todo.repeat;
                          widget.todo.date = todo.date;
                          widget.todo.finishTime = todo.finishTime;
                          widget.todo.startTime = todo.startTime;
                        });
                      },
                    ),
                    const SizedBox(height: 30),
                    AddFileWidget(
                      getImage: (list) => setState(() {
                        widget.todo.images.addAll(list);
                      }),
                      getFile: (list) => setState(() {
                        widget.todo.files.addAll(list);
                      }),
                      getColor: (color) {
                        setState(() {
                          widget.todo.color = color;
                        });
                      },
                    ),
                    const SizedBox(height: 50)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
