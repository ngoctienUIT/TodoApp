import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/page/handle_todo/pick_function.dart';
import 'package:todo_app/page/handle_todo/widget/add_file_widget.dart';
import 'package:todo_app/page/handle_todo/widget/file_list_widget.dart';
import 'package:todo_app/page/handle_todo/widget/image_list_widget.dart';
import 'package:todo_app/page/handle_todo/widget/pick_time_widget.dart';
import 'package:todo_app/page/handle_todo/widget/title_todo.dart';
import 'package:todo_app/page/home/bloc/todo_bloc.dart';
import 'package:todo_app/page/home/bloc/todo_event.dart';
import 'package:uuid/uuid.dart';

class NewTodoPage extends StatefulWidget {
  const NewTodoPage({Key? key}) : super(key: key);

  @override
  State<NewTodoPage> createState() => _NewTodoPageState();
}

class _NewTodoPageState extends State<NewTodoPage> {
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  late Todo todo;
  SpeechToText speechToText = SpeechToText();
  String lastWords = "Nói đi";
  bool isListening = false;

  @override
  void initState() {
    super.initState();
    todo = Todo(
        id: const Uuid().v1(),
        title: "",
        content: "",
        date: getDateNow(),
        startTime: TimeOfDay.now(),
        finishTime: TimeOfDay.now(),
        color: Colors.red);
    _titleController.addListener(() {
      todo.title = _titleController.text;
    });
    _contentController.addListener(() {
      todo.content = _contentController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          BlocProvider.of<TodoBloc>(context).add(
            AddEvent(todo: todo),
          );
          Navigator.pop(context);
        },
        label: Row(
          children: const [
            Text("New task"),
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
                    if (todo.images.isNotEmpty) imageListWidget(todo.images),
                    const SizedBox(height: 20),
                    if (todo.files.isNotEmpty) fileListWidget(todo.files),
                    const SizedBox(height: 20),
                    PickTimeWidget(
                      todo: todo,
                      action: (todo) {
                        setState(() {
                          this.todo = todo;
                        });
                      },
                    ),
                    const SizedBox(height: 30),
                    AddFileWidget(
                      getImage: (list) => setState(() {
                        List<String> images = [];
                        images.addAll(todo.images);
                        images.addAll(list);
                        todo.images = images;
                      }),
                      getFile: (list) => setState(() {
                        List<String> files = [];
                        files.addAll(todo.files);
                        files.addAll(list);
                        todo.files = files;
                      }),
                      getColor: (color) => setState(() {
                        todo.color = color;
                      }),
                    ),
                    const SizedBox(height: 70),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void startListening() async {
    if (!isListening) {
      bool check = await speechToText.initialize(
        onStatus: (status) => print("status $status"),
        onError: (errorNotification) => print("error $errorNotification"),
      );

      if (check) {
        setState(() {
          isListening = true;
        });
        speechToText.listen(
          onResult: (result) => setState(() {
            lastWords = result.recognizedWords;
          }),
        );
      }
    } else {
      setState(() {
        isListening = false;
      });
      speechToText.stop();
    }
  }
}
