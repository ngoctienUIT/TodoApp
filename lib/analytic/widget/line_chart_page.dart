import 'package:flutter/material.dart';
import 'package:todo_app/analytic/widget/my_line_chart.dart';
import 'package:todo_app/model/todo.dart';

class LineChartPage extends StatefulWidget {
  const LineChartPage({Key? key, required this.date, required this.todoList})
      : super(key: key);
  final List<Todo> todoList;
  final DateTime date;

  @override
  State<StatefulWidget> createState() => LineChartPageState();
}

class LineChartPageState extends State<LineChartPage> {
  late bool isShowingMainData;
  late int max;

  @override
  void initState() {
    super.initState();
    isShowingMainData = true;
    max = 0;
    for (int i = 0; i < 7; i++) {
      DateTime now = widget.date
          .subtract(Duration(days: widget.date.weekday - 1))
          .add(Duration(days: i));
      var list = widget.todoList
          .where((element) => element.date.difference(now).inDays == 0)
          .toList();
      if (list.length > max) max = list.length;
      if (max == 0) {
        max = 10;
      } else {
        if (max % 10 != 0) max = ((max ~/ 10) + 1) * 10;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: AspectRatio(
        aspectRatio: 1.23,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            gradient: const LinearGradient(
              colors: [
                Color(0xff2c274c),
                Color(0xff46426c),
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          child: Stack(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const SizedBox(
                    height: 37,
                  ),
                  const Text(
                    'Todo Task',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 37,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16.0, left: 6.0),
                      child: MyLineChart(
                        isShowingMainData: isShowingMainData,
                        todoList: widget.todoList,
                        date: widget.date,
                        max: max,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
              IconButton(
                icon: Icon(
                  Icons.refresh,
                  color:
                      Colors.white.withOpacity(isShowingMainData ? 1.0 : 0.5),
                ),
                onPressed: () {
                  setState(() {
                    isShowingMainData = !isShowingMainData;
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
