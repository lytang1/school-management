import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:school_management_system_flutter/db/database_helper.dart';
import 'package:school_management_system_flutter/widgets/side_menu.dart';

class IncomeStatementReportScreen extends StatefulWidget {
  const IncomeStatementReportScreen({super.key});

  @override
  State<IncomeStatementReportScreen> createState() => _IncomeStatementReportScreenState();
}

class _IncomeStatementReportScreenState extends State<IncomeStatementReportScreen> {
  double totalRevenue = 0;
  double totalExpenses = 0;

  @override
  void initState() {
    super.initState();
    _loadIncomeStatement();
  }

  Future<void> _loadIncomeStatement() async {
    final db = await DatabaseHelper().database;

    final expensesResult = await db.rawQuery('SELECT SUM(amount) as total FROM expenses');
    totalExpenses = (expensesResult.first['total'] as num?)?.toDouble() ?? 0;

    final revenueResult = await db.rawQuery('SELECT SUM(it.amount) as total FROM invoices i join invoice_items it on i.id == it.invoiceid');
    totalRevenue = (revenueResult.first['total'] as num?)?.toDouble() ?? 0;

    setState(() {});
  }

  Future<void> _exportToExcel() async {
    final excel = Excel.createExcel();
    final sheet = excel['IncomeStatement'];

    sheet.appendRow([TextCellValue('Item'), TextCellValue('Amount')]);
    sheet.appendRow([TextCellValue('Total Revenue'), DoubleCellValue(totalRevenue.toDouble())]);
    sheet.appendRow([TextCellValue('Total Expenses'), DoubleCellValue(totalExpenses.toDouble())]);
    sheet.appendRow([TextCellValue('Net Income'), DoubleCellValue((totalRevenue - totalExpenses).toDouble())]);

    final dir = await getApplicationDocumentsDirectory();
    final filePath = '${dir.path}/income_statement.xlsx';
    File(filePath)
      ..createSync(recursive: true)
      ..writeAsBytesSync(excel.encode()!);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Income Statement saved to $filePath')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final netIncome = totalRevenue - totalExpenses;

    return Scaffold(
      appBar: AppBar(title: const Text('Income Statement')),
      drawer: SideMenu(
        currentRoute: ModalRoute.of(context)!.settings.name ?? '',
        onMenuSelected: (route) => Navigator.pushReplacementNamed(context, route),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Income Statement', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _exportToExcel,
              child: const Text('Export to Excel'),
            ),
            const SizedBox(height: 20),
            DataTable(columns: const [
              DataColumn(label: Text('Item')),
              DataColumn(label: Text('Amount')),
            ], rows: [
              DataRow(cells: [const DataCell(Text('Total Revenue')), DataCell(Text(totalRevenue.toStringAsFixed(2),style: TextStyle(color: Colors.green ),textAlign: TextAlign.right,))]),
              DataRow(cells: [const DataCell(Text('Total Expenses')), DataCell(Text((totalExpenses*-1).toStringAsFixed(2),style: TextStyle(color: Colors.orange ),textAlign: TextAlign.right))]),
              DataRow(cells: [const DataCell(Text('Net Income')), DataCell(Text(netIncome.toStringAsFixed(2),style: TextStyle(color: netIncome >=0? Colors.green : Colors.orange ),textAlign: TextAlign.right))]),
            ])
          ],
        ),
      ),
    );
  }
}
