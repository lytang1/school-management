import 'package:flutter/material.dart';
import 'package:school_management_system_flutter/widgets/side_menu.dart';
import '../../db/database_helper.dart';
import '../../models/liability.dart';
import 'liability_form_screen.dart';

class LiabilityListScreen extends StatefulWidget {
  const LiabilityListScreen({super.key});

  @override
  State<LiabilityListScreen> createState() => _LiabilityListScreenState();
}

class _LiabilityListScreenState extends State<LiabilityListScreen> {
  List<Liability> liabilities = [];

  @override
  void initState() {
    super.initState();
    _loadLiabilities();
  }

  Future<void> _loadLiabilities() async {
    final db = await DatabaseHelper().database;
    final results = await db.query('liabilities', orderBy: 'createdAt DESC');
    setState(() {
      liabilities = results.map((e) => Liability.fromMap(e)).toList();
    });
  }

  void _goToForm([Liability? liability]) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LiabilityFormScreen(liability: liability),
      ),
    );
    _loadLiabilities();
  }

  Future<void> _deleteLiability(int id) async {
    final db = await DatabaseHelper().database;
    await db.delete('liabilities', where: 'id = ?', whereArgs: [id]);
    _loadLiabilities();
  }
void _navigate(BuildContext context, String route) {
    Navigator.pushReplacementNamed(context, route);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liability Management'),
        centerTitle: true,
      ),
      drawer: SideMenu(
              onMenuSelected: (route) => _navigate(context, route),
              currentRoute: ModalRoute.of(context)!.settings.name ?? '/dashboard',
            ),
      body: liabilities.isEmpty
          ? const Center(child: Text('No liabilities found'))
          : ListView.builder(
              itemCount: liabilities.length,
              itemBuilder: (context, index) {
                final l = liabilities[index];
                return ListTile(
                  title: Text(l.name),
                  subtitle: Text(
                    'Value: \$${l.value.toStringAsFixed(2)}\nDate: ${l.createdAt}',
                  ),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _goToForm(l),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Confirm Delete'),
                            content: const Text('Delete this liability?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  _deleteLiability(l.id!);
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
