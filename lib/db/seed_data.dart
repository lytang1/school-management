import 'package:sqflite/sqflite.dart';

Future<void> seedDatabase(Database db) async {
  // Insert sample user
  await db.insert('users', {
    'username': 'admin',
    'password': 'admin123',
  });

  // Insert sample classes
  await db.insert('classes', {
    'studyYear': '2024',
    'className': 'Grade 1',
    'fee': 500.0,
  });
  await db.insert('classes', {
    'studyYear': '2024',
    'className': 'Grade 2',
    'fee': 600.0,
  });

  // Insert sample students
  await db.insert('students', {
    'name': 'Alice Johnson',
    'dob': '2015-03-01',
    'gender': 'Female',
    'classId': 1,
  });
  await db.insert('students', {
    'name': 'Bob Smith',
    'dob': '2014-06-12',
    'gender': 'Male',
    'classId': 2,
  });

  // Insert sample expenses
  await db.insert('expenses', {
    'amount': 300.0,
    'description': 'Books',
    'createdAt': DateTime.now().toIso8601String(),
  });

  // Insert sample liabilities
  await db.insert('liabilities', {
    'name': 'Loan Repayment',
    'value': 1000.0,
    'createdAt': DateTime.now().toIso8601String(),
  });

  // Insert sample invoices
  await db.insert('invoices', {
    'studentId': 1,
    'createdAt': DateTime.now().toIso8601String(),
  });

  // Insert invoice items (linked to invoice ID 1)
  await db.insert('invoice_items', {
    'invoiceId': 1,
    'itemName': 'class_fee',
    'amount': 500.0,
  });
  await db.insert('invoice_items', {
    'invoiceId': 1,
    'itemName': 'books',
    'amount': 150.0,
  });
}
