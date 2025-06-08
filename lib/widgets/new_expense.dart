import 'package:expense_tracker_app/models/category.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final _formatter = DateFormat('dd MMMM yyyy', 'it_IT');

class NewExpense extends StatefulWidget {
  const NewExpense({super.key});

  @override
  State<StatefulWidget> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  void _presentDatePicker() async {
    final Locale deviceLocale =
        WidgetsBinding.instance.platformDispatcher.locale;
    final now = DateTime.now();
    final firstDate = DateTime(
      now.year - 1,
      now.month,
      now.day,
    );

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
      locale: deviceLocale,
    );

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _onChangeCategory(Category? category) {
    if (category == null) {
      return;
    }

    setState(() {
      _selectedCategory = category;
    });
  }

  void _submitExpenseData() {
    final enteredAmount = double.tryParse(
      _amountController.text,
    );
    final isAmountInvalid =
        enteredAmount == null || enteredAmount <= 0;

    if (_titleController.text.trim().isEmpty ||
        isAmountInvalid ||
        _selectedDate == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Invalid input'),
          content: Text(
            'Please make sure a valid title, amount, date and category was entered.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Ok'),
            )
          ],
        ),
      );
      return;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            maxLength: 50,
            decoration: InputDecoration(
              label: Text('Title'),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixText: '€',
                    label: Text('Amount'),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment:
                      CrossAxisAlignment.center,
                  children: [
                    Text(
                      _selectedDate == null
                          ? 'No date selected'
                          : _formatter.format(
                            _selectedDate!,
                          ),
                    ),
                    IconButton(
                      onPressed: _presentDatePicker,
                      icon: const Icon(
                        Icons.calendar_month,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              DropdownButton(
                value: _selectedCategory,
                items:
                    Category.values
                        .map(
                          (category) => DropdownMenuItem(
                            value: category,
                            child: Text(
                              category.name.toUpperCase(),
                            ),
                          ),
                        )
                        .toList(),
                onChanged:
                    (category) =>
                        _onChangeCategory(category),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: _submitExpenseData,
                child: Text('Save expense'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
