import 'package:flutter/material.dart';
import 'package:school_management_system_flutter/widgets/side_menu.dart';
import '../../db/database_helper.dart';
import '../../models/liability.dart';

class LiabilityFormScreen extends StatefulWidget {
  final Liability? liability;
  const LiabilityFormScreen({super.key, this.liability});

  @override
  State<LiabilityFormScreen> createState() => _LiabilityFormScreenState();
}

class _LiabilityFormScreenState extends State<LiabilityFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _valueController;
  late TextEditingController _createdAtController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.liability?.name ?? '');
    _valueController =
        TextEditingController(text: widget.liability?.value.toString() ?? '');
    _createdAtController =
        TextEditingController(text: widget.liability?.createdAt ?? '');
  }

  Future<void> _saveLiability() async {
    if (_formKey.currentState!.validate()) {
      final db = await DatabaseHelper().database;
      final liability = Liability(
        id: widget.liability?.id,
        name: _nameController.text.trim(),
        value: double.parse(_valueController.text.trim()),
        createdAt: _createdAtController.text.trim(),
      );

      if (widget.liability == null) {
        await db.insert('liabilities', liability.toMap());
      } else {
        await db.update(
          'liabilities',
          liability.toMap(),
          where: 'id = ?',
          whereArgs: [widget.liability!.id],
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
    final isEditing = widget.liability != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Liability' : 'Add Liability'),
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
                  labelText: 'Liability Name',
                  border: OutlineInputBorder(),
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter liability name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _valueController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Value',
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
                onPressed: _saveLiability,
                child: Text(isEditing ? 'Update' : 'Create'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
