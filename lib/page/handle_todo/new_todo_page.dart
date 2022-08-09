import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todo_app/model/todo.dart';
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
  List<PlatformFile> platformFiles = [];
  DateTime dateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  Future pickFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      setState(() {
        files.addAll(result.paths.map((path) => path!).toList());
        platformFiles.addAll(result.files);
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
      });
    } on PlatformException catch (_) {}
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
                  images: images,
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
              if (images.isNotEmpty)
                ImageSlideshow(
                  width: double.infinity,
                  height: 200,
                  children: List.generate(
                    images.length,
                    (index) => Center(
                      child: Hero(
                        tag: "TNT",
                        child: Image.file(
                          File(images[index]),
                        ),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              if (files.isNotEmpty)
                SizedBox(
                  width: double.infinity,
                  height: files.length * 55.0,
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: files.length,
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
                              Text(platformFiles[index].name),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Spacer(),
                  OutlinedButton.icon(
                    onPressed: () async {
                      dateTime = (await pickDate(context))!;
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
                    onPressed: () async {
                      await pickImage();
                    },
                    icon: const Icon(
                      FontAwesomeIcons.image,
                      color: Color.fromRGBO(182, 190, 224, 1),
                    ),
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    onPressed: () async {
                      await pickFile();
                    },
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
