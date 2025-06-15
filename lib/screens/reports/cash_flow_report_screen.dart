import 'dart:ffi';
import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:school_management_system_flutter/db/database_helper.dart';
import 'package:school_management_system_flutter/widgets/side_menu.dart';

class CashFlowReportScreen extends StatefulWidget {
  const CashFlowReportScreen({super.key});

  @override
  State<CashFlowReportScreen> createState() => _CashFlowReportScreenState();
}

class _CashFlowReportScreenState extends State<CashFlowReportScreen> {
  List<Map<String, dynamic>> transactions = [];

  @override
  void initState() {
    super.initState();
    _loadCashFlow();
  }

  Future<void> _loadCashFlow() async {
    final db = await DatabaseHelper().database;
    final result = await db.rawQuery('''
      SELECT description, amount, createdAt, 'Expense' as type FROM expenses
      UNION ALL
      SELECT it.itemName description, it.amount as amount, i.createdAt as createdAt, 'Income' as type FROM invoices i
      join invoice_items it on it.invoiceId = i.id
      ORDER BY createdAt
    ''');
    setState(() {
      transactions = result;
    });
  }

  Future<void> _exportToExcel() async {
    final excel = Excel.createExcel();
    final sheet = excel['CashFlow'];
    sheet.appendRow([
      TextCellValue('Description'),
      TextCellValue('Amount'),
      TextCellValue('Date'),
    ]);

    for (var item in transactions) {
      sheet.appendRow([
        TextCellValue(item['description'].toString()),
        DoubleCellValue((item['amount'] as num).toDouble()),
        TextCellValue(DateFormat('yyyy-MM-dd').format(item['createdAt'])),
      ]);
    }

    final dir = await getApplicationDocumentsDirectory();
    final filePath = '${dir.path}/cash_flow_report.xlsx';
    File(filePath)
      ..createSync(recursive: true)
      ..writeAsBytesSync(excel.encode()!);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Cash Flow Report saved to $filePath')),
    );
  }

  String getAmount(double amount, String type){
    double money = amount;
    if(type == 'Expense') {
      money *= -1;
    }
    return money.toString();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cash Flow Report')),
      drawer: SideMenu(
        currentRoute: ModalRoute.of(context)!.settings.name ?? '',
        onMenuSelected: (route) => Navigator.pushReplacementNamed(context, route),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Cash Flow', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _exportToExcel,
              child: const Text('Export to Excel'),
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
                  rows: transactions.map((e) {
                    return DataRow(
                      cells: [
                        DataCell(Text(e['description'], style: TextStyle(color: e['type'] == 'Income'? Colors.green: Colors.orange),)),
                        DataCell(Text(getAmount(e['amount'], e['type']),style: TextStyle(color: e['type'] == 'Income'? Colors.green: Colors.orange))),
                        DataCell(Text(DateFormat.yMMMd().format(DateTime.parse(e['createdAt'])),style: TextStyle(color: e['type'] == 'Income'? Colors.green: Colors.orange))),
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
