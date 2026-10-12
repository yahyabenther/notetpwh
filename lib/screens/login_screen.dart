// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _registering = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final auth = context.read<AuthProvider>();
    if (_registering) {
      await auth.signUp(_name.text.trim(), _email.text.trim(), _password.text);
    } else {
      await auth.signIn(_email.text.trim(), _password.text);
    }
    // On success the router redirects to "/" by itself (section 7.5)
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 12,
                children: [
                  Text(
                    _registering ? 'Create account' : 'Sign in',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  if (_registering)
                    TextField(
                      controller: _name,
                      decoration: const InputDecoration(labelText: 'Name'),
                    ),
                  TextField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  TextField(
                    controller: _password,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password (min. 8 characters)',
                    ),
                  ),
                  if (auth.error != null)
                    Text(
                      auth.error!,
                      style: TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                  FilledButton(
                    onPressed: auth.busy ? null : _submit,
                    child: auth.busy
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(_registering ? 'Create account' : 'Sign in'),
                  ),
                  TextButton(
                    onPressed: () => setState(() => _registering = !_registering),
                    child: Text(
                      _registering ? 'I already have an account' : "I don't have an account",
                    ),
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