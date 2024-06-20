import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

export 'package:fl_chart/fl_chart.dart' show BarAreaData, FlDotData, LineChartBarData, BarChartAlignment;

class FlutterFlowLineChart extends StatelessWidget {
  const FlutterFlowLineChart({
    Key? key,
    required this.data,
    required this.xAxisLabelInfo,
    required this.yAxisLabelInfo,
    required this.axisBounds,
    this.chartStylingInfo = const ChartStylingInfo(),
  }) : super(key: key);

  final List<FFLineChartData> data;
  final AxisLabelInfo xAxisLabelInfo;
  final AxisLabelInfo yAxisLabelInfo;
  final AxisBounds axisBounds;
  final ChartStylingInfo chartStylingInfo;

  List<LineChartBarData> get dataWithSpots => data.map((d) => d.settings.copyWith(spots: d.spots)).toList();

  @override
  Widget build(BuildContext context) => LineChart(
        LineChartData(
          lineTouchData: LineTouchData(
            handleBuiltInTouches: chartStylingInfo.enableTooltip,
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: chartStylingInfo.tooltipBackgroundColor,
            ),
          ),
          gridData: FlGridData(show: chartStylingInfo.showGrid),
          borderData: FlBorderData(
            border: Border.all(
              color: chartStylingInfo.borderColor,
              width: chartStylingInfo.borderWidth,
            ),
            show: chartStylingInfo.showBorder,
          ),
          titlesData: getTitlesData(
            xAxisLabelInfo,
            yAxisLabelInfo,
          ),
          lineBarsData: dataWithSpots,
          minX: axisBounds.minX,
          minY: axisBounds.minY,
          maxX: axisBounds.maxX,
          maxY: axisBounds.maxY,
          backgroundColor: chartStylingInfo.backgroundColor,
        ),
      );
}

class FlutterFlowBarChart extends StatelessWidget {
  const FlutterFlowBarChart({
    Key? key,
    required this.barData,
    required this.xLabels,
    required this.xAxisLabelInfo,
    required this.yAxisLabelInfo,
    required this.axisBounds,
    this.stacked = false,
    this.barWidth,
    this.barBorderRadius,
    this.barSpace,
    this.groupSpace,
    this.alignment = BarChartAlignment.center,
    this.chartStylingInfo = const ChartStylingInfo(),
  }) : super(key: key);

  final List<FFBarChartData> barData;
  final List<String> xLabels;
  final AxisLabelInfo xAxisLabelInfo;
  final AxisLabelInfo yAxisLabelInfo;
  final AxisBounds axisBounds;
  final bool stacked;
  final double? barWidth;
  final BorderRadius? barBorderRadius;
  final double? barSpace;
  final double? groupSpace;
  final BarChartAlignment alignment;
  final ChartStylingInfo chartStylingInfo;

  Map<int, List<double>> get dataMap =>
      xLabels.asMap().map((key, value) => MapEntry(key, barData.map((data) => data.data[key]).toList()));

  List<BarChartGroupData> get groups => dataMap.entries.map((entry) {
        final groupInt = entry.key;
        final groupData = entry.value;
        return BarChartGroupData(
            x: groupInt,
            barsSpace: barSpace,
            barRods: groupData.asMap().entries.map((rod) {
              final rodInt = rod.key;
              final rodSettings = barData[rodInt];
              final rodValue = rod.value;
              return BarChartRodData(
                toY: rodValue,
                color: rodSettings.color,
                width: barWidth,
                borderRadius: barBorderRadius,
                borderSide: BorderSide(
                  width: rodSettings.borderWidth,
                  color: rodSettings.borderColor,
                ),
              );
            }).toList());
      }).toList();

  List<BarChartGroupData> get stacks => dataMap.entries.map((entry) {
        final groupInt = entry.key;
        final stackData = entry.value;
        return BarChartGroupData(
          x: groupInt,
          barsSpace: barSpace,
          barRods: [
            BarChartRodData(
              toY: sum(stackData),
              width: barWidth,
              borderRadius: barBorderRadius,
              rodStackItems: stackData.asMap().entries.map((stack) {
                final stackInt = stack.key;
                final stackSettings = barData[stackInt];
                final start = stackInt == 0 ? 0.0 : sum(stackData.sublist(0, stackInt));
                return BarChartRodStackItem(
                  start,
                  start + stack.value,
                  stackSettings.color,
                  BorderSide(
                    width: stackSettings.borderWidth,
                    color: stackSettings.borderColor,
                  ),
                );
              }).toList(),
            )
          ],
        );
      }).toList();

