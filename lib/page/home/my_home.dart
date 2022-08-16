import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/model/todo_database.dart';
import 'package:todo_app/page/handle_todo/new_todo_page.dart';
import 'package:todo_app/page/home/bloc/todo_bloc.dart';
import 'package:todo_app/page/home/bloc/todo_state.dart';
import 'package:todo_app/page/home/widget/build_item.dart';

class MyHome extends StatefulWidget {
  const MyHome({Key? key, required this.action}) : super(key: key);
  final Function action;

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  late DateTime now;
  late bool filter;

  @override
  void initState() {
    super.initState();
    now = DateTime.now();
    filter = true;
  }

  bool checkDate(DateTime startTime, DateTime finishTime) =>
      finishTime.difference(now).inDays >= 0 &&
      now.difference(startTime).inDays >= 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(250, 250, 255, 1),
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(
            color: Color.fromRGBO(159, 161, 184, 1), size: 25),
        backgroundColor: const Color.fromRGBO(250, 250, 255, 1),
        actions: [
          IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () {
              setState(() {
                filter = !filter;
              });
            },
            icon: Icon(filter
                ? FontAwesomeIcons.listCheck
                : FontAwesomeIcons.calendarDays),
          ),
          IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () {},
            icon: const Icon(FontAwesomeIcons.bell),
          )
        ],
        leading: IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: () {
            widget.action();
          },
          icon: const Icon(FontAwesomeIcons.bars),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NewTodoPage(),
            ),
          );
        },
        child: const Icon(Icons.add_rounded),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "What's up, TNT",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(77, 80, 108, 1),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                DateFormat.yMMMMd().format(DateTime.now()),
                style: const TextStyle(
                  fontSize: 30,
                  color: Color.fromRGBO(156, 166, 201, 1),
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                "Today",
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              if (filter)
                DatePicker(
                  DateTime.now(),
                  initialSelectedDate: DateTime.now(),
                  selectionColor: Colors.black,
                  selectedTextColor: Colors.white,
                  onDateChange: (date) {
                    setState(() {
                      now = date;
                    });
                  },
                ),
              Expanded(
                child: BlocBuilder<TodoBloc, TodoState>(
                  builder: (context, state) {
                    if (state is TodoInitial) {
                      return FutureBuilder<List<Todo>>(
                        future: TodoDatabase().getData(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return buildItem(snapshot.data!
                                .where((element) =>
                                    !filter ||
                                    checkDate(element.date, element.date))
                                .toList());
                          }

                          return const Center(
                              child: CircularProgressIndicator());
                        },
                      );
                    }

                    if (state is Success) {
                      return buildItem(state.list
                          .where((element) =>
                              !filter || checkDate(element.date, element.date))
                          .toList());
                    }

                    return const Center(child: Text("Không có dữ liệu"));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
