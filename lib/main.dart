import 'package:flutter/material.dart';
import 'package:expense_tracker_app/widgets/expenses.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main(){
  initializeDateFormatting();

  runApp(
    MaterialApp(
      home: Expenses(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
    ),
  );
}