  double sum(List<double> list) => list.reduce((a, b) => a + b);

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barTouchData: BarTouchData(
          handleBuiltInTouches: chartStylingInfo.enableTooltip,
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: chartStylingInfo.tooltipBackgroundColor,
          ),
        ),
        alignment: alignment,
        gridData: FlGridData(show: chartStylingInfo.showGrid),
        borderData: FlBorderData(
          border: Border.all(
            color: chartStylingInfo.borderColor,
            width: chartStylingInfo.borderWidth,
          ),
          show: chartStylingInfo.showBorder,
        ),
        titlesData: getTitlesData(
          xAxisLabelInfo,
          yAxisLabelInfo,
          getXTitlesWidget: (val, _) => Text(
            xLabels[val.toInt()],
            style: xAxisLabelInfo.labelTextStyle,
          ),
        ),
        barGroups: stacked ? stacks : groups,
        groupsSpace: groupSpace,
        minY: axisBounds.minY,
        maxY: axisBounds.maxY,
        backgroundColor: chartStylingInfo.backgroundColor,
      ),
    );
  }
}

enum PieChartSectionLabelType {
  none,
  value,
  percent,
}

class FlutterFlowPieChart extends StatelessWidget {
  const FlutterFlowPieChart({
    Key? key,
    required this.data,
    this.donutHoleRadius = 0,
    this.donutHoleColor = Colors.transparent,
    this.sectionLabelType = PieChartSectionLabelType.none,
    this.sectionLabelStyle,
    this.labelFormatter = const LabelFormatter(),
  }) : super(key: key);

  final FFPieChartData data;
  final double donutHoleRadius;
  final Color donutHoleColor;
  final PieChartSectionLabelType sectionLabelType;
  final TextStyle? sectionLabelStyle;
  final LabelFormatter labelFormatter;

  double get sumOfValues => data.data.reduce((a, b) => a + b);

  @override
  Widget build(BuildContext context) => PieChart(
        PieChartData(
          centerSpaceRadius: donutHoleRadius,
          centerSpaceColor: donutHoleColor,
          sectionsSpace: 0,
          sections: data.data.asMap().entries.map(
            (section) {
              String? title;
              final index = section.key;
              final sectionData = section.value;
              final colorsLength = data.colors.length;
              final otherPropsLength = data.radius.length;
              switch (sectionLabelType) {
                case PieChartSectionLabelType.value:
                  title = formatLabel(labelFormatter, sectionData);
                  break;
                case PieChartSectionLabelType.percent:
                  title = '${formatLabel(labelFormatter, sectionData / sumOfValues * 100)}%';
                  break;
                default:
                  break;
              }
              return PieChartSectionData(
                value: sectionData,
                color: data.colors[index % colorsLength],
                radius: otherPropsLength == 1 ? data.radius.first : data.radius[index],
                borderSide: BorderSide(
                  color: (otherPropsLength == 1 ? data.borderColor?.first : data.borderColor?.elementAt(index)) ??
                      Colors.transparent,
                  width: (otherPropsLength == 1 ? data.borderWidth?.first : data.borderWidth?.elementAt(index)) ?? 0.0,
                ),
                showTitle: sectionLabelType != PieChartSectionLabelType.none,
                titleStyle: sectionLabelStyle,
                title: title,
              );
            },
          ).toList(),
        ),
      );
}

class FlutterFlowChartLegendWidget extends StatelessWidget {
  const FlutterFlowChartLegendWidget({
    Key? key,
    required this.entries,
    this.width,
    this.height,
    this.textStyle,
    this.padding,
    this.backgroundColor = Colors.transparent,
    this.borderRadius,
    this.borderWidth = 1.0,
    this.borderColor = const Color(0xFF000000),
    this.indicatorSize = 10,
    this.indicatorBorderRadius,
    this.textPadding = const EdgeInsets.all(0),
  }) : super(key: key);

  final List<LegendEntry> entries;
  final double? width;
  final double? height;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;
  final Color backgroundColor;
  final BorderRadius? borderRadius;
  final double borderWidth;
  final Color borderColor;
  final double indicatorSize;
  final BorderRadius? indicatorBorderRadius;
  final EdgeInsetsGeometry textPadding;

  @override
  Widget build(BuildContext context) => Container(
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius,
          border: Border.all(
            color: borderColor,
            width: borderWidth,
          ),
        ),
        child: Column(
          children: entries
              .map(
                (entry) => Row(
                  children: [
                    Container(
                      height: indicatorSize,
                      width: indicatorSize,
                      decoration: BoxDecoration(
                        color: entry.color,
                        borderRadius: indicatorBorderRadius,
                      ),
                    ),
                    Padding(
                      padding: textPadding,
                      child: Text(
                        entry.name,
                        style: textStyle,
                      ),
                    )
                  ],
                ),
              )
              .toList(),
        ),
      );
}

