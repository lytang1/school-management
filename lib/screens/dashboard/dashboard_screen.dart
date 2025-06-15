import 'package:flutter/material.dart';
import 'package:school_management_system_flutter/widgets/side_menu.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  void _navigate(BuildContext context, String route) {
    Navigator.pushReplacementNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(
        onMenuSelected: (route) => _navigate(context, route),
        currentRoute: ModalRoute.of(context)!.settings.name ?? '/dashboard',
      ),
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: const Center(
        child: Text('Dashboard Content'),
      ),
    );
  }
}
