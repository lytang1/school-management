import 'package:flutter/material.dart';
import 'package:school_management_system_flutter/widgets/side_menu.dart';
import '../../db/database_helper.dart';
import '../../models/invoice.dart';
import 'invoice_form_screen.dart';

class InvoiceListScreen extends StatefulWidget {
  const InvoiceListScreen({super.key});

  @override
  State<InvoiceListScreen> createState() => _InvoiceListScreenState();
}

class _InvoiceListScreenState extends State<InvoiceListScreen> {
  List<Invoice> invoices = [];

  @override
  void initState() {
    super.initState();
    _loadInvoices();
  }

  Future<void> _loadInvoices() async {
    final db = await DatabaseHelper().database;
    final results = await db.query('invoices', orderBy: 'createdAt DESC');
    print("result ${Invoice.fromMap(results[0])}");
    setState(() {
      invoices = results.map((e) => Invoice.fromMap(e)).toList();
    });
  }

  Future<void> _deleteInvoice(int id) async {
    final db = await DatabaseHelper().database;
    await db.delete('invoices', where: 'id = ?', whereArgs: [id]);
    await db.delete('invoice_items', where: 'invoiceId = ?', whereArgs: [id]);
    _loadInvoices();
  }

  void _goToForm([Invoice? invoice]) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => InvoiceFormScreen(invoice: invoice),
      ),
    );
    _loadInvoices();
  }
void _navigate(BuildContext context, String route) {
    Navigator.pushReplacementNamed(context, route);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Invoices')),
      drawer: SideMenu(
              onMenuSelected: (route) => _navigate(context, route),
              currentRoute: ModalRoute.of(context)!.settings.name ?? '/dashboard',
            ),
      body: invoices.isEmpty
          ? const Center(child: Text('No invoices found'))
          : ListView.builder(
              itemCount: invoices.length,
              itemBuilder: (context, index) {
                final invoice = invoices[index];
                return ListTile(
                  title: Text('Invoice #${invoice.id}'),
                  subtitle: Text('Student ID: ${invoice.studentId}\nDate: ${invoice.createdAt}'),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _goToForm(invoice),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteInvoice(invoice.id!),
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
