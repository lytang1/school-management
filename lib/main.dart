import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:school_management_system_flutter/constant/storageKey.dart';
import 'package:school_management_system_flutter/utils/storageHelper.dart';
import 'screens/auth/login_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/classes/class_list_screen.dart';
import 'screens/students/student_list_screen.dart';
import 'screens/expenses/expense_list_screen.dart';
import 'screens/liabilities/liability_list_screen.dart';
import 'screens/invoices/invoice_list_screen.dart';
import 'screens/reports/balance_sheet_report_screen.dart';
import 'screens/reports/expense_report_screen.dart';
import 'screens/reports/income_statement_report_screen.dart';
import 'screens/reports/cash_flow_report_screen.dart';
import 'screens/reports/report_menu_screen.dart';
import 'db/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper().init();
  await StorageHelper.init();// ensures db is ready
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return MaterialApp(
      title: 'School Management System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/classes': (context) => const ClassListScreen(),
        '/students': (context) => const StudentListScreen(),
        '/invoices': (context) => const InvoiceListScreen(),
        '/expenses': (context) => const ExpenseListScreen(),
        '/liabilities': (context) => const LiabilityListScreen(),
        '/reports/menu': (context) => const ReportMenuScreen(),
        '/reports/cash_flow': (context) => const CashFlowReportScreen(),
        '/reports/expense': (context) => const ExpenseReportScreen(),
        '/reports/income_statement': (context) => const IncomeStatementReportScreen(),
        '/reports/balance_sheet': (context) => const BalanceSheetReportScreen(),

      },
//
//       routes: {
//         '/login': (_) => const LoginScreen(),
//         '/dashboard': (_) => const DashboardScreen(),
//         '/classes': (_) => const ClassListScreen(),
//         '/students': (_) => const StudentListScreen(),
//         '/expenses': (_) => const ExpenseListScreen(),
//         '/liabilities': (_) => const LiabilityListScreen(),
//         '/invoices': (_) => const InvoiceListScreen(),
//         '/report/balance-sheet': (_) => const BalanceSheetReportScreen(),
//         '/report/expense': (_) => const ExpenseReportScreen(),
//         '/report/income-statement': (_) =>
//             const IncomeStatementReportScreen(),
//       },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    final db = await DatabaseHelper().database;
    final users = await db.query('users');
    String userInfo = await StorageHelper.getStorage(StorageKey.userInfo)?? "";
    await Future.delayed(const Duration(seconds: 1));
    if (userInfo != null || userInfo != "") {
      // No user yet, go to login
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      // For simplicity, assume already logged in
      Navigator.pushReplacementNamed(context, '/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
