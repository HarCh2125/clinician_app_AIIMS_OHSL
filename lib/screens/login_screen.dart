import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _username = TextEditingController();
  final _password = TextEditingController();
  bool _showError = false;

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    // 1. grab inputs
    final username = _username.text.trim();
    final password = _password.text.trim();

    // 2. capture AppState *before* awaiting
    final appState = context.read<AppState>();

    // 3. perform async auth
    final ok = await AuthService().authenticate(username, password);

    // 4. guard against widget having been disposed
    if (!mounted) return;

    // 5. update state without using `context` across the await
    if (ok) {
      appState.login();
    } else {
      setState(() {
        _showError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 400,
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _username,
                decoration: InputDecoration(labelText: 'Doctor ID'),
              ),
              TextField(
                controller: _password,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _handleLogin, child: Text('Log In')),
              if (_showError)
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    'Invalid credentials',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
