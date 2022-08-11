import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:todo_app/model/data_sql.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/model/todo_database.dart';
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
  List<String> images = [];
  List<String> files = [];

  @override
  void initState() {
    super.initState();
    images = widget.todo.images;
    files = widget.todo.files;
    _controller.text = widget.todo.content;
  }

  Future pickFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      setState(() {
        files.addAll(result.paths.map((path) => path!).toList());
        widget.todo.files = files;
      });
    } else {
      // User canceled the picker
    }
  }

  Future pickImage() async {
    try {
      final imageList = await ImagePicker().pickMultiImage();
      if (imageList == null) return;
      setState(() {
        images.addAll(imageList.map((image) => image.path).toList());
        widget.todo.images = images;
      });
    } on PlatformException catch (_) {}
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
                      return ImageSlideshow(
                        width: double.infinity,
                        height: 200,
                        children: List.generate(
                          snapshot.data!.length,
                          (index) => Image.file(
                            File(snapshot.data![index].link),
                          ),
                        ),
                      );
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
                      return SizedBox(
                        width: double.infinity,
                        height: snapshot.data!.length * 55.0,
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    const Icon(
                                      FontAwesomeIcons.fileLines,
                                      color: Colors.red,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(basename(snapshot.data![index].link)),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                    return Container();
                  }),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Spacer(),
                  OutlinedButton.icon(
                    onPressed: () async {
                      await pickDate(context);
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
                  const SizedBox(width: 20),
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color.fromRGBO(182, 190, 224, 0.5)),
                      borderRadius: BorderRadius.circular(90),
                    ),
                    child: Radio(
                      value: 0,
                      groupValue: 0,
                      onChanged: (value) {},
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onPressed: () {},
                    icon: const Icon(
                      FontAwesomeIcons.image,
                      color: Color.fromRGBO(182, 190, 224, 1),
                    ),
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onPressed: () {},
                    icon: const Icon(
                      FontAwesomeIcons.folderOpen,
                      color: Color.fromRGBO(182, 190, 224, 1),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 50)
            ],
          ),
        ),
      ),
    );
  }

  Future<DateTime?> pickDate(BuildContext context) => showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100));

  Future<TimeOfDay?> pickTime(BuildContext context) => showTimePicker(
      context: context,
      initialTime:
          TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute));
}
