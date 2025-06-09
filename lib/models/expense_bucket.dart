import 'package:expense_tracker_app/models/category.dart';
import 'package:expense_tracker_app/models/expense.dart';

class Expensebucket {
  const Expensebucket({required this.category, required this.expenses});

 final Category category;
 final List<Expense> expenses;

 double get totalExpense {
  double sum = 0;

  for(final expense in expenses) {
    sum += expense.amount;
  }

  return sum;
 }
}