import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:femme_notes_app/pages/models/task_model.dart';
import 'package:femme_notes_app/config.dart';
import 'package:femme_notes_app/pages/providers/auth_provider.dart';

class TaskProvider with ChangeNotifier {
  List<TaskModel> _tasks = [];
  List<TaskModel> get tasks => _tasks;

  Future<void> fetchTasks(BuildContext context, String date) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('${Config.apiUrl}/task?date=$date'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _tasks = (data['tasks'] as List)
          .map((task) => TaskModel.fromJson(task))
          .toList();
      if (_tasks.isEmpty) {
        notifyListeners();
      }
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  Future<void> addTask(BuildContext context, TaskModel task) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.post(
      Uri.parse('${Config.apiUrl}/task'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(task.toJson()),
    );
    if (response.statusCode == 201) {
      final data = jsonDecode(response.body)['data'];
      final newTask = TaskModel.fromJson(data);
      _tasks.add(newTask);
      notifyListeners();
    } else {
      throw Exception('Failed to add task');
    }
  }

  Future<void> editTask(BuildContext context, TaskModel task) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.put(
      Uri.parse('${Config.apiUrl}/task/${task.id}'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(task.toJson()),
    );
    if (response.statusCode == 201) {
      _tasks = _tasks.map((t) => t.id == task.id ? task : t).toList();
      notifyListeners();
    } else {
      throw Exception('Failed to edit task');
    }
  }

  Future<void> deleteTask(BuildContext context, int? id) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;
    if (token == null) {
      throw Exception('Token not found');
    }
    final response = await http.delete(
      Uri.parse('${Config.apiUrl}/task/$id'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      _tasks.removeWhere((task) => task.id == id);
      notifyListeners();
    } else {
      throw Exception('Failed to delete task');
    }
  }
}
