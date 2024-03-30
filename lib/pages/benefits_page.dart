import 'dart:typed_data';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import '../input_pages/add_benefits_page.dart';
import '../input_pages/edit_benefits_page.dart';
import '../graphs/benefits_graph.dart';
import 'package:intl/intl.dart';
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
      amount: (json['amount'] is int) ? (json['amount'] as int).toDouble() : json['amount'],
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

class BenefitsPage extends StatefulWidget {
  const BenefitsPage({super.key});

  @override
  BenefitsPageState createState() => BenefitsPageState();
}

class BenefitsPageState extends State<BenefitsPage> {
  late MyAppState _myAppState;
  final ScrollController _scrollController = ScrollController();
  bool _showFab = true;

  @override
  void initState() {
    super.initState();
    _myAppState = Provider.of<MyAppState>(context, listen: false);
    _myAppState.isInBenefitsPage = true;

    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_showFab == true) {
          setState(() {
            _showFab = false;
          });
        }
      }

      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (_showFab == false) {
          setState(() {
            _showFab = true;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _myAppState.isInBenefitsPage = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var benefits = Provider.of<MyAppState>(context).benefits;

    if (benefits.isEmpty) {
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: AppBar(
            title: const Padding(
              padding: EdgeInsets.only(top: 15.0),
              child: Text(
                'Benefits',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 12.0, right: 15),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh'),
                  onPressed: () {
                    Provider.of<MyAppState>(context, listen: false)
                        .loadAppState();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.primaryContainer,
                    ),
                  ),
                ),
              ),
            ],
            toolbarHeight: 100,
          ),
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
      var groupedBenefits = groupBy<Benefit, String>(
        benefits,
        (benefit) => DateFormat('MMMM dd, yyyy').format(benefit.selectedDate),
      );

      var categoryExpenses = calculateCategoryExpenses(benefits);
      var categoryColors = calculateCategoryColors(benefits);

      return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: AppBar(
            title: const Padding(
              padding: EdgeInsets.only(top: 15.0),
              child: Text(
                'Benefits',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 12.0, right: 15),
                child: SizedBox(
                  width: 130,
                  height: 40,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text('Refresh'),
                    onPressed: () {
                      Provider.of<MyAppState>(context, listen: false)
                          .loadAppState();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).colorScheme.primaryContainer,
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
            toolbarHeight: 100,
          ),
        ),
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            double cardWidth = constraints.maxWidth * 0.975;
            return Center(
              child: SizedBox(
                width: cardWidth,
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: groupedBenefits.length,
                  itemBuilder: (context, index) {
                    var date = groupedBenefits.keys.elementAt(index);
                    var benefitsForDate = groupedBenefits[date]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
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
                                          'Over The Past Year',
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
                                            child:
                                                PieChartLegend(categoryColors),
                                          ),
                                        ],
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            date,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ...benefitsForDate.map((benefit) {
                          return BenefitCard(benefit: benefit);
                        }),
                      ],
                    );
                  },
                ),
              ),
            );
          },
        ),
        floatingActionButton: _showFab
            ? FloatingActionButton.extended(
                heroTag: 'addBenefits',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddBenefitsPage()),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Add'),
              )
            : null,
      );
    }
  }
}

class BenefitCard extends StatelessWidget {
  final Benefit benefit;

  const BenefitCard({super.key, required this.benefit});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double cardWidth = constraints.maxWidth * 0.975;
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: cardWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        benefit.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        DateFormat('HH:mm a').format(benefit.selectedTime),
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Text.rich(
                    TextSpan(
                      children: <TextSpan>[
                        const TextSpan(
                          text: 'Category: ',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: benefit.category,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      children: <TextSpan>[
                        const TextSpan(
                          text: 'Company: ',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: benefit.companyName,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      children: <TextSpan>[
                        const TextSpan(
                          text: 'Amount: ',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: NumberFormat.currency(symbol: '₱')
                              .format(benefit.amount),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      children: <TextSpan>[
                        const TextSpan(
                          text: 'Transaction Number: ',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: benefit.transactionNumber,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      children: <TextSpan>[
                        const TextSpan(
                          text: 'Description: ',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: benefit.description,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (benefit.imageBytes != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.memory(
                        benefit.imageBytes!,
                        width: double.infinity,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          Provider.of<MyAppState>(context, listen: false)
                              .deleteBenefit(benefit);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    EditBenefitsPage(benefit: benefit)),
                          );
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primaryContainer,
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Delete Confirmation'),
                                content: const Text(
                                    'Are you sure you want to delete this benefit?'),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('Cancel'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('Delete'),
                                    onPressed: () {
                                      Provider.of<MyAppState>(context,
                                              listen: false)
                                          .removeBenefit(benefit);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.delete),
                        label: const Text('Delete'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primaryContainer,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
