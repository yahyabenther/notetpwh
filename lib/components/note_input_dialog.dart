import 'package:flutter/material.dart';

class NoteInputDialog extends StatelessWidget {
  const NoteInputDialog({
    super.key,
    required this.titleController,
    required this.contentController,
    required this.isEditing,
    required this.onSave,
  });

  final TextEditingController titleController;
  final TextEditingController contentController;
  final bool isEditing;
  final Future<bool> Function() onSave;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isEditing ? 'Edit Note' : 'Add New Note'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [
          TextField(
            controller: titleController,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(),
            ),
          ),
          TextField(
            controller: contentController,
            maxLines: 5,
            decoration: const InputDecoration(
              labelText: 'Content',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            final saved = await onSave();
            if (saved && context.mounted) Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
