import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/page/handle_todo/widget/add_file_widget.dart';
import 'package:todo_app/page/handle_todo/widget/file_list_widget.dart';
import 'package:todo_app/page/handle_todo/widget/image_list_widget.dart';
import 'package:todo_app/page/handle_todo/widget/pick_time_widget.dart';
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
        date: DateTime.now(),
        startTime: TimeOfDay.now(),
        finishTime: TimeOfDay.now(),
        color: Colors.white);
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          labelStyle: TextStyle(fontSize: 16),
                          hintStyle: TextStyle(fontSize: 16),
                          hintText: 'Title',
                        ),
                        maxLines: 1,
                        keyboardType: TextInputType.multiline,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color.fromRGBO(182, 190, 224, 0.5),
                          ),
                          borderRadius: BorderRadius.circular(90)),
                      child: const Icon(Icons.close_rounded),
                    ),
                  ),
                  const SizedBox(width: 30),
                ],
              ),
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
              if (todo.images.isNotEmpty) fileListWidget(todo.images),
              const SizedBox(height: 20),
              if (todo.files.isNotEmpty) imageListWidget(todo.files),
              const SizedBox(height: 20),
              pickTimeWidget(
                context,
                dateTime: todo.date,
                startTime: todo.startTime,
                finishTime: todo.finishTime,
                getDate: (date) => setState(() {
                  todo.date = date;
                }),
                getStartTime: (time) => setState(() {
                  todo.startTime = time;
                }),
                getFinishTime: (time) => setState(() {
                  todo.finishTime = time;
                }),
                getID: (id) => setState(() {
                  todo.repeat = id;
                }),
                id: todo.repeat,
              ),
              const SizedBox(height: 30),
              AddFileWidget(
                getImage: (list) => setState(() {
                  todo.images.addAll(list);
                }),
                getFile: (list) => setState(() {
                  todo.files.addAll(list);
                }),
                getColor: (color) {
                  setState(() {
                    todo.color = color;
                  });
                },
              ),
              const SizedBox(height: 50),
            ],
          ),
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
