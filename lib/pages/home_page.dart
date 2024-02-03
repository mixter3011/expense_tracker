import 'package:finflow/components/expense_summary.dart';
import 'package:finflow/components/expense_tile.dart';
import 'package:finflow/data/expense_data.dart';
import 'package:finflow/models/expense_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});


  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // text controllers
  final newExpenseNameController = TextEditingController();
  final newExpenseRupeesController = TextEditingController();
  final newExpensePaiseController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // prepare data on startup 
    Provider.of<ExpenseData>(context, listen: false).prepareData();
  }

  // add new expense
  void addNewExpense() {
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: const Text('Add new expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // expense name
            TextField(
              controller: newExpenseNameController,
              decoration: const InputDecoration(
                hintText: "Expense Name",
              ),
            ),

            // expense amount
            Row( children: [
              // Rupees
              Expanded(
                child: TextField(
                  controller: newExpenseRupeesController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: "Rupees"
                  ),
                ),
              ),

              // Paise
              Expanded(
                child: TextField(
                  controller: newExpensePaiseController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: "Paise"
                  ),
                ),
              ),
            ],),
          ],
        ),
        actions: [
          // save button
          MaterialButton(
            onPressed: save,
            child: const Text('Save'),
          ),

          // cancel button
          MaterialButton(
            onPressed: cancel,
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  // delete expense
  void deleteEXpense(ExpenseItem expense) {
    Provider.of<ExpenseData>(context, listen: false).deleteExpense(expense);
  }

  // save 
  void save(){
    // only save expense if all fields are filled
    if (newExpenseNameController.text.isNotEmpty &&
    newExpenseRupeesController.text.isNotEmpty &&
    newExpensePaiseController.text.isNotEmpty) {
      // put Rupees and Paise together
    String amount = '${newExpenseRupeesController.text}.${newExpensePaiseController.text}';
    
    
    // create expense item
    ExpenseItem newExpense = ExpenseItem(
      amount: amount, 
      dateTime: DateTime.now(), 
      name: newExpenseNameController.text,
    );
    // add the new expense
    Provider.of<ExpenseData>(context, listen: false).addNewExpense(newExpense);
    }

    Navigator.pop(context);
    clear();
  }

  // cancel
  void cancel(){
    Navigator.pop(context);
    clear();
  }

  // clear controllers
  void clear() {
    newExpenseNameController.clear();
    newExpenseRupeesController.clear();
    newExpensePaiseController.clear();
  }
  
  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
      builder: (context, value, child) => Scaffold(
      backgroundColor: Colors.grey[300],
      floatingActionButton: FloatingActionButton(
        onPressed: addNewExpense,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30)
        ),
        child: const Icon(Icons.add),
      ),
      body: ListView(children: [
        // weekly summary
        ExpenseSummary(startOfWeek: value.startOfWeekDate()),

        const SizedBox(height: 25),

        // expense list
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
        itemCount: value.getAllExpenseList().length,
        itemBuilder: (context, index) => ExpenseTile(
          deleteTapped: (p0) => deleteEXpense(value.getAllExpenseList()[index]),
          amount: value.getAllExpenseList()[index].amount, 
          dateTime: value.getAllExpenseList()[index].dateTime, 
          name: value.getAllExpenseList()[index].name,
        ),
      ),
     ]
    ),
    ),
  );
 }
}