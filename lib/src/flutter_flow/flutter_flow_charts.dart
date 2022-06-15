import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

export 'package:fl_chart/fl_chart.dart'
    show BarAreaData, FlDotData, LineChartBarData;

class FlutterFlowLineChart extends StatelessWidget {
  const FlutterFlowLineChart(
      {Key? key,
      required this.data,
      required this.xAxisLabelInfo,
      required this.yAxisLabelInfo,
      this.backgroundColor = Colors.white,
      this.showGrid = false,
      this.enableTooltip = false,
      this.tooltipBackgroundColor,
      required this.axisBounds})
      : super(key: key);

  final List<FFLineChartData> data;
  final AxisLabelInfo xAxisLabelInfo;
  final AxisLabelInfo yAxisLabelInfo;
  final Color backgroundColor;
  final bool showGrid;
  final bool enableTooltip;
  final Color? tooltipBackgroundColor;
  final AxisBounds axisBounds;

  NumberFormat get format => (NumberFormat()..significantDigits = 2);

  List<LineChartBarData> get dataWithSpots =>
      data.map((d) => d.settings.copyWith(spots: d.spots)).toList();

  @override
  Widget build(BuildContext context) => LineChart(
        LineChartData(
          lineTouchData: LineTouchData(
            handleBuiltInTouches: enableTooltip,
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: tooltipBackgroundColor,
            ),
          ),
          gridData: FlGridData(show: showGrid),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              axisNameWidget: xAxisLabelInfo.title.isEmpty
                  ? null
                  : Text(
                      xAxisLabelInfo.title,
                      style: xAxisLabelInfo.titleTextStyle,
                    ),
              axisNameSize: xAxisLabelInfo.titleTextStyle?.fontSize != null
                  ? xAxisLabelInfo.titleTextStyle!.fontSize! + 12
                  : null,
              sideTitles: SideTitles(
                showTitles: xAxisLabelInfo.showLabels,
                getTitlesWidget: (val, _) => Text(
                  format.format(val),
                  style: xAxisLabelInfo.labelTextStyle,
                ),
                interval: xAxisLabelInfo.labelInterval,
              ),
            ),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              axisNameWidget: yAxisLabelInfo.title.isEmpty
                  ? null
                  : Text(
                      yAxisLabelInfo.title,
                      style: yAxisLabelInfo.titleTextStyle,
                    ),
              axisNameSize: yAxisLabelInfo.titleTextStyle?.fontSize != null
                  ? yAxisLabelInfo.titleTextStyle!.fontSize! + 12
                  : null,
              sideTitles: SideTitles(
                getTitlesWidget: (val, _) => Text(
                  format.format(val),
                  style: yAxisLabelInfo.labelTextStyle,
                ),
                showTitles: yAxisLabelInfo.showLabels,
                interval: yAxisLabelInfo.labelInterval,
              ),
            ),
          ),
          lineBarsData: dataWithSpots,
          minX: axisBounds.minX,
          minY: axisBounds.minY,
          maxX: axisBounds.maxX,
          maxY: axisBounds.maxY,
          backgroundColor: backgroundColor,
        ),
      );
}

class AxisLabelInfo {
  const AxisLabelInfo({
    this.title = '',
    this.titleTextStyle,
    this.showLabels = false,
    this.labelTextStyle,
    this.labelInterval,
  });

  final String title;
  final TextStyle? titleTextStyle;
  final bool showLabels;
  final TextStyle? labelTextStyle;
  final double? labelInterval;
}

class AxisBounds {
  const AxisBounds({this.minX, this.minY, this.maxX, this.maxY});

  final double? minX;
  final double? minY;
  final double? maxX;
  final double? maxY;
}

class FFLineChartData {
  const FFLineChartData({
    required this.xData,
    required this.yData,
    required this.settings,
  });

  final List<dynamic> xData;
  final List<dynamic> yData;
  final LineChartBarData settings;

  List<FlSpot> get spots {
    final x = _dataToDouble(xData);
    final y = _dataToDouble(yData);
    assert(x.length == y.length, 'X and Y data must be the same length');

    return Iterable<int>.generate(min(x.length, y.length))
        .where((i) => x[i] != null && y[i] != null)
        .map((i) => FlSpot(x[i]!, y[i]!))
        .toList();
  }
}

List<double?> _dataToDouble(List<dynamic> data) {
  if (data.isEmpty) {
    return [];
  }
  if (data.every((e) => (e is int) || (e is double))) {
    return data.cast<double>();
  }
  if (data.first is String) {
    // First try to parse as doubles
    if (double.tryParse(data.first as String) != null) {
      return data.map((d) => double.tryParse(d as String)).toList();
    }
    if (int.tryParse(data.first as String) != null) {
      return data.map((d) => int.tryParse(d as String)?.toDouble()).toList();
    }
    if (DateTime.tryParse(data.first as String) != null) {
      return data
          .map((d) =>
              DateTime.tryParse(d as String)?.millisecondsSinceEpoch.toDouble())
          .toList();
    }
  }
  if (data.first is DateTime) {
    return data
        .map((d) => (d as DateTime).millisecondsSinceEpoch.toDouble())
        .toList();
  }
  return [];
}
