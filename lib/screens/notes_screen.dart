// lib/screens/notes_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../components/note_input_dialog.dart';
import '../components/note_item.dart';
import '../models/note.dart';
import '../providers/auth_provider.dart';
import '../services/notes_service.dart';
import '../widgets/empty_state.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  // The route is protected, so a user always exists on this screen
  late final String _userId = context.read<AuthProvider>().user!.$id;

  List<Note> notes = [];
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  Note? editingNote;
  bool loading = true;
  bool saving = false;
  String? error;

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  Future<void> loadNotes() async {
    setState(() {
      loading = true;
      error = null;
    });
    try {
      final result = await notesService.list(_userId);
      if (!mounted) return;
      setState(() => notes = result);
    } catch (e) {
      if (!mounted) return;
      setState(() => error = e.toString());
      debugPrint('LOAD NOTES FAILED: $e');
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<bool> saveNote() async {
    final title = titleController.text.trim();
    final content = contentController.text.trim();

    if (title.isEmpty && content.isEmpty) {
      showMessage('Please enter a note.');
      return false;
    }
    if (saving) return false;

    setState(() => saving = true);
    final draft = NoteDraft(title: title, content: content);

    try {
      if (editingNote == null) {
        final created = await notesService.create(_userId, draft);
        if (!mounted) return false;
        setState(() => notes.insert(0, created));
        showMessage('Note saved.');
      } else {
        final id = editingNote!.id;
        final updated = await notesService.update(id, draft);
        if (!mounted) return false;
        setState(() {
          final index = notes.indexWhere((n) => n.id == id);
          if (index != -1) notes[index] = updated;
        });
        showMessage('Note updated.');
      }
      editingNote = null;
      titleController.clear();
      contentController.clear();
      return true;
    } catch (e) {
      debugPrint('SAVE NOTE FAILED: $e');
      if (mounted) showMessage('Could not save note: $e');
      return false;
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  Future<void> deleteNote(String id) async {
    try {
      await notesService.delete(id);
      if (!mounted) return;
      setState(() => notes.removeWhere((n) => n.id == id));
      showMessage('Note deleted.');
    } catch (e) {
      debugPrint('DELETE NOTE FAILED: $e');
      if (mounted) showMessage('Could not delete note: $e');
    }
  }

  void addNote() {
    editingNote = null;
    titleController.clear();
    contentController.clear();
    showNoteDialog();
  }

  void editNote(Note note) {
    editingNote = note;
    titleController.text = note.title;
    contentController.text = note.content;
    showNoteDialog();
  }

  void showNoteDialog() {
    showDialog<void>(
      context: context,
      builder: (_) => NoteInputDialog(
        titleController: titleController,
        contentController: contentController,
        isEditing: editingNote != null,
        onSave: saveNote,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        title: const Text('My Notes'),
        actions: [
          IconButton(icon: const Icon(Icons.add_circle), onPressed: addNote),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(error!),
                        const SizedBox(height: 12),
                        FilledButton(
                          onPressed: loadNotes,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: loadNotes,
                  // Stays a ListView even when empty so pull-to-refresh works
                  child: notes.isEmpty
                      ? ListView(children: [EmptyState(onCreate: addNote)])
                      : ListView.builder(
                          padding: const EdgeInsets.all(15),
                          itemCount: notes.length,
                          itemBuilder: (context, index) => NoteItem(
                            note: notes[index],
                            onEdit: editNote,
                            onDelete: deleteNote,
                          ),
                        ),
                ),
    );
  }
}
