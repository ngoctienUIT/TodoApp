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
  final TextEditingController _controller = TextEditingController();
  List<String> images = [];
  List<String> files = [];
  late DateTime dateTime;
  SpeechToText speechToText = SpeechToText();
  String lastWords = "Nói đi";
  bool isListening = false;
  int repeat = 0;
  late Todo todo;
  late Color color;

  @override
  void initState() {
    super.initState();
    dateTime = DateTime.now();
    color = Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          BlocProvider.of<TodoBloc>(context).add(
            AddEvent(
              todo: Todo(
                  id: const Uuid().v1(),
                  content: _controller.text,
                  time: dateTime,
                  repeat: repeat,
                  images: images,
                  color: color,
                  files: files),
            ),
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
              Text(lastWords),
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
              if (images.isNotEmpty) fileListWidget(images),
              const SizedBox(height: 20),
              if (files.isNotEmpty) imageListWidget(files),
              const SizedBox(height: 20),
              pickTimeWidget(
                context,
                dateTime: dateTime,
                getDate: (date) => setState(() {
                  dateTime = date;
                }),
                getID: (id) => setState(() {
                  repeat = id;
                }),
                id: repeat,
              ),
              const SizedBox(height: 30),
              AddFileWidget(
                getImage: (list) => setState(() {
                  images.addAll(list);
                }),
                getFile: (list) => setState(() {
                  files.addAll(list);
                }),
                getColor: (color) {
                  setState(() {
                    this.color = color;
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
