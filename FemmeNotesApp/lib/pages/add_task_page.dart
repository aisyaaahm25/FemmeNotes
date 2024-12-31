import 'package:femme_notes_app/pages/providers/task_provider.dart';
import 'package:flutter/material.dart';
import 'package:femme_notes_app/pages/models/task_model.dart';
import 'package:femme_notes_app/pages/providers/task_notifier.dart';
import 'package:femme_notes_app/theme.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart'; // Untuk format tanggal

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  // Variabel untuk menyimpan pilihan pengingat
  String selectedRemind = "Choose remind time";
  String selectedRepeat = "None";

  // Controllers untuk input form
  final TextEditingController titleController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dateController.text = DateFormat('yyyy/MM/dd').format(DateTime.now());
    startTimeController.text = DateFormat.jm().format(DateTime.now());
    endTimeController.text =
        DateFormat.jm().format(DateTime.now().add(const Duration(hours: 1)));
  }

  @override
  void dispose() {
    titleController.dispose();
    noteController.dispose();
    dateController.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
    super.dispose();
  }

  void _showAlertDialog(String message, {bool isSuccess = false}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            isSuccess ? 'Success' : 'Error',
            style: TextStyle(
              color: isSuccess ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                if (isSuccess) Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _submitTask() async {
    if (titleController.text.isEmpty ||
        noteController.text.isEmpty ||
        dateController.text.isEmpty ||
        startTimeController.text.isEmpty ||
        endTimeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    TaskModel newTask = TaskModel(
      title: titleController.text,
      note: noteController.text,
      date: dateController.text,
      startTask: startTimeController.text,
      endTask: endTimeController.text,
    );

    try {
      await Provider.of<TaskProvider>(context, listen: false)
          .addTask(context, newTask);
      _showAlertDialog('Task successfully added!', isSuccess: true);
    } catch (err) {
      _showAlertDialog('Failed to add task: $err', isSuccess: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background01,
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          title: const Text("Add Task"),
          centerTitle: true,
          backgroundColor: background01,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleInput(),
              noteInput(),
              dateInput(),
              timeInput(context),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitTask,
                child: const Text("Add Task"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget titleInput() {
    return Container(
      margin: const EdgeInsets.only(
        top: 20,
      ),
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
          const SizedBox(
            height: 5,
          ),
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: subtitleColor01),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: titleController,
                    style: tertiaryTextStyle,
                    decoration: InputDecoration.collapsed(
                      hintText: "Enter title here.",
                      hintStyle: subtitleTextStyle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget noteInput() {
    return Container(
      margin: const EdgeInsets.only(
        top: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Note",
            style: tertiaryTextStyle.copyWith(
              fontSize: 16,
              fontWeight: medium,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: subtitleColor01),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: noteController,
                    style: tertiaryTextStyle,
                    decoration: InputDecoration.collapsed(
                      hintText: "Enter note here.",
                      hintStyle: subtitleTextStyle,
                    ),
                    maxLines:
                        8, // Membuat TextFormField bisa memiliki banyak baris
                    minLines: 1, // Set minimal 2 baris
                    keyboardType: TextInputType.multiline, // Keyboard multiline
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget dateInput() {
    Future<void> selectDate() async {
      DateTime? selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );

      dateController.text = DateFormat('yyyy/MM/dd').format(selectedDate!);
        }

    // Set default date to current date
    void setCurrentDate() {
      DateTime now = DateTime.now();
      dateController.text = DateFormat('yyyy/MM/dd').format(now);
    }

    // Set the default date on widget load
    setCurrentDate();

    return Container(
      margin: const EdgeInsets.only(
        top: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Date",
            style: tertiaryTextStyle.copyWith(
              fontSize: 16,
              fontWeight: medium,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: subtitleColor01),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: dateController,
                    style: tertiaryTextStyle,
                    decoration: InputDecoration.collapsed(
                      hintText: "Select a date.",
                      hintStyle: subtitleTextStyle,
                    ),
                    readOnly: true,
                    onTap: selectDate,
                  ),
                ),
                Image.asset(
                  "assets/icon-calendar-black.png",
                  width: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget timeInput(BuildContext context) {
    // Fungsi untuk memilih waktu
    Future<void> selectTime(
        BuildContext context, TextEditingController controller) async {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        final now = DateTime.now();
        final selectedTime = DateTime(
          now.year,
          now.month,
          now.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        final formattedTime =
            DateFormat.jm().format(selectedTime); // Format AM/PM
        controller.text = formattedTime;
      }
    }

    // Set waktu saat ini untuk startTimeController
    void setCurrentTime() {
      final now = DateTime.now();
      final formattedTime = DateFormat.jm().format(now); // Format AM/PM
      startTimeController.text = formattedTime;
    }

    // Panggil _setCurrentTime saat widget dimuat
    setCurrentTime();

    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Start Time Section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Start Time",
                      style: tertiaryTextStyle.copyWith(
                        fontSize: 16,
                        fontWeight: medium,
                      ),
                    ),
                    const SizedBox(height: 5),
                    GestureDetector(
                      onTap: () => selectTime(context, startTimeController),
                      child: Container(
                        height: 50,
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: subtitleColor01),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: startTimeController,
                                style: tertiaryTextStyle,
                                decoration: InputDecoration.collapsed(
                                  hintText: "Start Time",
                                  hintStyle: subtitleTextStyle,
                                ),
                                readOnly: true, // Tidak bisa mengetik
                                onTap: () => selectTime(context,
                                    startTimeController), // Pemicu untuk memilih waktu
                              ),
                            ),
                            Image.asset(
                              "assets/icon-clock.png",
                              width: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              // End Time Section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "End Time",
                      style: tertiaryTextStyle.copyWith(
                        fontSize: 16,
                        fontWeight: medium,
                      ),
                    ),
                    const SizedBox(height: 5),
                    GestureDetector(
                      onTap: () => selectTime(context, endTimeController),
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: subtitleColor01),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: endTimeController,
                                style: tertiaryTextStyle,
                                decoration: InputDecoration.collapsed(
                                  hintText: "End Time",
                                  hintStyle: subtitleTextStyle,
                                ),
                                readOnly: true, // Tidak bisa mengetik
                                onTap: () => selectTime(context,
                                    endTimeController), // Pemicu untuk memilih waktu
                              ),
                            ),
                            Image.asset(
                              "assets/icon-clock.png",
                              width: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget createTaskButton() {
    return Container(
      height: 50,
      width: double.infinity,
      margin: EdgeInsets.only(top: defaultMargin),
      child: TextButton(
        onPressed: () => _submitTask(),
        style: TextButton.styleFrom(
          backgroundColor: buttonColor01,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          "Create Task",
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
        margin: EdgeInsets.symmetric(
          horizontal: defaultMargin,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add Task",
                style: tertiaryTextStyle.copyWith(
                  fontSize: 22,
                  fontWeight: semibold,
                ),
              ),
              titleInput(),
              noteInput(),
              dateInput(),
              timeInput(context),
              createTaskButton(),
            ],
          ),
        ),
      ),
    );
  }
}
