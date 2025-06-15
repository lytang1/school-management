import 'package:flutter/material.dart';
import 'package:school_management_system_flutter/widgets/side_menu.dart';
import '../../db/database_helper.dart';
import '../../models/class_model.dart';
import 'class_form_screen.dart';

class ClassListScreen extends StatefulWidget {
  const ClassListScreen({super.key});

  @override
  State<ClassListScreen> createState() => _ClassListScreenState();
}

class _ClassListScreenState extends State<ClassListScreen> {
  List<SchoolClass> classes = [];

  @override
  void initState() {
    super.initState();
    _loadClasses();
  }

  Future<void> _loadClasses() async {
    final db = await DatabaseHelper().database;
    final result = await db.query('classes');
    setState(() {
      classes = result.map((e) => SchoolClass.fromMap(e)).toList();
    });
  }

  Future<void> _deleteClass(int id) async {
    final db = await DatabaseHelper().database;
    await db.delete('classes', where: 'id = ?', whereArgs: [id]);
    _loadClasses();
  }

  void _goToForm([SchoolClass? schoolClass]) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ClassFormScreen(schoolClass: schoolClass),
      ),
    );
    _loadClasses();
  }
  void _navigate(BuildContext context, String route) {
      Navigator.pushReplacementNamed(context, route);
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Class Management'),
        centerTitle: true,
      ),
      drawer: SideMenu(
                    onMenuSelected: (route) => _navigate(context, route),
                    currentRoute: ModalRoute.of(context)!.settings.name ?? '/dashboard',
                  ),
      body: classes.isEmpty
          ? const Center(child: Text('No classes found'))
          : ListView.builder(
              itemCount: classes.length,
              itemBuilder: (context, index) {
                final c = classes[index];
                return ListTile(
                  title: Text('${c.className} (${c.studyYear})'),
                  subtitle: Text('Fee: \$${c.fee.toStringAsFixed(2)}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _goToForm(c),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Confirm Delete'),
                            content: const Text('Delete this class?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  _deleteClass(c.id!);
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
