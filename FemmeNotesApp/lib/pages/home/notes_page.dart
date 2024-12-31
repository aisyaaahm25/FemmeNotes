import 'package:flutter/material.dart';
import 'package:femme_notes_app/pages/add_note_page.dart';
import 'package:femme_notes_app/pages/edit_note_page.dart';
import 'package:femme_notes_app/theme.dart';
import 'package:femme_notes_app/pages/widgets/note_card.dart';
import 'package:femme_notes_app/pages/providers/note_provider.dart';
import 'package:provider/provider.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NoteProvider>(context, listen: false).fetchNotes(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    PreferredSizeWidget header() {
      return PreferredSize(
        preferredSize: const Size.fromHeight(110),
        child: AppBar(
          backgroundColor: background01,
          automaticallyImplyLeading: false,
          centerTitle: false,
          elevation: 0,
          flexibleSpace: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 75, left: 30),
                child: Text(
                  "Notes",
                  style: tertiaryTextStyle.copyWith(
                    fontSize: 24,
                    fontWeight: semibold,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                    top: 8, left: 30, right: 30), // Jarak Divider
                child: const Divider(
                  color: Colors.grey, // Warna garis
                  thickness: 1, // Ketebalan garis
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget addButton() {
      return FloatingActionButton(
        heroTag: 'notes_add_button',
        onPressed: () {
          // Buka halaman formulir input
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddNotePage(),
            ),
          ).then((_) {
            print('Kembali ke NotesPage.');
          });
        },
        backgroundColor: secondaryColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      );
    }

    Widget listNotes() {
      return Consumer<NoteProvider>(
        builder: (context, noteProvider, _) {
          if (noteProvider.notes.isEmpty) {
            return Center(
              child: Text(
                "No notes yet.\nTap + to add one.",
                style: primaryTextStyle.copyWith(
                  fontSize: 12,
                  color: subtitleColor01,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }

          final notes = noteProvider.notes;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 3 / 4),
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return NoteCard(
                  note: note,
                  index: index,
                  onDelete: () async {
                    try {
                      await Provider.of<NoteProvider>(context, listen: false)
                          .deleteNote(context, note.id!);
                    } catch (err) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to delete note: $err')),
                      );
                    }
                  },
                  onEdit: () {
                    showDialog(
                      context: context,
                      builder: (context) => EditNotePage(
                        note: note,
                        onSave: (updatedNote) async {
                          try {
                            await Provider.of<NoteProvider>(context,
                                    listen: false)
                                .updateNote(context, updatedNote);
                            Provider.of<NoteProvider>(context, listen: false)
                                .fetchNotes(context);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Failed to update note: $e',
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    );
                  },
                  onMove: () {},
                  onSave: () {},
                );
              },
            ),
          );
        },
      );
    }

    Widget content() {
      return listNotes(); // GridView digunakan langsung tanpa SingleChildScrollView
    }

    return Scaffold(
      backgroundColor: background01,
      resizeToAvoidBottomInset: false,
      appBar: header(),
      body: content(),
      floatingActionButton: addButton(),
    );
  }
}
