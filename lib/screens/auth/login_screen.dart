import 'package:flutter/material.dart';
import 'package:school_management_system_flutter/constant/storageKey.dart';
import 'package:school_management_system_flutter/utils/storageHelper.dart';
import '../../db/database_helper.dart';
// default login username: admin, password: admin123
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loginError = false;

  @override
  void initState() {
    super.initState();
    DatabaseHelper().insertDefaultUser(); // Insert default admin/admin user
  }

  Future<void> _login() async {
    final db = await DatabaseHelper().database;

    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [
        _usernameController.text.trim(),
        _passwordController.text.trim()
      ],
    );

    if (result.isNotEmpty) {
      setState(() => _loginError = false);
      StorageHelper.setStorage(StorageKey.userInfo, result.toString());
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      setState(() => _loginError = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('School Management Login'),
        centerTitle: true,
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(16),
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Login',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Enter username' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Enter password' : null,
                  ),
                  const SizedBox(height: 20),
                  if (_loginError)
                    const Text(
                      'Invalid username or password',
                      style: TextStyle(color: Colors.red),
                    ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _login();
                      }
                    },
                    child: const Text('Login'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
