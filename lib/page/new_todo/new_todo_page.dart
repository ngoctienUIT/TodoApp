import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NewTodoPage extends StatelessWidget {
  NewTodoPage({Key? key}) : super(key: key);
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
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
              )
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