import 'package:sqflite/sqflite.dart';

Future<void> insertMockData(Database db) async {
  // Users
  await db.insert('users', {
    'username': 'admin',
    'password': 'admin123',
  });

  // Classes
  await db.insert('classes', {
    'studyYear': '2023',
    'className': 'Nursery',
    'fee': 300.0,
  });
  await db.insert('classes', {
    'studyYear': '2023',
    'className': 'Kindergarten',
    'fee': 350.0,
  });
  await db.insert('classes', {
    'studyYear': '2023',
    'className': 'Grade 1',
    'fee': 400.0,
  });

  // Students
  await db.insert('students', {
    'name': 'Liam Williams',
    'dob': '2017-01-05',
    'gender': 'Male',
    'classId': 1,
  });
  await db.insert('students', {
    'name': 'Sophia Brown',
    'dob': '2016-11-12',
    'gender': 'Female',
    'classId': 2,
  });
  await db.insert('students', {
    'name': 'Mason Smith',
    'dob': '2015-08-30',
    'gender': 'Male',
    'classId': 3,
  });

  // Expenses
  await db.insert('expenses', {
    'amount': 250.0,
    'description': 'Utility Bills',
    'createdAt': '2023-08-01T09:00:00',
  });
  await db.insert('expenses', {
    'amount': 150.0,
    'description': 'Stationery Purchase',
    'createdAt': '2023-08-10T11:30:00',
  });
  await db.insert('expenses', {
    'amount': 500.0,
    'description': 'Teacher Salaries',
    'createdAt': '2023-08-15T14:45:00',
  });

  // Liabilities
  await db.insert('liabilities', {
    'name': 'Bank Loan',
    'value': 2000.0,
    'createdAt': '2023-07-20T10:00:00',
  });

  // Invoices
  await db.insert('invoices', {
    'studentId': 1,
    'createdAt': '2023-08-05T10:15:00',
  });
  await db.insert('invoices', {
    'studentId': 2,
    'createdAt': '2023-08-06T09:45:00',
  });

  // Invoice Items
  await db.insert('invoice_items', {
    'invoiceId': 1,
    'itemName': 'class_fee',
    'amount': 300.0,
  });
  await db.insert('invoice_items', {
    'invoiceId': 1,
    'itemName': 'books',
    'amount': 50.0,
  });
  await db.insert('invoice_items', {
    'invoiceId': 2,
    'itemName': 'class_fee',
    'amount': 350.0,
  });
  await db.insert('invoice_items', {
    'invoiceId': 2,
    'itemName': 'uniform',
    'amount': 75.0,
  });
}
