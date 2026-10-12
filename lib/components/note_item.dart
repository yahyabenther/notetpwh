import 'package:flutter/material.dart';
import '../models/note.dart';

class NoteItem extends StatelessWidget {
  const NoteItem({
    super.key,
    required this.note,
    required this.onEdit,
    required this.onDelete,
  });

  final Note note;
  final void Function(Note) onEdit;
  final void Function(String) onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (note.title.isNotEmpty)
              Text(
                note.title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            if (note.content.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(note.content, style: const TextStyle(fontSize: 16)),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: () => onEdit(note), child: const Text('Edit')),
                TextButton(
                  onPressed: () => onDelete(note.id),
                  child: Text(
                    'Delete',
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
