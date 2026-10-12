// lib/widgets/empty_state.dart
import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          const Text('📝', style: TextStyle(fontSize: 48)),
          Text('No notes yet', style: textTheme.titleLarge),
          const Text(
            'Write your first note. It is private: only you can see it.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          FilledButton(onPressed: onCreate, child: const Text('Create a note')),
        ],
      ),
    );
  }
}
