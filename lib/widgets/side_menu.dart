import 'package:flutter/material.dart';
import 'package:school_management_system_flutter/screens/reports/balance_sheet_report_screen.dart';
import 'package:school_management_system_flutter/screens/reports/expense_report_screen.dart';
import 'package:school_management_system_flutter/screens/reports/income_statement_report_screen.dart';
import 'package:school_management_system_flutter/screens/reports/cash_flow_report_screen.dart';

class SideMenu extends StatelessWidget {
  final Function(String) onMenuSelected;
  final String currentRoute;

  const SideMenu({
    super.key,
    required this.onMenuSelected,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              'School Management',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          _drawerItem(context, Icons.dashboard, 'Dashboard', '/dashboard'),
          _drawerItem(context, Icons.class_, 'Classes', '/classes'),
          _drawerItem(context, Icons.people, 'Students', '/students'),
          _drawerItem(context, Icons.receipt, 'Invoices', '/invoices'),
          _drawerItem(context, Icons.money_off, 'Expenses', '/expenses'),
          _drawerItem(context, Icons.balance, 'Liabilities', '/liabilities'),
          _drawerItem(context, Icons.bar_chart, 'Reports', '/reports/menu'),
          _drawerItem(context, Icons.logout, 'Logout', '/login'),
        ],
      ),
    );
  }

  Widget _drawerItem(
      BuildContext context, IconData icon, String title, String route) {
      if (title != "Reports"){
        return ListTile(
          leading: Icon(icon),
          title: Text(title),
          selected: route == currentRoute,
          onTap: () {
            Navigator.of(context).pop(); // Close drawer
            if (route != currentRoute) {
              onMenuSelected(route);
            }
          },
        );
      } else {
//       print("###### title");
        return ExpansionTile(
                   leading: Icon(Icons.category),
                   title: Text('Reports'),
                   children: <Widget>[
                     ListTile(
                       title: Text('Cash Flow'),
                      //  () {
                      //       Navigator.of(context).pop(); // Close drawer
                      //       if (route != currentRoute) {
                      //         onMenuSelected(route);
                      //       }
                      //     },
                       onTap: () {
                         Navigator.push(
                           context,
                           MaterialPageRoute(builder: (_) => const CashFlowReportScreen())
                         );
                       },
                     ),
                     ListTile(
                       title: Text('Balance Sheet'),
                       onTap: () {
                         Navigator.push(
                           context,
                           MaterialPageRoute(builder: (_) => const BalanceSheetReportScreen())
                         );
                       },
                     ),
                     ListTile(
                       title: Text('Expenses'),
                       onTap: () {
                         Navigator.push(
                           context,
                           MaterialPageRoute(builder: (_) => const ExpenseReportScreen())
                         );
                       },
                     ),
                     ListTile(
                        title: Text('Income Statement'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const IncomeStatementReportScreen())
                          );
                        },
                      ),
                   ],
                 );
      }
  }
}
