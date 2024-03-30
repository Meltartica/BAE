import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../pages/benefits_page.dart';

Map<String, double> calculateCategoryExpenses(List<Benefit> benefits) {
  final pastWeeksBenefits = benefits.where((benefit) {
    final oneYearAgo = DateTime.now().subtract(const Duration(days: 365));
    return benefit.selectedTime.isAfter(oneYearAgo);
  }).toList();

  final Map<String, double> categoryBenefits = {};
  for (var benefit in pastWeeksBenefits) {
    final category = benefit.category;
    categoryBenefits.update(
        category, (existingValue) => existingValue + benefit.amount,
        ifAbsent: () => benefit.amount);
  }

  return categoryBenefits;
}

Map<String, Color> calculateCategoryColors(List<Benefit> benefits) {
  Map<String, Color> categoryColors = {};
  List<Color> availableColors = [Colors.red, Colors.green, Colors.blue, Colors.yellow]; // Add more colors as needed

  int colorIndex = 0;
  for (var benefit in benefits) {
    if (!categoryColors.containsKey(benefit.category)) {
      categoryColors[benefit.category] = availableColors[colorIndex % availableColors.length];
      colorIndex++;
    }
  }

  return categoryColors;
}

List<Color> pieColors = [
  Colors.red,
  Colors.blue,
  Colors.green,
  Colors.yellow,
  Colors.orange,
  Colors.purple,
  Colors.pink,
  Colors.brown,
  Colors.grey,
  Colors.cyan,
  Colors.lime,
  Colors.indigo,
  Colors.teal,
  Colors.amber,
  Colors.deepOrange,
  Colors.lightBlue,
  Colors.lightGreen,
  Colors.deepPurple,
  Colors.pinkAccent,
  Colors.blueGrey,
  // Add more colors if needed
];

PieChartData buildPieChartData(Map<String, double> categoryExpenses, Map<String, Color> categoryColors, BuildContext context) {
  double total = categoryExpenses.values.reduce((a, b) => a + b);

  return PieChartData(
    sectionsSpace: 0,
    centerSpaceRadius: 40,
    sections: categoryExpenses.entries.map((entry) {
      double percentage = (entry.value / total) * 100;
      return PieChartSectionData(
        color: categoryColors[entry.key],
        value: entry.value,
        title: '${percentage.toStringAsFixed(0)}%',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: <Shadow>[
            Shadow(
              offset: Offset(1.0, 1.0),
              blurRadius: 2.0,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ],
        ),
      );
    }).toList(),
  );
}

class PieChartLegend extends StatelessWidget {
  final Map<String, Color> categoryColors;

  const PieChartLegend(this.categoryColors, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: categoryColors.entries.map((entry) {
        return Row(
          children: <Widget>[
            Container(
              width: 20,
              height: 20,
              color: entry.value,
            ),
            const SizedBox(width: 8),
            Text(
              entry.key,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        );
      }).toList(),
    );
  }
}