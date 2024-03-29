import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../input_pages/edit_benefits_page.dart';
import '../main.dart';
import '../pages/benefits_page.dart';

List<Widget> buildBenefitsList(Map<String, List<Benefit>> groupedBenefits) {
  return groupedBenefits.keys.map((date) {
    var benefitsForDate = groupedBenefits[date]!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
  }).toList();
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
                          Provider.of<MyAppState>(context,
                              listen: false)
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
                                          .deleteBenefit(benefit);
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