class LegendEntry {
  const LegendEntry(this.color, this.name);

  final Color color;
  final String name;
}

class ChartStylingInfo {
  const ChartStylingInfo({
    this.backgroundColor = Colors.white,
    this.showGrid = false,
    this.enableTooltip = false,
    this.tooltipBackgroundColor,
    this.borderColor = Colors.black,
    this.borderWidth = 1.0,
    this.showBorder = true,
  });

  final Color backgroundColor;
  final bool showGrid;
  final bool enableTooltip;
  final Color? tooltipBackgroundColor;
  final Color borderColor;
  final double borderWidth;
  final bool showBorder;
}

class AxisLabelInfo {
  const AxisLabelInfo({
    this.title = '',
    this.titleTextStyle,
    this.showLabels = false,
    this.labelTextStyle,
    this.labelInterval,
    this.labelFormatter = const LabelFormatter(),
    this.reservedSize,
  });

  final String title;
  final TextStyle? titleTextStyle;
  final bool showLabels;
  final TextStyle? labelTextStyle;
  final double? labelInterval;
  final LabelFormatter labelFormatter;
  final double? reservedSize;
}

class LabelFormatter {
  const LabelFormatter({
    this.numberFormat,
  });

  final String Function(double)? numberFormat;

  NumberFormat get defaultFormat => NumberFormat()..significantDigits = 2;
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

class FFBarChartData {
  const FFBarChartData({
    required this.yData,
    required this.color,
    this.borderWidth = 0,
    this.borderColor = Colors.transparent,
  });

  final List<dynamic> yData;
  final Color color;
  final double borderWidth;
  final Color borderColor;

  List<double> get data => _dataToDouble(yData).map((e) => e ?? 0.0).toList();
}

class FFPieChartData {
  const FFPieChartData({
    required this.values,
    required this.colors,
    required this.radius,
    this.borderWidth,
    this.borderColor,
  });

  final List<dynamic> values;
  final List<Color> colors;
  final List<double> radius;
  final List<double>? borderWidth;
  final List<Color>? borderColor;

  List<double> get data => _dataToDouble(values).map((e) => e ?? 0.0).toList();
}

List<double?> _dataToDouble(List<dynamic> data) {
  if (data.isEmpty) {
    return [];
  }
  if (data.first is double) {
    return data.map((d) => d as double).toList();
  }
  if (data.first is int) {
    return data.map((d) => (d as int).toDouble()).toList();
  }
  if (data.first is DateTime) {
    return data.map((d) => (d as DateTime).millisecondsSinceEpoch.toDouble()).toList();
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
      return data.map((d) => DateTime.tryParse(d as String)?.millisecondsSinceEpoch.toDouble()).toList();
    }
  }
  return [];
}

FlTitlesData getTitlesData(
  AxisLabelInfo xAxisLabelInfo,
  AxisLabelInfo yAxisLabelInfo, {
  Widget Function(double, TitleMeta)? getXTitlesWidget,
}) =>
    FlTitlesData(
      bottomTitles: AxisTitles(
        axisNameWidget: xAxisLabelInfo.title.isEmpty
            ? null
            : Text(
                xAxisLabelInfo.title,
                style: xAxisLabelInfo.titleTextStyle,
              ),
        axisNameSize:
            xAxisLabelInfo.titleTextStyle?.fontSize != null ? xAxisLabelInfo.titleTextStyle!.fontSize! + 12 : null,
        sideTitles: SideTitles(
          getTitlesWidget: (val, _) => getXTitlesWidget != null
              ? getXTitlesWidget(val, _)
              : Text(
                  formatLabel(xAxisLabelInfo.labelFormatter, val),
                  style: xAxisLabelInfo.labelTextStyle,
                ),
          showTitles: xAxisLabelInfo.showLabels,
          interval: xAxisLabelInfo.labelInterval,
          reservedSize: xAxisLabelInfo.reservedSize,
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
        axisNameSize:
            yAxisLabelInfo.titleTextStyle?.fontSize != null ? yAxisLabelInfo.titleTextStyle!.fontSize! + 12 : null,
        sideTitles: SideTitles(
          getTitlesWidget: (val, _) => Text(
            formatLabel(yAxisLabelInfo.labelFormatter, val),
            style: yAxisLabelInfo.labelTextStyle,
          ),
          showTitles: yAxisLabelInfo.showLabels,
          interval: yAxisLabelInfo.labelInterval,
          reservedSize: yAxisLabelInfo.reservedSize,
        ),
      ),
    );

String formatLabel(LabelFormatter formatter, double value) {
  if (formatter.numberFormat != null) {
    return formatter.numberFormat!(value);
  }
  return formatter.defaultFormat.format(value);
}
