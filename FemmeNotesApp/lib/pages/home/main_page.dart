import 'package:flutter/material.dart';
import 'package:femme_notes_app/pages/add_task_page.dart';
import 'package:femme_notes_app/pages/home/home_page.dart';
import 'package:femme_notes_app/pages/home/notes_page.dart';
import 'package:femme_notes_app/pages/home/calendar_page.dart';
import 'package:femme_notes_app/pages/home/profile_page.dart';
import 'package:femme_notes_app/pages/models/task_model.dart';
import 'package:femme_notes_app/pages/providers/task_notifier.dart';
import 'package:femme_notes_app/theme.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;

  // Tambahkan variabel untuk menyimpan selectedDate
  String selectedDate = DateTime.now().toIso8601String();

  // Fungsi untuk memperbarui selectedDate
  void updateSelectedDate(String date) {
    setState(() {
      selectedDate = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget addButton() {
      return FloatingActionButton(
        heroTag: 'main_add_button',
        onPressed: () async {
          final newTask = await Navigator.push<TaskModel>(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTaskPage(),
            ),
          );

          if (newTask != null) {
            taskNotifier.addTask(newTask);
          }
        },
        backgroundColor: background02,
        shape: const CircleBorder(),
        child: Image.asset(
          "assets/icon-add.png",
          width: 25,
          color: secondaryColor,
        ),
      );
    }

    Widget customButtonNav() {
      return ClipRRect(
        child: BottomAppBar(
          padding: const EdgeInsets.all(0),
          shape: const CircularNotchedRectangle(),
          notchMargin: 13,
          clipBehavior: Clip.antiAlias,
          child: BottomNavigationBar(
            backgroundColor: background02,
            currentIndex: currentIndex,
            onTap: (value) {
              setState(() {
                print(value);
                currentIndex = value;
              });
            },
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            items: [
              // Home
              BottomNavigationBarItem(
                icon: Container(
                  margin: const EdgeInsets.only(
                    top: 10,
                  ),
                  child: Image.asset(
                    "assets/icon-home.png",
                    width: 24,
                    color: currentIndex == 0 ? secondaryColor : primaryColor,
                  ),
                ),
                label: '',
              ),
              // Notes
              BottomNavigationBarItem(
                icon: Container(
                  margin: const EdgeInsets.only(
                    top: 10,
                    right: 40,
                  ),
                  child: Image.asset(
                    "assets/icon-notes1.png",
                    width: 33,
                    color: currentIndex == 1 ? secondaryColor : primaryColor,
                  ),
                ),
                label: '',
              ),
              // Calendar
              BottomNavigationBarItem(
                icon: Container(
                  margin: const EdgeInsets.only(
                    top: 10,
                    left: 40,
                  ),
                  child: Image.asset(
                    "assets/icon-calendar.png",
                    width: 31,
                    color: currentIndex == 2 ? secondaryColor : primaryColor,
                  ),
                ),
                label: '',
              ),
              // Profile
              BottomNavigationBarItem(
                icon: Container(
                  margin: const EdgeInsets.only(
                    top: 10,
                  ),
                  child: Image.asset(
                    "assets/icon-profile.png",
                    width: 21,
                    color: currentIndex == 3 ? secondaryColor : primaryColor,
                  ),
                ),
                label: '',
              ),
            ],
          ),
        ),
      );
    }

    Widget body() {
      switch (currentIndex) {
        case 0:
          return const HomePage();
        case 1:
          return const NotesPage();
        case 2:
          return CalendarPage(
            // Kirim fungsi updateSelectedDate ke CalendarPage
            selectedDate: selectedDate,
            onDateSelected: updateSelectedDate,
          );
        case 3:
          return const ProfilePage();

        default:
          return const SizedBox.shrink();
      }
    }

    return Scaffold(
      backgroundColor: background01,
      floatingActionButton: addButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: customButtonNav(),
      body: body(),
    );
  }
}
