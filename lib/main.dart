import 'package:flutter/material.dart';
import 'package:expense_tracker_app/widgets/expenses.dart';
import 'package:intl/date_symbol_data_local.dart';

void main(){
  initializeDateFormatting();

  runApp(
    MaterialApp(
      home: Expenses(),
    ),
  );
}