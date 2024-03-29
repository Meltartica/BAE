import 'package:bae/graphs/income_graph.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../graphs/expenses_graph.dart';
import '../graphs/transaction_graph.dart';
import '../graphs/category_graph.dart';
import '../functions.dart';
import '../main.dart';

class OverviewPage extends StatelessWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final expenses = Provider.of<MyAppState>(context).expenses;

    final expensesList = expenses.where((expense) => expense.type != 'Income').toList();
    final incomeList = expenses.where((expense) => expense.type == 'Income').toList();

    if (expensesList.isEmpty || incomeList.isEmpty) {
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: AppBarBuilder.buildAppBar('Overview'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline_rounded,
                    size: 80,
                    color: Theme.of(context)
                        .colorScheme
                        .primary),
                const Text('Incomplete Data',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                const Text('Start adding transactions (expense and income) to see the overview.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14)
                ),
              ],
            ),
          ),
        ),
      );
    }
    else {
      final calculatedExpenses = calculateExpenses(expenses);
      final dailyExpenses = calculatedExpenses['dailyExpenses'];

      final calculatedIncome = calculateIncome(expenses);
      final dailyIncome = calculatedIncome['dailyIncome'];

      final calculatedTransaction = calculateTransaction(expenses);
      final dailyTransaction = calculatedTransaction['dailyTransaction'];

      final calculatedCategory = calculateCategoryExpenses(expenses);
      final categoryExpenses = calculatedCategory['categoryExpenses'];
      final categoryColors = calculateCategoryColors(expenses);

      return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: AppBarBuilder.buildAppBar('Overview'),
        ),
        body: SingleChildScrollView(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              double cardWidth = constraints.maxWidth * 0.975;
              return Column(
                children: <Widget>[
                  Center(
                    child: SizedBox(
                      width: cardWidth,
                      child: Column(
                        children: <Widget>[
                          const SizedBox(height: 8),
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
                                            'Transactions',
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'Over Past 7 Days',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Theme
                                                  .of(context)
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
                                      child: LineChart(
                                        buildTLineChartData(
                                            dailyTransaction, context,
                                            expenses),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
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
                                            'Expense - Category',
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'Over Past 7 Days',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Theme
                                                  .of(context)
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
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceEvenly,
                                          children: <Widget>[
                                            Expanded(
                                              child: PieChart(
                                                buildPieChartData(
                                                    categoryExpenses,
                                                    categoryColors, context),
                                              ),
                                            ),
                                            const SizedBox(width: 32),
                                            Expanded(
                                              child: PieChartLegend(
                                                  categoryColors),
                                            ),
                                          ],
                                        )
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Detailed',
                            style: TextStyle(
                                fontSize: 32, fontWeight: FontWeight.bold),
                          ),
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
                                            'Expenses',
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'Over Past 7 Days',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Theme
                                                  .of(context)
                                                  .colorScheme
                                                  .secondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 250,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: BarChart(
                                        buildBarChartData(
                                            dailyExpenses, context),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
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
                                            'Income',
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'Over Past 7 Days',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Theme
                                                  .of(context)
                                                  .colorScheme
                                                  .secondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  SizedBox(
                                    height: 200,
                                    width: cardWidth * 0.85,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: LineChart(
                                        buildLineChartData(
                                            dailyIncome, context, expenses),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      );
    }
  }
}