import 'package:flutter/material.dart';
import 'package:school_management_system_flutter/widgets/side_menu.dart';
import '../../db/database_helper.dart';
import '../../models/expense.dart';
import 'expense_form_screen.dart';

class ExpenseListScreen extends StatefulWidget {
  const ExpenseListScreen({super.key});

  @override
  State<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  List<Expense> expenses = [];

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    final db = await DatabaseHelper().database;
    final results = await db.query('expenses', orderBy: 'createdAt DESC');
    setState(() {
      expenses = results.map((e) => Expense.fromMap(e)).toList();
    });
  }

  Future<void> _deleteExpense(int id) async {
    final db = await DatabaseHelper().database;
    await db.delete('expenses', where: 'id = ?', whereArgs: [id]);
    _loadExpenses();
  }

  void _goToForm([Expense? expense]) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ExpenseFormScreen(expense: expense),
      ),
    );
    _loadExpenses();
  }
void _navigate(BuildContext context, String route) {
    Navigator.pushReplacementNamed(context, route);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Management'),
        centerTitle: true,
      ),
      drawer: SideMenu(
              onMenuSelected: (route) => _navigate(context, route),
              currentRoute: ModalRoute.of(context)!.settings.name ?? '/dashboard',
            ),
      body: expenses.isEmpty
          ? const Center(child: Text('No expenses found'))
          : ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                final e = expenses[index];
                return ListTile(
                  title: Text(e.description),
                  subtitle: Text(
                    'Value: \$${e.amount.toStringAsFixed(2)}\nDate: ${e.createdAt}',
                  ),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _goToForm(e),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Confirm Delete'),
                            content: const Text('Delete this expense?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  _deleteExpense(e.id!);
                                },
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  shape: Border(
                    bottom: BorderSide(),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _goToForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
