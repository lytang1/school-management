import 'package:flutter/material.dart';
import 'package:school_management_system_flutter/widgets/side_menu.dart';
import 'cash_flow_report_screen.dart';
import 'balance_sheet_report_screen.dart';
import 'expense_report_screen.dart';
import 'income_statement_report_screen.dart';

class ReportMenuScreen extends StatelessWidget {
  const ReportMenuScreen({super.key});
void _navigate(BuildContext context, String route) {
    Navigator.pushReplacementNamed(context, route);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reports')),
      drawer: SideMenu(
              onMenuSelected: (route) => _navigate(context, route),
              currentRoute: ModalRoute.of(context)!.settings.name ?? '/dashboard',
            ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Cash Flow Report'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CashFlowReportScreen()),
            ),
          ),
          ListTile(
            title: const Text('Balance Sheet'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const BalanceSheetReportScreen()),
            ),
          ),
          ListTile(
            title: const Text('Expense Report'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ExpenseReportScreen()),
            ),
          ),
          ListTile(
            title: const Text('Income Statement'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const IncomeStatementReportScreen()),
            ),
          ),
        ],
      ),
    );
  }
}
