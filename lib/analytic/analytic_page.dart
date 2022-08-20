import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/analytic/widget/analytic_button.dart';
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
  final Color leftBarColor = const Color(0xff53fdd7);
  final Color rightBarColor = const Color(0xffff5182);
  final double width = 7;
  final List<String> select = ["Week", "Month", "Year"];
  int index = 0;
  int max = 10;
  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;
  DateTime date = getDateNow();
  String rangeTime = "";
  int touchedGroupIndex = -1;

  @override
  void initState() {
    super.initState();
    initBarChartData();
  }

  void initBarChartData() {
    if (widget.todoList != null) {
      if (index == 0) {
        rangeTime = "${DateFormat("dd/MM/yyyy").format(
          date.subtract(Duration(days: date.weekday - 1)),
        )} - ${DateFormat("dd/MM/yyyy").format(
          date.add(Duration(days: 7 - date.weekday)),
        )}";

        List<BarChartGroupData> items = [];
        max = 0;
        for (int i = 0; i < 7; i++) {
          DateTime now = date
              .subtract(Duration(days: date.weekday - 1))
              .add(Duration(days: i));
          var list = widget.todoList!
              .where((element) => element.date.difference(now).inDays == 0)
              .toList();
          if (list.length > max) max = list.length;
          if (max == 0) {
            max = 10;
          } else {
            if (max % 10 != 0) max = ((max ~/ 10) + 1) * 10;
          }
          int count = 0;
          for (var element in list) {
            if (element.status) count++;
          }
          items.add(makeGroupData(i, count.toDouble(), list.length.toDouble()));
        }

        rawBarGroups = items;
        showingBarGroups = rawBarGroups;
      } else if (index == 1) {
        rangeTime = "";
      } else if (index == 2) {
        rangeTime = "";
      }
    } else {
      List<BarChartGroupData> items = [];
      for (int i = 0; i < 7; i++) {
        items.add(makeGroupData(i, 0, 0));
      }
      rawBarGroups = items;
      showingBarGroups = rawBarGroups;
    }
  }

  @override
  Widget build(BuildContext context) {
    initBarChartData();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Analytic"),
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
      body: widget.todoList == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(
                    3,
                    (index) => analyticButton(
                        text: select[index],
                        action: () {
                          setState(() {
                            this.index = index;
                          });
                        }),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                        border: Border.all(
                            color: const Color.fromRGBO(182, 190, 224, 1)),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.calendar_month_outlined,
                            size: 28,
                            color: Color.fromRGBO(182, 190, 224, 1),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            rangeTime,
                            style: const TextStyle(
                                color: Color.fromRGBO(182, 190, 224, 1),
                                fontSize: 16),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                    color: const Color(0xff2c4260),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const Center(
                            child: Text(
                              'Transactions',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 22),
                            ),
                          ),
                          const SizedBox(
                            height: 38,
                          ),
                          Expanded(
                            child: BarChart(
                              BarChartData(
                                maxY: max.toDouble(),
                                barTouchData: BarTouchData(
                                    touchTooltipData: BarTouchTooltipData(
                                      tooltipBgColor: Colors.grey,
                                      getTooltipItem:
                                          (group, groupIndex, rod, rodIndex) =>
                                              null,
                                    ),
                                    touchCallback:
                                        (FlTouchEvent event, response) {
                                      if (response == null ||
                                          response.spot == null) {
                                        setState(() {
                                          touchedGroupIndex = -1;
                                          showingBarGroups =
                                              List.of(rawBarGroups);
                                        });
                                        return;
                                      }

                                      touchedGroupIndex =
                                          response.spot!.touchedBarGroupIndex;

                                      setState(() {
                                        if (!event
                                            .isInterestedForInteractions) {
                                          touchedGroupIndex = -1;
                                          showingBarGroups =
                                              List.of(rawBarGroups);
                                          return;
                                        }
                                        showingBarGroups =
                                            List.of(rawBarGroups);
                                        if (touchedGroupIndex != -1) {
                                          var sum = 0.0;
                                          for (var rod in showingBarGroups[
                                                  touchedGroupIndex]
                                              .barRods) {
                                            sum += rod.toY;
                                          }
                                          final avg = sum /
                                              showingBarGroups[
                                                      touchedGroupIndex]
                                                  .barRods
                                                  .length;

                                          showingBarGroups[touchedGroupIndex] =
                                              showingBarGroups[
                                                      touchedGroupIndex]
                                                  .copyWith(
                                            barRods: showingBarGroups[
                                                    touchedGroupIndex]
                                                .barRods
                                                .map((rod) {
                                              return rod.copyWith(toY: avg);
                                            }).toList(),
                                          );
                                        }
                                      });
                                    }),
                                titlesData: FlTitlesData(
                                  show: true,
                                  rightTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  topTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: bottomTitles,
                                      reservedSize: 42,
                                    ),
                                  ),
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 28,
                                      interval: 1,
                                      getTitlesWidget: leftTitles,
                                    ),
                                  ),
                                ),
                                borderData: FlBorderData(
                                  show: false,
                                ),
                                barGroups: showingBarGroups,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text = "";
    for (int i = 0; i <= max; i += max ~/ 10) {
      if (value == i) text = "$i";
    }

    if (text == "") return Container();

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(text, style: style),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    List<String> titles = ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"];

    Widget text = Text(
      titles[value.toInt()],
      style: const TextStyle(
        color: Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16, //margin top
      child: text,
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(barsSpace: 4, x: x, barRods: [
      BarChartRodData(
        toY: y1,
        color: leftBarColor,
        width: width,
      ),
      BarChartRodData(
        toY: y2,
        color: rightBarColor,
        width: width,
      ),
    ]);
  }
}
