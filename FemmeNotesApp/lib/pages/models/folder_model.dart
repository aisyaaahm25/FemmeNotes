import 'package:femme_notes_app/pages/models/note_model.dart';

class FolderModel {
  final String name;
  final List<NoteModel> notes;

  FolderModel({
    required this.name,
    List<NoteModel>? notes,
  }) : notes = notes ?? []; // Inisialisasi sebagai list yang dapat dimodifikasi
}
