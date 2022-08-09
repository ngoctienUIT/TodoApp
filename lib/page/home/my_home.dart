import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/model/todo_database.dart';
import 'package:todo_app/page/handle_todo/new_todo_page.dart';
import 'package:todo_app/page/home/bloc/todo_bloc.dart';
import 'package:todo_app/page/home/bloc/todo_state.dart';
import 'package:todo_app/page/home/widget/build_item.dart';

class MyHome extends StatelessWidget {
  MyHome({Key? key, required this.action}) : super(key: key);
  final Function action;
  final TodoDatabase todoDatabase = TodoDatabase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(250, 250, 255, 1),
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(
            color: Color.fromRGBO(159, 161, 184, 1), size: 20),
        backgroundColor: const Color.fromRGBO(250, 250, 255, 1),
        actions: [
          IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () {},
            icon: const Icon(FontAwesomeIcons.magnifyingGlass),
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
            action();
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
              const SizedBox(height: 30),
              const Text(
                "Category",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(156, 166, 201, 1),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "TODAY'S TASK",
                style: TextStyle(
                  color: Color.fromRGBO(156, 166, 201, 1),
                ),
              ),
              Expanded(
                child: BlocBuilder<TodoBloc, TodoState>(
                  builder: (context, state) {
                    if (state is TodoInitial) {
                      return FutureBuilder<List<Todo>>(
                        future: TodoDatabase().getData(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return buildItem(snapshot.data!);
                          }

                          return const Center(
                              child: CircularProgressIndicator());
                        },
                      );
                    }

                    if (state is Success) {
                      return buildItem(state.list);
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
