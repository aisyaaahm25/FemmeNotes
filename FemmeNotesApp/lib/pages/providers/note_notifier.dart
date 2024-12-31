import 'package:flutter/material.dart';
import 'package:femme_notes_app/pages/providers/folder_notifier.dart';
import '../models/note_model.dart';

class NoteNotifier extends ValueNotifier<List<NoteModel>> {
  NoteNotifier() : super([]);

  void addNote(NoteModel note) {
    value = [...value, note];
    notifyListeners();
  }

  void removeNoteCompletely(NoteModel note) {
    // Hapus dari daftar utama
    value = value.where((n) => n.id != note.id).toList();

    // Hapus dari folder
    folderNotifier.removeNoteFromAllFolders(note);

    notifyListeners(); // Harus dipanggil setelah perubahan
  }

  void updateNoteAt(int index, NoteModel updatedNote) {
    value = List.from(value)
      ..[index] = updatedNote; // Gantikan note lama dengan note baru
    notifyListeners();
  }

  /// Fungsi untuk memperbarui catatan berdasarkan id
  void updateNote(NoteModel updatedNote) {
    value = value.map((note) {
      return note.id == updatedNote.id ? updatedNote : note;
    }).toList();
    notifyListeners();
  }
}

// Notifier global yang bisa diakses di seluruh aplikasi
final noteNotifier = NoteNotifier();
