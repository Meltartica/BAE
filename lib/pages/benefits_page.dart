import 'dart:typed_data';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:provider/provider.dart';
import '../input_pages/add_benefits_page.dart';
import '../input_pages/edit_benefits_page.dart';
import '../graphs/benefits_graph.dart';
import 'package:intl/intl.dart';
import "../lists/benefits_list.dart";
import '../functions.dart';
import '../main.dart';

class Benefit {
  final String title;
  final String description;
  final double amount;
  final Uint8List? imageBytes;
  final DateTime selectedDate;
  final DateTime selectedTime;
  final String category;
  final String transactionNumber;
  final String companyName;

  Benefit({
    required this.title,
    required this.description,
    required this.amount,
    required this.imageBytes,
    required this.selectedDate,
    required this.selectedTime,
    required this.category,
    required this.transactionNumber,
    required this.companyName,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'amount': amount,
      'imageBytes': imageBytes,
      'selectedDate': selectedDate.toIso8601String(),
      'selectedTime': selectedTime.toIso8601String(),
      'category': category,
      'transactionNumber': transactionNumber,
      'companyName': companyName,
    };
  }

  // Create a Benefit object from a Map
  factory Benefit.fromJson(Map<String, dynamic> json) {
    return Benefit(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      amount: json['amount'] ?? 0.0,
      imageBytes: json['imageBytes'] != null
          ? Uint8List.fromList(
              (json['imageBytes'] as List<dynamic>).cast<int>())
          : null,
      selectedDate: DateTime.parse(
          json['selectedDate'] ?? DateTime.now().toIso8601String()),
      selectedTime: DateTime.parse(
          json['selectedTime'] ?? DateTime.now().toIso8601String()),
      category: json['category'] ?? '',
      transactionNumber: json['transactionNumber'] ?? '',
      companyName: json['companyName'] ?? '',
    );
  }
}

class BenefitsPage extends StatelessWidget {
  const BenefitsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var benefits = Provider.of<MyAppState>(context).benefits;

    if (benefits.isEmpty) {
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: AppBarBuilder.buildAppBar('Benefits'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.loyalty_rounded,
                    size: 80, color: Theme.of(context).colorScheme.primary),
                const Text('No benefits yet?',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const Text('Start adding your benefits.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          heroTag: 'addBenefits',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddBenefitsPage()),
            );
          },
          icon: const Icon(Icons.add),
          label: const Text('Add'),
        ),
      );
    } else {
      var categoryExpenses = calculateCategoryExpenses(benefits);
      var categoryColors = calculateCategoryColors(benefits);

      var groupedBenefits = groupBy(benefits, (Benefit benefit) => benefit.category);

      return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: AppBarBuilder.buildAppBar('Benefits'),
        ),
        body: SingleChildScrollView(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              double cardWidth = constraints.maxWidth * 0.975;
              return Column(
                children: [
                  Center(
                    child: Column(
                      children: [
                        SizedBox(
                          width: cardWidth,
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Benefits - Category',
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'Over Past 7 Days',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 200,
                                    width: cardWidth * 0.85,
                                    child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            Expanded(
                                              child: PieChart(
                                                buildPieChartData(
                                                    categoryExpenses,
                                                    categoryColors,
                                                    context),
                                              ),
                                            ),
                                            const SizedBox(width: 32),
                                            Expanded(
                                              child: PieChartLegend(
                                                  categoryColors),
                                            ),
                                          ],
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Column(
                          children: buildBenefitsList(groupedBenefits),
                        ),
                        const SizedBox(height: 75),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          heroTag: 'addBenefits',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddBenefitsPage()),
            );
          },
          icon: const Icon(Icons.add),
          label: const Text('Add'),
        ),
      );
    }
  }
}
