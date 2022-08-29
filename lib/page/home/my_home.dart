import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/model/todo_database.dart';
import 'package:todo_app/page/handle_todo/new_todo_page.dart';
import 'package:todo_app/page/handle_todo/pick_function.dart';
import 'package:todo_app/page/home/bloc/todo_bloc.dart';
import 'package:todo_app/page/home/bloc/todo_state.dart';
import 'package:todo_app/page/home/widget/build_item.dart';
import 'package:todo_app/page/home/widget/style.dart';

class MyHome extends StatefulWidget {
  const MyHome({Key? key, required this.action, required this.locale})
      : super(key: key);
  final Function action;
  final String locale;

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  late DateTime now;
  late bool filter;
  late DateTime backDate;

  @override
  void initState() {
    super.initState();
    now = getDateNow();
    backDate = getDateNow();
    filter = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () {
              setState(() {
                if (filter) now = getDateNow();
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
            onPressed: () {
              setState(() {
                Get.changeThemeMode(
                    Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
                SharedPreferences.getInstance().then((preferences) {
                  preferences.setBool("dartMode", Get.isDarkMode);
                });
              });
            },
            icon: Icon(
              Get.isDarkMode ? FontAwesomeIcons.moon : FontAwesomeIcons.sun,
            ),
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
              const SizedBox(height: 10),
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
              Text(
                "today".tr,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              if (filter)
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          backDate = backDate.subtract(const Duration(days: 1));
                        });
                      },
                      child: const Icon(Icons.arrow_back_ios_new_rounded),
                    ),
                    Expanded(
                      child: DatePicker(
                        backDate,
                        initialSelectedDate: now,
                        selectionColor: const Color.fromRGBO(182, 190, 240, 1),
                        selectedTextColor: Colors.white,
                        locale: widget.locale,
                        dayTextStyle: dayTextStyle(),
                        dateTextStyle: dateTextStyle(),
                        monthTextStyle: monthTextStyle(),
                        onDateChange: (date) => setState(() {
                          now = date;
                        }),
                      ),
                    ),
                  ],
                ),
              Expanded(
                child: BlocBuilder<TodoBloc, TodoState>(
                  builder: (context, state) {
                    if (state is TodoInitial) {
                      return FutureBuilder<List<Todo>>(
                        future: TodoDatabase().getData(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return buildItem(
                                snapshot.data!
                                    .where((element) => checkItem(element))
                                    .toList(),
                                filter);
                          }

                          return const Center(
                              child: CircularProgressIndicator());
                        },
                      );
                    }

                    if (state is Success) {
                      return buildItem(
                          state.list
                              .where((element) => checkItem(element))
                              .toList(),
                          filter);
                    }

                    return const Center(
                        child: Text(
                      "Không có dữ liệu",
                      style: TextStyle(color: Color.fromRGBO(156, 166, 201, 1)),
                    ));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool checkItem(Todo todo) {
    return !filter ||
        todo.repeat == 1 ||
        (todo.repeat == 2 && now.difference(todo.date).inDays % 7 == 0) ||
        (todo.repeat == 3 && now.day == todo.date.day) ||
        (todo.repeat == 4 &&
            now.day == todo.date.day &&
            now.month == todo.date.month) ||
        todo.date.difference(now).inDays == 0;
  }
}
