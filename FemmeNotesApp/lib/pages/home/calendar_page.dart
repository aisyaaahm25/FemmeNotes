import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:femme_notes_app/pages/models/task_model.dart';
import 'package:femme_notes_app/pages/providers/task_provider.dart';
import 'package:femme_notes_app/pages/widgets/task_card.dart';
import 'package:femme_notes_app/theme.dart';
import 'package:intl/intl.dart'; // Untuk memformat tanggal

class CalendarPage extends StatefulWidget {
  final Function(String)
      onDateSelected; // Callback untuk mengirim tanggal ke MainPage
  final String selectedDate;

  const CalendarPage(
      {super.key, required this.onDateSelected, required this.selectedDate});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  String selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    fetchTasks(widget.selectedDate);
  }

  Future<void> fetchTasks(String date) async {
    await Provider.of<TaskProvider>(context, listen: false)
        .fetchTasks(context, date);
  }

  @override
  void didUpdateWidget(CalendarPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDate != widget.selectedDate) {
      fetchTasks(widget.selectedDate);
    }
  }

  void _editTask(BuildContext context, TaskModel task) {
    final titleController = TextEditingController(text: task.title);
    final noteController = TextEditingController(text: task.note);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: noteController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                TaskModel editedTask = TaskModel(
                  id: task.id,
                  title: titleController.text,
                  note: noteController.text,
                  startTask: task.startTask,
                  endTask: task.endTask,
                  date: task.date,
                );

                await Provider.of<TaskProvider>(context, listen: false)
                    .editTask(context, editedTask);

                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteTask(BuildContext context, TaskModel task) {
    // Konfirmasi penghapusan
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Task'),
          content: const Text('Are you sure you want to delete this task?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Tutup dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await Provider.of<TaskProvider>(context, listen: false)
                    .deleteTask(context, task.id);
                Navigator.pop(context); // Tutup dialog
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    PreferredSizeWidget header() {
      return PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: AppBar(
          backgroundColor: background01,
          automaticallyImplyLeading: false,
          centerTitle: false,
          elevation: 0,
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(top: 80, left: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Today's tasks",
                  style: tertiaryTextStyle.copyWith(
                    fontSize: 24,
                    fontWeight: semibold,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 40),
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage("assets/image-profile.png"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget datePicker() {
      DateTime today = DateTime.now();
      int daysRange = 30;

      List<Widget> dateWidgets = List.generate(30, (index) {
        DateTime date = today.add(Duration(days: daysRange ~/ 2 - index));
        String day = DateFormat('d').format(date);
        String weekday = DateFormat('E').format(date);
        String month = DateFormat('MMM').format(date).toUpperCase();
        String formattedDate = DateFormat('yyyy-MM-dd').format(date);
        bool isSelected = formattedDate == widget.selectedDate;
        return GestureDetector(
          onTap: () {
            widget.onDateSelected(formattedDate);
          },
          child: Container(
            width: 55,
            height: 82,
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: isSelected ? background02 : primaryColor,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  month,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: regular,
                    color: isSelected ? secondaryColor : subtitleColor01,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  day,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: semibold,
                    color: isSelected ? secondaryColor : subtitleColor01,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  weekday,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: regular,
                    color: isSelected ? secondaryColor : subtitleColor01,
                  ),
                ),
              ],
            ),
          ),
        );
      });
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: dateWidgets),
      );
    }

    Widget listTasks() {
      return Consumer<TaskProvider>(builder: (context, taskProvider, _) {
        if (taskProvider.tasks.isEmpty) {
          return Center(
            child: Text(
              'No tasks for the selected date',
              style: subtitleTextStyle.copyWith(
                fontSize: 14,
                fontWeight: medium,
              ),
            ),
          );
        }
        //
        return SingleChildScrollView(
          child: Column(
            children: List.generate(taskProvider.tasks.length, (index) {
              final task = taskProvider.tasks[index];
              return TaskCard(
                task: task,
                index: index,
                onEdit: () {
                  _editTask(context, task);
                },
                onDelete: () {
                  _deleteTask(context, task);
                },
              );
            }),
          ),
        );
      });
    }

    Widget content() {
      return SafeArea(
        child: Container(
          width: 390,
          margin: const EdgeInsets.only(top: 15, left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              datePicker(),
              Expanded(
                child: listTasks(),
              )
            ],
          ),
          // child: SingleChildScrollView(
          // ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: background01,
      resizeToAvoidBottomInset: false,
      appBar: header(),
      body: content(),
    );
  }
}
