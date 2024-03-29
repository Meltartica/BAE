import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../pages/benefits_page.dart';
import '../main.dart';

class EditBenefitsPage extends StatefulWidget {
  final Benefit? benefit;

  const EditBenefitsPage({super.key, this.benefit});

  @override
  EditBenefitsPageState createState() => EditBenefitsPageState();
}

class EditBenefitsPageState extends State<EditBenefitsPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _categoryController = TextEditingController();
  final _transactionNumberController = TextEditingController();
  final _companyNameController = TextEditingController();
  String? _selectedCategory;
  bool _isBottomSheetOpen = false;
  Uint8List? imageBytes;
  DateTime _selectedDate = DateTime.now();
  DateTime _selectedTime = DateTime.now();

  final List<String> _categories = [
    'Health and Wellness',
    'Transportation',
    'Utilities',
    'Internet',
    'Phone',
    'Travel',
    'Food',
    'Accommodation',
    'Miscellaneous',
    'Others'
  ];

  void showBottomSheet(BuildContext context, Function(String) onItemSelected) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return ListView.builder(
            itemCount: _categories.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(_categories[index]),
                onTap: () {
                  onItemSelected(_categories[index]);
                  _selectedCategory = _categories[index];
                  Navigator.of(context).pop();
                },
              );
            },
          );
        }).then((value) {
      setState(() {
        _isBottomSheetOpen = false;
      });
    });

    setState(() {
      _isBottomSheetOpen = true;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.benefit != null) {
      _titleController.text = widget.benefit!.title;
      _descriptionController.text = widget.benefit!.description;
      _amountController.text = widget.benefit!.amount.toString();
      _categoryController.text = widget.benefit!.category;
      _transactionNumberController.text = widget.benefit!.transactionNumber;
      _companyNameController.text = widget.benefit!.companyName;
      imageBytes = widget.benefit!.imageBytes;
      _selectedCategory = widget.benefit!.category;
      _selectedDate = widget.benefit!.selectedDate;
      _selectedTime = widget.benefit!.selectedTime;
    }
  }

  Future<void> pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );

    if (result != null) {
      PlatformFile file = result.files.first;

      setState(() {
        imageBytes = file.bytes;
      });
    } else {
      // User canceled the picker
    }
  }

  void removeImage() {
    setState(() {
      imageBytes = null;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    _categoryController.dispose();
    _transactionNumberController.dispose();
    _companyNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Edit Benefits'),
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
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, bottom: 16.0),
                      child: TextFormField(
                        readOnly: true,
                        controller: _categoryController,
                        decoration: InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: IconButton(
                              icon: Icon(_isBottomSheetOpen
                                  ? Icons.arrow_drop_up
                                  : Icons.arrow_drop_down),
                              onPressed: () {
                                showBottomSheet(context, (selectedCategory) {
                                  _categoryController.text = selectedCategory;
                                });
                              },
                            ),
                          ),
                        ),
                        onTap: () {
                          showBottomSheet(context, (selectedCategory) {
                            _categoryController.text = selectedCategory;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a category';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, bottom: 16.0),
                      child: TextFormField(
                        controller: _transactionNumberController,
                        decoration: InputDecoration(
                          labelText: 'Transaction Number',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the transaction number';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, bottom: 16.0),
                      child: TextFormField(
                        controller: _companyNameController,
                        decoration: InputDecoration(
                          labelText: 'Company Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the company name';
                          }
                          return null;
                        },
                      ),
                    ),
                    if (imageBytes == null)
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
                                          if (imageBytes != null)
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(8.0),
                                              child: Image.memory(
                                                imageBytes!,
                                                width: double.infinity,
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
            if (_selectedCategory == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please select a category')),
              );
              return;
            }
            final benefit = Benefit(
              title: _titleController.text,
              description: _descriptionController.text,
              amount: double.parse(_amountController.text),
              category: _selectedCategory!,
              transactionNumber: _transactionNumberController.text,
              companyName: _companyNameController.text,
              imageBytes: imageBytes,
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