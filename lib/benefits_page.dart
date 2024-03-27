import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'functions.dart';
import 'main.dart';
import 'dart:io';

class Benefit {
  final String title;
  final String description;
  final double amount;
  final XFile? image;
  final DateTime selectedDate;
  final DateTime selectedTime;

  Benefit({
    required this.title,
    required this.description,
    required this.amount,
    required this.image,
    required this.selectedDate,
    required this.selectedTime,
  });

  // Convert a Benefit object into a Map
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'amount': amount,
      'image': image?.path,
      'selectedDate': selectedDate.toIso8601String(),
      'selectedTime': selectedTime.toIso8601String(),
    };
  }

  // Create a Benefit object from a Map
  factory Benefit.fromJson(Map<String, dynamic> json) {
    return Benefit(
      title: json['title'],
      description: json['description'],
      amount: json['amount'],
      image: json['image'] != null ? XFile(json['image']) : null,
      selectedDate: DateTime.parse(json['selectedDate']),
      selectedTime: DateTime.parse(json['selectedTime']),
    );
  }
}

class BenefitsPage extends StatelessWidget {
  const BenefitsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var benefits = Provider.of<MyAppState>(context).benefits;

    // Group the benefits by date
    var groupedBenefits = groupBy<Benefit, String>(
      benefits,
      (benefit) => DateFormat('MMMM dd, yyyy').format(benefit.selectedDate),
    );

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBarBuilder.buildAppBar('Benefits'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: SizedBox(
              width: constraints.maxWidth * 0.975,
              child: ListView.builder(
                itemCount: groupedBenefits.length,
                itemBuilder: (context, index) {
                  var date = groupedBenefits.keys.elementAt(index);
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
                },
              ),
            ),
          );
        },
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

class BenefitCard extends StatelessWidget {
  final Benefit benefit;

  const BenefitCard({super.key, required this.benefit});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: constraints.maxWidth * 0.975,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        benefit.title,
                        style: const TextStyle(
                          fontSize: 18,
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
                  Text(
                    benefit.description,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 16),
                  if (benefit.image != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.file(
                        File(benefit.image!.path),
                        width: double.infinity,
                        fit: BoxFit.scaleDown,
                      ),
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

class AddBenefitsPage extends StatefulWidget {
  const AddBenefitsPage({super.key});

  @override
  _AddBenefitsPageState createState() => _AddBenefitsPageState();
}

class _AddBenefitsPageState extends State<AddBenefitsPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  XFile? image;
  DateTime _selectedDate = DateTime.now();
  DateTime _selectedTime = DateTime.now();

  Future<void> pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );

    if (result != null) {
      PlatformFile file = result.files.first;

      setState(() {
        image = XFile(file.path!);
      });
    } else {
      // User canceled the picker
    }
  }

  void removeImage() {
    setState(() {
      image = null;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Benefits'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.975,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, bottom: 16.0),
                      child: TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          labelText: 'Title',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the title';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, bottom: 16.0),
                      child: TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the description';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, bottom: 16.0),
                      child: TextFormField(
                        controller: _amountController,
                        decoration: InputDecoration(
                          labelText: 'Amount',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the amount';
                          }
                          return null;
                        },
                      ),
                    ),
                    if (image == null)
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8, right: 8, bottom: 8.0),
                        child: TextButton(
                          onPressed: pickImage,
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20.0, horizontal: 50.0),
                            backgroundColor:
                                Theme.of(context).colorScheme.primaryContainer,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.image),
                              Text('Pick Image'),
                            ],
                          ),
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.only(left: 4, right: 4, bottom: 8.0),
                        child: SizedBox(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    return Card(
                                      color: Theme.of(context).colorScheme.primaryContainer,
                                      child: Column(
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              'Selected Image',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          if (image != null)
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(8.0),
                                              child: Image.file(
                                                File(image!.path),
                                                width: constraints.maxWidth * 0.975,
                                                fit: BoxFit.scaleDown,
                                              ),
                                            ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 4, right: 4),
                                child: TextButton(
                                  onPressed: removeImage,
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20.0, horizontal: 50.0),
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.image),
                                      Text('Remove Image'),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, bottom: 8.0),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width:
                                  MediaQuery.of(context).size.width * 0.85 / 2,
                              child: Card(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                child: ListTile(
                                  leading: const Icon(
                                    Icons.calendar_today,
                                    size: 18,
                                  ),
                                  title: Text(
                                    DateFormat('MM/dd/yyyy')
                                        .format(_selectedDate),
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  onTap: () async {
                                    final date = await showDatePicker(
                                      context: context,
                                      initialDate: _selectedDate,
                                      firstDate:
                                          DateTime(DateTime.now().year - 5),
                                      lastDate:
                                          DateTime(DateTime.now().year + 5),
                                    );
                                    if (date != null) {
                                      setState(() {
                                        _selectedDate = date;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            SizedBox(
                              width:
                                  MediaQuery.of(context).size.width * 0.85 / 2,
                              child: Card(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                child: ListTile(
                                  leading: const Icon(
                                    Icons.access_time,
                                    size: 18,
                                  ),
                                  title: Text(
                                    DateFormat('hh:mm a').format(_selectedTime),
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  onTap: () async {
                                    final time = await showTimePicker(
                                      context: context,
                                      initialTime:
                                          TimeOfDay.fromDateTime(_selectedTime),
                                    );
                                    if (time != null) {
                                      setState(() {
                                        _selectedTime = DateTime(
                                          _selectedDate.year,
                                          _selectedDate.month,
                                          _selectedDate.day,
                                          time.hour,
                                          time.minute,
                                        );
                                      });
                                    }
                                  },
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
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            final benefit = Benefit(
              title: _titleController.text,
              description: _descriptionController.text,
              amount: double.parse(_amountController.text),
              image: image,
              selectedDate: _selectedDate,
              selectedTime: _selectedTime,
            );
            Provider.of<MyAppState>(context, listen: false).addBenefit(benefit);
            Navigator.of(context).pop();
          }
        },
        label: const Text('Save'),
        icon: const Icon(Icons.save),
      ),
    );
  }
}
