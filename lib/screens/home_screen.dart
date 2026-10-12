// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final user = context.watch<AuthProvider>().user;

    return Scaffold(
      appBar: AppBar(title: const Text('Notes App')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 12,
          children: [
            Text('Notes App', style: textTheme.headlineLarge),
            Text('Hello, ${user?.name.isNotEmpty == true ? user!.name : user?.email}'),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => context.go('/notes'),
              child: const Text('Open my notes →'),
            ),
            TextButton(
              onPressed: () => context.read<AuthProvider>().signOut(),
              child: const Text('Sign out'),
            ),
          ],
        ),
      ),
    );
  }
}