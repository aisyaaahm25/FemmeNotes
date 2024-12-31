import 'package:femme_notes_app/pages/providers/note_provider.dart';
import 'package:flutter/material.dart';
import 'package:femme_notes_app/pages/models/note_model.dart';
import '../theme.dart';
import 'package:provider/provider.dart';

class AddNotePage extends StatefulWidget {
  const AddNotePage({super.key});

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  @override
  void dispose() {
    // Membersihkan controller saat widget dihancurkan
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

  Future<void> _submitNote() async {
    if (titleController.text.trim().isEmpty ||
        contentController.text.trim().isEmpty) {
      _showAlertDialog('Please complete all fields');
      return;
    }

    final newNote = NoteModel(
      title: titleController.text.trim(),
      content: contentController.text.trim(),
    );

    try {
      await Provider.of<NoteProvider>(context, listen: false)
          .addnote(context, newNote);
      _showAlertDialog('Note successfully added!', isSuccess: true);
    } catch (err) {
      _showAlertDialog('Failed to add note: $err');
    }
  }

  @override
  Widget build(BuildContext context) {
    PreferredSizeWidget header() {
      return AppBar(
        backgroundColor: background01,
        automaticallyImplyLeading: true,
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 40),
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage(
                  "assets/image-profile.png",
                ),
              ),
            ),
          ),
        ],
      );
    }

    Widget titleInput() {
      return Container(
        margin: const EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Title",
              style: tertiaryTextStyle.copyWith(
                fontSize: 16,
                fontWeight: medium,
              ),
            ),
            const SizedBox(height: 5),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: "Enter title here",
                hintStyle: subtitleTextStyle,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: subtitleColor01),
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget contentInput() {
      return Container(
        margin: const EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Content",
              style: tertiaryTextStyle.copyWith(
                fontSize: 16,
                fontWeight: medium,
              ),
            ),
            const SizedBox(height: 5),
            TextField(
              controller: contentController,
              maxLines: 8,
              decoration: InputDecoration(
                hintText: "Enter content here",
                hintStyle: subtitleTextStyle,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: subtitleColor01),
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget saveButton() {
      return Container(
        height: 50,
        width: double.infinity,
        margin: const EdgeInsets.only(top: 30),
        child: TextButton(
          onPressed: _submitNote,
          style: TextButton.styleFrom(
            backgroundColor: buttonColor01,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            "Save Note",
            style: primaryTextStyle.copyWith(
              fontSize: 16,
              fontWeight: semibold,
            ),
          ),
        ),
      );
    }

    Widget content() {
      return SafeArea(
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 30),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Add Note",
                  style: tertiaryTextStyle.copyWith(
                    fontSize: 22,
                    fontWeight: semibold,
                  ),
                ),
                titleInput(),
                contentInput(),
                saveButton(),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: background01,
      appBar: header(),
      body: content(),
    );
  }
}
