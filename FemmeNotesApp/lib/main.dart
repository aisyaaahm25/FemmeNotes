import 'package:femme_notes_app/pages/home/notes_page.dart';
import 'package:femme_notes_app/pages/providers/note_provider.dart';
import 'package:femme_notes_app/pages/providers/task_provider.dart';
import 'package:flutter/material.dart';
import 'package:femme_notes_app/pages/add_note_page.dart';
import 'package:femme_notes_app/pages/add_task_page.dart';
import 'package:femme_notes_app/pages/edit_profile_page.dart';
import 'package:femme_notes_app/pages/providers/auth_provider.dart';
import 'package:femme_notes_app/pages/sign_in_page.dart';
import 'package:femme_notes_app/pages/sign_up_page.dart';
import 'package:femme_notes_app/pages/splash_page.dart';
import 'package:femme_notes_app/pages/home/main_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..loadToken()),
        ChangeNotifierProvider(create: (_) => NoteProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider())
      ],
      // create: (_) => AuthProvider()..loadToken(),
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: '/',
            routes: {
              '/': (context) => const SplashPage(),
              '/home': (context) => const MainPage(),
              '/sign-in': (context) => const SignInPage(),
              '/sign-up': (context) => const SignUpPage(),
              '/add-task': (context) => const AddTaskPage(),
              '/add-note': (context) => const AddNotePage(),
              '/edit-profile': (context) => const EditProfilePage(),
              '/notes': (context) => const NotesPage()
            },
          );
        },
      ),
    );
  }
}
