import 'package:flutter/material.dart';
import 'package:school_management_system_flutter/widgets/side_menu.dart';
import '../../db/database_helper.dart';
import '../../models/student.dart';
import '../../models/class_model.dart';

class StudentFormScreen extends StatefulWidget {
  final Student? student;
  final List<SchoolClass> classes;

  const StudentFormScreen({
    super.key,
    this.student,
    required this.classes,
  });

  @override
  State<StudentFormScreen> createState() => _StudentFormScreenState();
}

class _StudentFormScreenState extends State<StudentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _dobController;
  String? _gender;
  SchoolClass? _selectedClass;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.student?.name ?? '');
    _dobController = TextEditingController(text: widget.student?.dob ?? '');
    _gender = widget.student?.gender;
    _selectedClass = widget.classes.firstWhere(
      (c) => c.id == widget.student?.classId,
      orElse: () {
        if (widget.classes.isNotEmpty) {
          return widget.classes.first;
        } else {
          throw Exception('No class available');
        }
      },
//       orElse: () => widget.classes.isNotEmpty ? widget.classes.first : null,
    );
  }

  Future<void> _saveStudent() async {
    if (!_formKey.currentState!.validate()) return;

    if (_gender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select gender')),
      );
      return;
    }
    if (_selectedClass == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select class')),
      );
      return;
    }

    final db = await DatabaseHelper().database;

    final student = Student(
      id: widget.student?.id,
      name: _nameController.text.trim(),
      dob: _dobController.text.trim(),
      gender: _gender!,
      classId: _selectedClass!.id!,
    );

    if (widget.student == null) {
      await db.insert('students', student.toMap());
    } else {
      await db.update(
        'students',
        student.toMap(),
        where: 'id = ?',
        whereArgs: [widget.student!.id],
      );
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    super.dispose();
  }
void _navigate(BuildContext context, String route) {
    Navigator.pushReplacementNamed(context, route);
  }
  @override
  Widget build(BuildContext context) {
    final isEditing = widget.student != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Student' : 'Add Student'),
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
                  labelText: 'Student Name',
                  border: OutlineInputBorder(),
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter student name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dobController,
                decoration: const InputDecoration(
                  labelText: 'Date of Birth (YYYY-MM-DD)',
                  border: OutlineInputBorder(),
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter date of birth' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _gender,
                items: const [
                  DropdownMenuItem(value: 'Male', child: Text('Male')),
                  DropdownMenuItem(value: 'Female', child: Text('Female')),
                  DropdownMenuItem(value: 'Other', child: Text('Other')),
                ],
                onChanged: (val) => setState(() => _gender = val),
                decoration: const InputDecoration(
                  labelText: 'Gender',
                  border: OutlineInputBorder(),
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Select gender' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<SchoolClass>(
                value: _selectedClass,
                items: widget.classes
                    .map(
                      (c) => DropdownMenuItem(
                        value: c,
                        child: Text('${c.className} (${c.studyYear})'),
                      ),
                    )
                    .toList(),
                onChanged: (val) => setState(() => _selectedClass = val),
                decoration: const InputDecoration(
                  labelText: 'Class',
                  border: OutlineInputBorder(),
                ),
                validator: (val) =>
                    val == null ? 'Select class' : null,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _saveStudent,
                child: Text(isEditing ? 'Update' : 'Create'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
