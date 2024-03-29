import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../pages/home_page.dart';

Map<String, dynamic> calculateIncome(List<Expense> expenses) {
  final pastWeeksIncome = expenses.where((expense) {
    final weeksAgo = DateTime.now().subtract(const Duration(days: 7 * 2));
    return expense.date.isAfter(weeksAgo) && expense.type != 'Expense';
  }).toList();

  final dailyIncome = {
    'Monday': 0.0,
    'Tuesday': 0.0,
    'Wednesday': 0.0,
    'Thursday': 0.0,
    'Friday': 0.0,
    'Saturday': 0.0,
    'Sunday': 0.0,
  };

  for (var expense in pastWeeksIncome) {
    final dayOfWeek = DateFormat('EEEE').format(expense.date);
    dailyIncome.update(
        dayOfWeek, (existingValue) => existingValue + expense.price,
        ifAbsent: () => expense.price);
  }

  return {
    'pastWeeksIncome': pastWeeksIncome,
    'dailyIncome': dailyIncome,
  };
}

LineChartData buildLineChartData(Map<String, double> dailyExpenses, BuildContext context, List<Expense> expenses) {

  return LineChartData(
    lineTouchData: LineTouchData(
      touchTooltipData: LineTouchTooltipData(
        tooltipRoundedRadius: 10,
        tooltipBgColor: Theme.of(context).colorScheme.primaryContainer,
        tooltipBorder: BorderSide(color: Theme.of(context).colorScheme.primary),
        getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
          return touchedBarSpots.map((barSpot) {
            return LineTooltipItem(
              '\u20B1${barSpot.y}',
              const TextStyle(fontSize: 16),
            );
          }).toList();
        },
      ),
    ),
    lineBarsData: [
      LineChartBarData(
        spots: dailyExpenses.entries.map((entry) {
          final dayOfWeekIndex = [
            'Monday',
            'Tuesday',
            'Wednesday',
            'Thursday',
            'Friday',
            'Saturday',
            'Sunday'
          ].indexOf(entry.key);
          return FlSpot(dayOfWeekIndex.toDouble(), entry.value);
        }).toList(),
        color: Theme.of(context).colorScheme.primary,
        barWidth: 4,
        dotData: FlDotData(
          show: true,
          getDotPainter: (spot, percent, barData, index) {
            return FlDotCirclePainter(
              radius: 4, // radius of dots
              color: Theme.of(context).colorScheme.primary,
              strokeWidth: 1, // size of stroke
              strokeColor: Theme.of(context).colorScheme.primaryContainer,
            );
          },
        ),
        belowBarData: BarAreaData(
          show: true,
          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
        ),
      ),
    ],
    borderData: FlBorderData(
      show: true,
      border: Border.all(
        color: Theme.of(context).colorScheme.secondary,
      ),
    ),
    gridData: const FlGridData(show: false),
    titlesData: FlTitlesData(
      leftTitles: const AxisTitles(
        axisNameWidget: Text('Income'),
        axisNameSize: 24,
        sideTitles: SideTitles(
          showTitles: false,
          reservedSize: 0,
        ),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: 1,
          getTitlesWidget: (value, meta) {
            return bottomTitleWidgets(
              value,
              meta,
              400,
            );
          },
        ),
      ),
      rightTitles: const AxisTitles(
        sideTitles: SideTitles(
          showTitles: false,
          reservedSize: 0,
        ),
      ),
      topTitles: const AxisTitles(
        axisNameWidget: Text('Week'),
        axisNameSize: 24,
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 0,
        ),
      ),
    ),
  );
}

Widget bottomTitleWidgets(double value, TitleMeta meta, double chartWidth) {
  final style = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 18 * chartWidth / 600,
  );
  String text;
  switch (value.toInt()) {
    case 0:
      text = 'Mon';
      break;
    case 1:
      text = 'Tues';
      break;
    case 2:
      text = 'Wed';
      break;
    case 3:
      text = 'Thurs';
      break;
    case 4:
      text = 'Fri';
      break;
    case 5:
      text = 'Sat';
      break;
    case 6:
      text = 'Sun';
      break;
    default:
      return Container();
  }

  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: Text(text, style: style),
  );
}