import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:femme_notes_app/config.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  String? get token => _token;

  String? _name;
  String? _email;

  String? get name => _name;
  String? get email => _email;

  bool get isAuthenticated => _token != null;

  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    notifyListeners();
  }

  Future<void> signIn(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    notifyListeners();
  }

  Future<void> signOut() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    notifyListeners();
  }

  Future<void> fetchUserProfile() async {
    if (_token != null) {
      final response = await http
          .get(Uri.parse('${Config.apiUrl}/user'), headers: <String, String>{
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json; charset=UTF-8',
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _name = data['user']['name'];
        _email = data['user']['email'];
        notifyListeners();
      } else {
        throw Exception('Failed to load user profile');
      }
    }
  }

  Future<void> updateUser(String name, String email) async {
    if (_token != null) {
      final response = await http.put(
        Uri.parse('${Config.apiUrl}/user'),
        headers: <String, String>{
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{'name': name, 'email': email}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _name = data['user']['name'];
        _email = data['user']['email'];
        notifyListeners();
      } else {
        throw Exception('Failed to update user profile');
      }
    }
  }
}
