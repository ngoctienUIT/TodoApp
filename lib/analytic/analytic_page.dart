import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/analytic/widget/analytic_button.dart';
import 'package:todo_app/analytic/widget/column_chart.dart';
import 'package:todo_app/analytic/widget/line_chart_page.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/page/handle_todo/pick_function.dart';

class AnalyticPage extends StatefulWidget {
  const AnalyticPage({Key? key, required this.action, this.todoList})
      : super(key: key);
  final Function action;
  final List<Todo>? todoList;

  @override
  State<AnalyticPage> createState() => _AnalyticPageState();
}

class _AnalyticPageState extends State<AnalyticPage> {
  final List<String> select = ["Column", "Line"];
  int index = 0;
  DateTime date = getDateNow();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(250, 250, 255, 1),
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(
            color: Color.fromRGBO(159, 161, 184, 1), size: 25),
        backgroundColor: const Color.fromRGBO(250, 250, 255, 1),
        title: const Text(
          "Analytic",
          style: TextStyle(color: Color.fromRGBO(156, 166, 201, 1)),
        ),
        centerTitle: true,
        leading: IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: () {
            widget.action();
          },
          icon: const Icon(FontAwesomeIcons.bars),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              select.length,
              (index) => analyticButton(
                  text: select[index],
                  backColor: this.index == index
                      ? const Color.fromRGBO(182, 190, 240, 1)
                      : Colors.white,
                  textColor: this.index == index
                      ? Colors.white
                      : const Color.fromRGBO(182, 190, 240, 1),
                  icon: index == 0
                      ? FontAwesomeIcons.chartColumn
                      : FontAwesomeIcons.chartLine,
                  action: () {
                    setState(() {
                      this.index = index;
                    });
                  }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: InkWell(
              onTap: () async {
                var date = await pickDate(context,
                    initDate: this.date, firstDate: DateTime(2000));
                if (date != null) {
                  setState(() {
                    this.date = date;
                  });
                }
              },
              child: Container(
                height: 65,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border:
                      Border.all(color: const Color.fromRGBO(182, 190, 224, 1)),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.calendar_month_outlined,
                      size: 30,
                      color: Color.fromRGBO(182, 190, 224, 1),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "${DateFormat("dd/MM/yyyy").format(
                        date.subtract(Duration(days: date.weekday - 1)),
                      )} - ${DateFormat("dd/MM/yyyy").format(
                        date.add(Duration(days: 7 - date.weekday)),
                      )}",
                      style: const TextStyle(
                          color: Color.fromRGBO(182, 190, 224, 1),
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
          ),
          widget.todoList == null
              ? const Center(child: CircularProgressIndicator())
              : Expanded(
                  child: index == 0
                      ? ColumnChart(todoList: widget.todoList!, date: date)
                      : LineChartPage(todoList: widget.todoList!, date: date),
                ),
        ],
      ),
    );
  }
}
