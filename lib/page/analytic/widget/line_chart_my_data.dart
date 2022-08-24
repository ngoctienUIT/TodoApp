import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

LineChartBarData lineChartBarData1_1(List<FlSpot> items) => LineChartBarData(
      isCurved: true,
      color: const Color(0xff4af699),
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
      spots: items,
    );

LineChartBarData lineChartBarData1_2(List<FlSpot> items) => LineChartBarData(
      isCurved: true,
      color: const Color(0xffaa4cfc),
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(
        show: false,
        color: const Color(0x00aa4cfc),
      ),
      spots: items,
    );

LineChartBarData lineChartBarData1_3(List<FlSpot> items) => LineChartBarData(
      isCurved: true,
      color: const Color(0xff27b6fc),
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
      spots: items,
    );

LineChartBarData lineChartBarData2_1(List<FlSpot> items) => LineChartBarData(
      isCurved: true,
      curveSmoothness: 0,
      color: const Color(0x444af699),
      barWidth: 4,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
      spots: items,
    );

LineChartBarData lineChartBarData2_2(List<FlSpot> items) => LineChartBarData(
      isCurved: true,
      color: const Color(0x99aa4cfc),
      barWidth: 4,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        color: const Color(0x33aa4cfc),
      ),
      spots: items,
    );

LineChartBarData lineChartBarData2_3(List<FlSpot> items) => LineChartBarData(
      isCurved: true,
      curveSmoothness: 0,
      color: const Color(0x4427b6fc),
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: FlDotData(show: true),
      belowBarData: BarAreaData(show: false),
      spots: items,
    );
