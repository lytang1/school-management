import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'seed_data.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    return _database ??= await init();
  }

  Future<Database> init() async {
    final path = join(await getDatabasesPath(), 'school.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await _createTables(db);
        await seedDatabase(db); // <-- Add this line
      },
    );
  }

  Future<void> _createTables(Database db) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT,
        password TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE classes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        studyYear TEXT,
        className TEXT,
        fee REAL
      );
    ''');

    await db.execute('''
      CREATE TABLE students (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        dob TEXT,
        gender TEXT,
        classId INTEGER
      );
    ''');

    await db.execute('''
      CREATE TABLE expenses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        amount REAL,
        description TEXT,
        createdAt TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE liabilities (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        value REAL,
        createdAt TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE invoices (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        studentId INTEGER,
        createdAt TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE invoice_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        invoiceId INTEGER,
        itemName TEXT,
        amount REAL
      );
    ''');
  }
  Future<void> insertDefaultUser() async {
      final db = await database;
      await db.insert(
        'users',
        {'username': 'admin', 'password': 'admin'},
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
}
