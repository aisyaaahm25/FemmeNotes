import 'dart:convert';

import 'package:femme_notes_app/config.dart';
import 'package:femme_notes_app/pages/models/note_model.dart';
import 'package:femme_notes_app/pages/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class NoteProvider with ChangeNotifier {
  List<NoteModel> _notes = [];
  List<NoteModel> get notes => _notes;

  Future<void> fetchNotes(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('${Config.apiUrl}/todo'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _notes = (data['todos'] as List)
          .map((note) => NoteModel.fromJson(note))
          .toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load notes');
    }
  }

  Future<void> addnote(BuildContext context, NoteModel note) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.post(
      Uri.parse('${Config.apiUrl}/todo'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(note.toJson()),
    );

    if (response.statusCode == 201) {
      _notes.add(note);
      notifyListeners();
    } else {
      throw Exception('Failed to add note');
    }
  }

  Future<void> updateNote(BuildContext context, NoteModel note) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.put(
      Uri.parse('${Config.apiUrl}/todo/${note.id}'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(note.toJson()),
    );

    if (response.statusCode == 201) {
      final index = _notes.indexWhere((n) => n.id == note.id);
      print('Found index: $index');

      if (index != -1) {
        _notes[index] = note;
        notifyListeners();
      }
      notifyListeners();
    } else {
      throw Exception('Failed to update note');
    }
  }

  Future<void> deleteNote(BuildContext context, int noteId) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.delete(
      Uri.parse('${Config.apiUrl}/todo/$noteId'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      _notes.removeWhere((note) => note.id == noteId);
      notifyListeners();
    } else {
      throw Exception('Failed to delete note');
    }
  }
}
