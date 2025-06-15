import 'package:flutter/material.dart';
import 'package:school_management_system_flutter/widgets/side_menu.dart';
import '../../db/database_helper.dart';
import '../../models/invoice.dart';
import '../../models/invoice_item.dart';

class InvoiceFormScreen extends StatefulWidget {
  final Invoice? invoice;
  const InvoiceFormScreen({super.key, this.invoice});

  @override
  State<InvoiceFormScreen> createState() => _InvoiceFormScreenState();
}

class _InvoiceFormScreenState extends State<InvoiceFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _studentIdController;
  late TextEditingController _createdAtController;

  List<InvoiceItem> _items = [];

  @override
  void initState() {
    super.initState();
    _studentIdController =
        TextEditingController(text: widget.invoice?.studentId.toString() ?? '');
    _createdAtController =
        TextEditingController(text: widget.invoice?.createdAt ?? '');

    if (widget.invoice != null) {
      _loadInvoiceItems(widget.invoice!.id!);
    }
  }

  Future<void> _loadInvoiceItems(int invoiceId) async {
    final db = await DatabaseHelper().database;
    final results = await db.query(
      'invoice_items',
      where: 'invoiceId = ?',
      whereArgs: [invoiceId],
    );
    setState(() {
      _items = results.map((e) => InvoiceItem.fromMap(e)).toList();
    });
  }

  void _addItem() {
    setState(() {
      _items.add(InvoiceItem(invoiceId: widget.invoice?.id ?? 0, itemName: '', amount: 0));
    });
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  Future<void> _saveInvoice() async {
    if (_formKey.currentState!.validate()) {
      final db = await DatabaseHelper().database;

      final invoice = Invoice(
        id: widget.invoice?.id,
        studentId: int.parse(_studentIdController.text.trim()),
        createdAt: _createdAtController.text.trim(),
      );

      int invoiceId;
      print("##### print data here ${widget.invoice}");
      if (widget.invoice == null) {
        invoiceId = await db.insert('invoices', invoice.toMap());
        print("#### print invoiceId $invoiceId");
      } else {
        await db.update(
          'invoices',
          invoice.toMap(),
          where: 'id = ?',
          whereArgs: [widget.invoice!.id],
        );
        invoiceId = widget.invoice!.id!;
        await db.delete('invoice_items', where: 'invoiceId = ?', whereArgs: [invoiceId]);
      }

      for (var item in _items) {
      print("##### invoice id  $invoiceId ");
        await db.insert('invoice_items', {
          'invoiceId': invoiceId,
          'itemName': item.itemName,
          'amount': item.amount,
        });
      }

      if (mounted) Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _studentIdController.dispose();
    _createdAtController.dispose();
    super.dispose();
  }
void _navigate(BuildContext context, String route) {
    Navigator.pushReplacementNamed(context, route);
  }
  @override
  Widget build(BuildContext context) {
    final isEditing = widget.invoice != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Invoice' : 'Create Invoice'),
      ),
      drawer: SideMenu(
              onMenuSelected: (route) => _navigate(context, route),
              currentRoute: ModalRoute.of(context)!.settings.name ?? '/dashboard',
            ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _studentIdController,
                decoration: const InputDecoration(
                  labelText: 'Student ID',
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Enter student ID' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _createdAtController,
                decoration: const InputDecoration(
                  labelText: 'Date (YYYY-MM-DD)',
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Enter date' : null,
              ),
              const SizedBox(height: 24),
              const Text('Invoice Items', style: TextStyle(fontWeight: FontWeight.bold)),
              ..._items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: item.itemName,
                            decoration: const InputDecoration(labelText: 'Item'),
                            onChanged: (val) => item.itemName = val,
                            validator: (val) => val == null || val.isEmpty ? 'Enter item title' : null,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            initialValue: item.amount.toString(),
                            decoration: const InputDecoration(labelText: 'Amount'),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            onChanged: (val) => item.amount = double.tryParse(val) ?? 0,
                            validator: (val) =>
                                val == null || double.tryParse(val) == null ? 'Enter amount' : null,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.remove_circle, color: Colors.red),
                          onPressed: () => _removeItem(index),
                        ),
                      ],
                    ),
                  ],
                );
              }),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: _addItem,
                icon: const Icon(Icons.add),
                label: const Text('Add Item'),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _saveInvoice,
                child: Text(isEditing ? 'Update' : 'Create'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
