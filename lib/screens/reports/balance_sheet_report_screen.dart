import 'dart:io';
import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:school_management_system_flutter/db/database_helper.dart';
import 'package:school_management_system_flutter/widgets/side_menu.dart';

class BalanceSheetReportScreen extends StatefulWidget {
  const BalanceSheetReportScreen({super.key});

  @override
  State<BalanceSheetReportScreen> createState() => _BalanceSheetReportScreenState();
}

class _BalanceSheetReportScreenState extends State<BalanceSheetReportScreen> {
  List<Map<String, dynamic>> balanceItems = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final db = await DatabaseHelper().database;
    final liabilities = await db.query('liabilities');
    final expenses = await db.query('expenses');

    balanceItems = [
      ...liabilities.map((e) => {
        'type': 'Liability',
        'description': e['name'],
        'amount': e['value'],
        'date': e['createdAt']
      }),
      ...expenses.map((e) => {
        'type': 'Expense',
        'description': e['description'],
        'amount': e['amount'],
        'date': e['createdAt']
      }),
    ];

    setState(() {});
  }

  Future<void> _exportToExcel() async {
    final excel = Excel.createExcel();
    final sheet = excel['BalanceSheet'];

    sheet.appendRow([
      TextCellValue('Type'),
      TextCellValue('Description'),
      TextCellValue('Amount'),
      TextCellValue('Date'),
    ]);

    for (var item in balanceItems) {
      sheet.appendRow([
        TextCellValue(item['type'].toString()),
        TextCellValue(item['description'].toString()),
        DoubleCellValue((item['amount'] as num).toDouble()),
        TextCellValue(DateFormat('yyyy-MM-dd').format(item['date'])),
      ]);
    }

    final directory = await getApplicationDocumentsDirectory();
    final path = "${directory.path}/balance_sheet.xlsx";

    final fileBytes = excel.encode();
    if (fileBytes != null) {
      final file = File(path);
      await file.writeAsBytes(fileBytes, flush: true);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Exported to $path')),
        );
      }
    }
  }

  void _navigate(BuildContext context, String route) {
    Navigator.pushReplacementNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Balance Sheet Report'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _exportToExcel,
          ),
        ],
      ),
      drawer: SideMenu(
        onMenuSelected: (route) => _navigate(context, route),
        currentRoute: ModalRoute.of(context)!.settings.name ?? '/dashboard',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: balanceItems.isEmpty
            ? const Center(child: Text('No data available'))
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Balance Sheet',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Type')),
                    DataColumn(label: Text('Description')),
                    DataColumn(label: Text('Amount')),
                    DataColumn(label: Text('Date')),
                  ],
                  rows: balanceItems
                      .map(
                        (item) => DataRow(cells: [
                      DataCell(Text(item['type'] ?? '')),
                      DataCell(Text(item['description'] ?? '')),
                      DataCell(Text(item['amount'].toString())),
                      DataCell(Text(DateFormat.yMMMd().format(DateTime.parse(item['date'])))),
                    ]),
                  )
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
