import 'dart:io';

import 'package:expense_tracker_app/models/category.dart';
import 'package:expense_tracker_app/models/expense.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final _formatter = DateFormat('dd MMMM yyyy', 'it_IT');

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

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

  void _showDialog() {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder:
            (ctx) => CupertinoAlertDialog(
              title: Text('Invalid input'),
              content: Text(
                'Please make sure a valid title, amount, date and category was entered.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Ok'),
                ),
              ],
            ),
      );
    } else {
      showDialog(
        context: context,
        builder:
            (ctx) => AlertDialog(
              title: Text('Invalid input'),
              content: Text(
                'Please make sure a valid title, amount, date and category was entered.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Ok'),
                ),
              ],
            ),
      );
    }
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
      _showDialog();
      return;
    }

    final expenseToBeAdded = Expense(
      title: _titleController.text,
      amount: enteredAmount,
      date: _selectedDate!,
      category: _selectedCategory,
    );

    widget.onAddExpense(expenseToBeAdded);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace =
        MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(
      builder: (ctx, constraints) {
        final maxWidthScreen = constraints.maxWidth;

        return SizedBox(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                16,
                16,
                16,
                keyboardSpace + 16,
              ),
              child: Column(
                children: [
                  //ToDo: refactor this code to reuse widgets and avoid duplicate code
                  if (maxWidthScreen >= 600)
                    Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _titleController,
                            maxLength: 50,
                            decoration: InputDecoration(
                              label: Text('Title'),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: _amountController,
                            keyboardType:
                                TextInputType.number,
                            decoration: InputDecoration(
                              prefixText: '€',
                              label: Text('Amount'),
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    TextField(
                      controller: _titleController,
                      maxLength: 50,
                      decoration: InputDecoration(
                        label: Text('Title'),
                      ),
                    ),
                  const SizedBox(height: 8),
                  if (maxWidthScreen >= 600)
                    Row(
                      children: [
                        DropdownButton(
                          value: _selectedCategory,
                          items:
                              Category.values
                                  .map(
                                    (
                                      category,
                                    ) => DropdownMenuItem(
                                      value: category,
                                      child: Text(
                                        category.name
                                            .toUpperCase(),
                                      ),
                                    ),
                                  )
                                  .toList(),
                          onChanged:
                              (category) =>
                                  _onChangeCategory(
                                    category,
                                  ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.end,
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
                                onPressed:
                                    _presentDatePicker,
                                icon: const Icon(
                                  Icons.calendar_month,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _amountController,
                            keyboardType:
                                TextInputType.number,
                            decoration: InputDecoration(
                              prefixText: '€',
                              label: Text('Amount'),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.end,
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
                                onPressed:
                                    _presentDatePicker,
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
                  if (maxWidthScreen >= 600)
                    Row(
                      children: [
                        const Spacer(),
                        TextButton(
                          onPressed:
                              () => Navigator.pop(context),
                          child: Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: _submitExpenseData,
                          child: Text('Save expense'),
                        ),
                      ],
                    )
                  else
                    Row(
                      children: [
                        DropdownButton(
                          value: _selectedCategory,
                          items:
                              Category.values
                                  .map(
                                    (
                                      category,
                                    ) => DropdownMenuItem(
                                      value: category,
                                      child: Text(
                                        category.name
                                            .toUpperCase(),
                                      ),
                                    ),
                                  )
                                  .toList(),
                          onChanged:
                              (category) =>
                                  _onChangeCategory(
                                    category,
                                  ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed:
                              () => Navigator.pop(context),
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
            ),
          ),
        );
      },
    );
  }
}
