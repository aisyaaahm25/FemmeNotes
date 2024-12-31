import 'package:femme_notes_app/pages/providers/note_provider.dart';
import 'package:flutter/material.dart';
import 'package:femme_notes_app/pages/models/note_model.dart';
import 'package:provider/provider.dart';

class EditNotePage extends StatefulWidget {
  final NoteModel note;
  final Function(NoteModel) onSave;

  const EditNotePage({
    super.key,
    required this.note,
    required this.onSave,
  });

  @override
  State<EditNotePage> createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  late TextEditingController titleController;
  late TextEditingController contentController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.note.title);
    contentController = TextEditingController(text: widget.note.content);
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  void _showAlertDialog(String message, {bool isSuccess = false}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isSuccess ? 'Success' : 'Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context); // Menutup dialog
                if (isSuccess) {
                  Navigator.pop(context); // Kembali ke halaman sebelumnya
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveNote() async {
    final title = titleController.text.trim();
    final content = contentController.text.trim();

    // Validasi input kosong
    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title and Content cannot be empty')),
      );
      return;
    }

    final updatedNote = NoteModel(
      id: widget.note.id,
      title: title,
      content: content,
      color: widget.note.color,
      updatedAt: DateTime.now(),
    );

    try {
      await Provider.of<NoteProvider>(context, listen: false)
          .updateNote(context, updatedNote);

      widget.onSave(updatedNote);
      _showAlertDialog('Note successfully updated!', isSuccess: true);
    } catch (err) {
      _showAlertDialog('Failed to add note: $err');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Note'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          TextField(
            controller: contentController,
            maxLines: 4,
            decoration: const InputDecoration(labelText: 'Content'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveNote,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
