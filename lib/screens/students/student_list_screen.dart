import 'package:flutter/material.dart';
import 'package:school_management_system_flutter/widgets/side_menu.dart';
import '../../db/database_helper.dart';
import '../../models/student.dart';
import '../../models/class_model.dart';
import 'student_form_screen.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  List<Student> students = [];
  Map<int, SchoolClass> classMap = {};

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    final db = await DatabaseHelper().database;

    final classResults = await db.query('classes');
    classMap = {
      for (var c in classResults) c['id'] as int: SchoolClass.fromMap(c)
    };

    final studentResults = await db.query('students');
    setState(() {
      students = studentResults.map((e) => Student.fromMap(e)).toList();
    });
  }

  Future<void> _deleteStudent(int id) async {
    final db = await DatabaseHelper().database;
    await db.delete('students', where: 'id = ?', whereArgs: [id]);
    _loadStudents();
  }

  void _goToForm([Student? student]) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StudentFormScreen(
          student: student,
          classes: classMap.values.toList(),
        ),
      ),
    );
    _loadStudents();
  }
void _navigate(BuildContext context, String route) {
    Navigator.pushReplacementNamed(context, route);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Management'),
        centerTitle: true,
      ),
      drawer: SideMenu(
              onMenuSelected: (route) => _navigate(context, route),
              currentRoute: ModalRoute.of(context)!.settings.name ?? '/dashboard',
            ),
      body: students.isEmpty
          ? const Center(child: Text('No students found'))
          : ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                final s = students[index];
                final studentClass = classMap[s.classId];
                return ListTile(
                  title: Text(s.name),
                  subtitle: Text(
                      'StudentId: ${s.id} | DOB: ${s.dob} | Gender: ${s.gender} | Class: ${studentClass?.className ?? "N/A"}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _goToForm(s),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Confirm Delete'),
                            content: const Text('Delete this student?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  _deleteStudent(s.id!);
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
