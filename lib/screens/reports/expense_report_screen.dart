import 'package:flutter/material.dart';
import 'package:school_management_system_flutter/widgets/side_menu.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

import '../../db/database_helper.dart';

class ExpenseReportScreen extends StatefulWidget {
  const ExpenseReportScreen({super.key});

  @override
  State<ExpenseReportScreen> createState() => _ExpenseReportScreenState();
}

class _ExpenseReportScreenState extends State<ExpenseReportScreen> {
  final List<Map<String, dynamic>> _expenses = [];

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    final db = await DatabaseHelper().database;
    final results = await db.rawQuery('SELECT description, amount, createdAt FROM expenses');

    _expenses.clear();
    for (var row in results) {
      _expenses.add({
        'description': row['description'] ?? '',
        'amount': (row['amount'] as num).toDouble(),
        'createdAt': DateTime.tryParse(row['createdAt'] as String) ?? DateTime.now(),
      });
    }

    setState(() {});
  }

  Future<void> _exportToExcel() async {
    final excel = Excel.createExcel();
    final sheet = excel['Expenses'];

    // Add headers
    sheet.appendRow([
      TextCellValue('Description'),
      TextCellValue('Amount'),
      TextCellValue('Date'),
    ]);

    // Add data rows
    for (var e in _expenses) {
      sheet.appendRow([
        TextCellValue(e['description'].toString()),
        DoubleCellValue((e['amount'] as num).toDouble()),
        TextCellValue(DateFormat('yyyy-MM-dd').format(e['createdAt'])),
      ]);
    }

    // Let user pick file save location
    String? selectedPath = await FilePicker.platform.saveFile(
      dialogTitle: 'Save Expense Report',
      fileName: 'expense_report.xlsx',
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    if (selectedPath == null) return; // User cancelled

    final file = File(selectedPath);
    await file.writeAsBytes(excel.encode()!);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Exported to ${file.path}')),
    );
  }



  void _navigate(BuildContext context, String route) {
    Navigator.pushReplacementNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Expense Report')),
      drawer: SideMenu(
        onMenuSelected: (route) => _navigate(context, route),
        currentRoute: ModalRoute.of(context)!.settings.name ?? '/dashboard',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _expenses.isEmpty
            ? const Center(child: Text('No expense data available'))
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Expense Report',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _exportToExcel,
              icon: const Icon(Icons.download),
              label: const Text('Export as Excel'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Description')),
                    DataColumn(label: Text('Amount')),
                    DataColumn(label: Text('Date')),
                  ],
                  rows: _expenses.map((e) {
                    return DataRow(
                      cells: [
                        DataCell(Text(e['description'])),
                        DataCell(Text(e['amount'].toStringAsFixed(2))),
                        DataCell(Text(DateFormat.yMMMd().format(e['createdAt']))),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
