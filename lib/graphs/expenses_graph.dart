import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../pages/home_page.dart';

// Conversion of Expenses into Daily Expenses
Map<String, dynamic> calculateExpenses(List<Expense> expenses) {
  final pastWeeksExpenses = expenses.where((expense) {
    final weeksAgo = DateTime.now().subtract(const Duration(days: 7 * 2));
    return expense.date.isAfter(weeksAgo) && expense.type != 'Income';
  }).toList();

  final dailyExpenses = {
    'Monday': 0.0,
    'Tuesday': 0.0,
    'Wednesday': 0.0,
    'Thursday': 0.0,
    'Friday': 0.0,
    'Saturday': 0.0,
    'Sunday': 0.0,
  };

  for (var expense in pastWeeksExpenses) {
    final dayOfWeek = DateFormat('EEEE').format(expense.date);
    dailyExpenses.update(
        dayOfWeek, (existingValue) => existingValue + expense.price,
        ifAbsent: () => expense.price);
  }

  return {
    'pastWeeksExpenses': pastWeeksExpenses,
    'dailyExpenses': dailyExpenses,
  };
}

// Generation of Bar Chart Data for Expenses
BarChartData buildBarChartData(Map<String, double> dailyExpenses, BuildContext context) {
  return BarChartData(
    barTouchData: BarTouchData(
      touchTooltipData: BarTouchTooltipData(
        tooltipBgColor: Theme.of(context).colorScheme.primaryContainer,
        tooltipBorder: BorderSide(color: Theme.of(context).colorScheme.primary),
        tooltipRoundedRadius: 10,
        tooltipHorizontalAlignment: FLHorizontalAlignment.right,
        getTooltipItem: (group, groupIndex, rod, rodIndex) {
          String weekDay;
          switch (group.x) {
            case 0:
              weekDay = 'Monday';
              break;
            case 1:
              weekDay = 'Tuesday';
              break;
            case 2:
              weekDay = 'Wednesday';
              break;
            case 3:
              weekDay = 'Thursday';
              break;
            case 4:
              weekDay = 'Friday';
              break;
            case 5:
              weekDay = 'Saturday';
              break;
            case 6:
              weekDay = 'Sunday';
              break;
            default:
              throw Error();
          }
          return BarTooltipItem(
            '$weekDay\n\u20B1',
            const TextStyle(
              fontSize: 16,
            ),
            children: <TextSpan>[
              TextSpan(
                text: (rod.toY).toString(),
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          );
        },
      ),
    ),
    barGroups: dailyExpenses.entries.map((entry) {
      final dayOfWeekIndex = [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday'
      ].indexOf(entry.key);
      return BarChartGroupData(
        x: dayOfWeekIndex,
        barRods: [
          BarChartRodData(
            color: Theme.of(context).colorScheme.primary,
            fromY: 0,
            toY: entry.value,
            width: 32,
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: 5000,
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
          ),
        ],
      );
    }).toList(),
    titlesData: const FlTitlesData(
      show: true,
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: getTitles,
          reservedSize: 38,
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: false,
        ),
      ),
      topTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: false,
        ),
      ),
      rightTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: false,
        ),
      ),
    ),
    borderData: FlBorderData(
      show: false,
    ),
    gridData: const FlGridData(
      show: false,
    ),
  );
}

// X-Position Tiles
Widget getTitles(double value, TitleMeta meta) {
  const style = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );
  Widget text;
  switch (value.toInt()) {
    case 0:
      text = const Text('Mon', style: style);
      break;
    case 1:
      text = const Text('Tue', style: style);
      break;
    case 2:
      text = const Text('Wed', style: style);
      break;
    case 3:
      text = const Text('Thurs', style: style);
      break;
    case 4:
      text = const Text('Fri', style: style);
      break;
    case 5:
      text = const Text('Sat', style: style);
      break;
    case 6:
      text = const Text('Sun', style: style);
      break;
    default:
      text = const Text('', style: style);
      break;
  }
  return SideTitleWidget(
    axisSide: meta.axisSide,
    space: 16,
    child: text,
  );
}