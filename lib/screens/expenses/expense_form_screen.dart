import 'package:flutter/material.dart';
import 'package:school_management_system_flutter/widgets/side_menu.dart';
import '../../db/database_helper.dart';
import '../../models/expense.dart';

class ExpenseFormScreen extends StatefulWidget {
  final Expense? expense;
  const ExpenseFormScreen({super.key, this.expense});

  @override
  State<ExpenseFormScreen> createState() => _ExpenseFormScreenState();
}

class _ExpenseFormScreenState extends State<ExpenseFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _valueController;
  late TextEditingController _createdAtController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.expense?.description ?? '');
    _valueController =
        TextEditingController(text: widget.expense?.amount.toString() ?? '');
    _createdAtController =
        TextEditingController(text: widget.expense?.createdAt ?? '');
  }

  Future<void> _saveExpense() async {
    if (_formKey.currentState!.validate()) {
      final db = await DatabaseHelper().database;
      final expense = Expense(
        id: widget.expense?.id,
        description: _nameController.text.trim(),
        amount: double.parse(_valueController.text.trim()),
        createdAt: _createdAtController.text.trim(),
      );

      if (widget.expense == null) {
        await db.insert('expenses', expense.toMap());
      } else {
        await db.update(
          'expenses',
          expense.toMap(),
          where: 'id = ?',
          whereArgs: [widget.expense!.id],
        );
      }

      if (mounted) Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _valueController.dispose();
    _createdAtController.dispose();
    super.dispose();
  }
  void _navigate(BuildContext context, String route) {
      Navigator.pushReplacementNamed(context, route);
    }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.expense != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Expense' : 'Add Expense'),
        centerTitle: true,
      ),
      drawer: SideMenu(
              onMenuSelected: (route) => _navigate(context, route),
              currentRoute: ModalRoute.of(context)!.settings.name ?? '/dashboard',
            ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Expense Title',
                  border: OutlineInputBorder(),
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter expense title' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _valueController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Enter value';
                  if (double.tryParse(val) == null) return 'Enter valid number';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _createdAtController,
                decoration: const InputDecoration(
                  labelText: 'Date (YYYY-MM-DD)',
                  border: OutlineInputBorder(),
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter date' : null,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _saveExpense,
                child: Text(isEditing ? 'Update' : 'Create'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
