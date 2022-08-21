import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/analytic/widget/line_chart_my_data.dart';
import 'package:todo_app/model/todo.dart';

class MyLineChart extends StatelessWidget {
  const MyLineChart(
      {Key? key,
      required this.isShowingMainData,
      required this.todoList,
      required this.date,
      required this.max})
      : super(key: key);
  final List<Todo> todoList;
  final DateTime date;
  final bool isShowingMainData;
  final int max;

  @override
  Widget build(BuildContext context) {
    return LineChart(
      isShowingMainData ? data1 : data2,
      swapAnimationDuration: const Duration(milliseconds: 250),
    );
  }

  LineChartData get data1 => LineChartData(
        lineTouchData: lineTouchData1,
        gridData: FlGridData(show: true),
        titlesData: titlesData1,
        borderData: borderData,
        lineBarsData: lineBarsData1,
        minX: 0,
        maxX: 6,
        maxY: max.toDouble(),
        minY: 0,
      );

  LineChartData get data2 => LineChartData(
        lineTouchData: lineTouchData2,
        gridData: FlGridData(show: true),
        titlesData: titlesData2,
        borderData: borderData,
        lineBarsData: lineBarsData2,
        minX: 0,
        maxX: 6,
        maxY: max.toDouble(),
        minY: 0,
      );

  LineTouchData get lineTouchData1 => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
      );

  FlTitlesData get titlesData1 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  List<LineChartBarData> get lineBarsData1 {
    List<FlSpot> itemsLine1 = [];
    List<FlSpot> itemsLine2 = [];
    List<FlSpot> itemsLine3 = [];
    for (int i = 0; i < 7; i++) {
      DateTime now = date
          .subtract(Duration(days: date.weekday - 1))
          .add(Duration(days: i));
      var list = todoList
          .where((element) => element.date.difference(now).inDays == 0)
          .toList();

      int count = 0;
      for (var element in list) {
        if (element.status) count++;
      }
      itemsLine1.add(FlSpot(i.toDouble(), count.toDouble()));
      itemsLine2.add(FlSpot(i.toDouble(), list.length - count.toDouble()));
      itemsLine3.add(FlSpot(i.toDouble(), list.length.toDouble()));
    }
    return [
      lineChartBarData1_1(itemsLine1),
      lineChartBarData1_2(itemsLine2),
      lineChartBarData1_3(itemsLine3)
    ];
  }

  LineTouchData get lineTouchData2 => LineTouchData(
        enabled: false,
      );

  FlTitlesData get titlesData2 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  List<LineChartBarData> get lineBarsData2 {
    List<FlSpot> itemsLine1 = [];
    List<FlSpot> itemsLine2 = [];
    List<FlSpot> itemsLine3 = [];
    for (int i = 0; i < 7; i++) {
      DateTime now = date
          .subtract(Duration(days: date.weekday - 1))
          .add(Duration(days: i));
      var list = todoList
          .where((element) => element.date.difference(now).inDays == 0)
          .toList();

      int count = 0;
      for (var element in list) {
        if (element.status) count++;
      }
      itemsLine1.add(FlSpot(i.toDouble(), count.toDouble()));
      itemsLine2.add(FlSpot(i.toDouble(), list.length - count.toDouble()));
      itemsLine3.add(FlSpot(i.toDouble(), list.length.toDouble()));
    }
    return [
      lineChartBarData2_1(itemsLine1),
      lineChartBarData2_2(itemsLine2),
      lineChartBarData2_3(itemsLine3)
    ];
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff75729e),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );

    String text = "";
    for (int i = 0; i <= max; i += max ~/ 10) {
      if (value == i) text = "$i";
    }

    return Text(text, style: style, textAlign: TextAlign.center);
  }

  SideTitles leftTitles() => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: 1,
        reservedSize: 40,
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff72719b),
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    List<String> titles = ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"];

    Widget text = Text(titles[value.toInt()], style: style);

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(color: Color(0xff4e4965), width: 4),
          left: BorderSide(color: Colors.transparent),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(color: Colors.transparent),
        ),
      );
}
