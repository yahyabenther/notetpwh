// lib/models/note.dart
import 'package:appwrite/models.dart' as models;

class NoteDraft {
  const NoteDraft({required this.title, required this.content});
  final String title;
  final String content;
}

class Note {
  const Note({
    required this.id,
    required this.title,
    required this.content,
    required this.userId,
  });

  final String id;
  final String title;
  final String content;
  final String userId;

  factory Note.fromRow(models.Row row) => Note(
        id: row.$id,
        title: row.data['title']?.toString() ?? '',
        content: row.data['content']?.toString() ?? '',
        userId: row.data['userId']?.toString() ?? '',
      );
}
