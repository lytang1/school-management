import 'package:flutter/material.dart';
import '../../db/database_helper.dart';
import '../../models/class_model.dart';

class ClassFormScreen extends StatefulWidget {
  final SchoolClass? schoolClass;
  const ClassFormScreen({super.key, this.schoolClass});

  @override
  State<ClassFormScreen> createState() => _ClassFormScreenState();
}

class _ClassFormScreenState extends State<ClassFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _studyYearController;
  late TextEditingController _classNameController;
  late TextEditingController _feeController;

  @override
  void initState() {
    super.initState();
    _studyYearController = TextEditingController(text: widget.schoolClass?.studyYear ?? '');
    _classNameController = TextEditingController(text: widget.schoolClass?.className ?? '');
    _feeController = TextEditingController(text: widget.schoolClass?.fee.toString() ?? '');
  }

  Future<void> _saveClass() async {
    if (_formKey.currentState!.validate()) {
      final db = await DatabaseHelper().database;
      final newClass = SchoolClass(
        id: widget.schoolClass?.id,
        studyYear: _studyYearController.text.trim(),
        className: _classNameController.text.trim(),
        fee: double.parse(_feeController.text.trim()),
      );

      if (widget.schoolClass == null) {
        await db.insert('classes', newClass.toMap());
      } else {
        await db.update(
          'classes',
          newClass.toMap(),
          where: 'id = ?',
          whereArgs: [widget.schoolClass!.id],
        );
      }
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _studyYearController.dispose();
    _classNameController.dispose();
    _feeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.schoolClass != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Class' : 'Add Class'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _studyYearController,
                decoration: const InputDecoration(
                  labelText: 'Study Year',
                  border: OutlineInputBorder(),
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter study year' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _classNameController,
                decoration: const InputDecoration(
                  labelText: 'Class Name',
                  border: OutlineInputBorder(),
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter class name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _feeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Fee',
                  border: OutlineInputBorder(),
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Enter fee';
                  if (double.tryParse(val) == null) return 'Enter valid number';
                  return null;
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _saveClass,
                child: Text(isEditing ? 'Update' : 'Create'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
