import 'package:femme_notes_app/pages/models/task_model.dart';
import 'package:femme_notes_app/pages/providers/task_provider.dart';
import 'package:flutter/material.dart';
import 'package:femme_notes_app/pages/models/folder_model.dart';
import 'package:femme_notes_app/pages/providers/folder_notifier.dart';
import 'package:femme_notes_app/theme.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<TaskModel> getNonExpiredTasks(List<TaskModel> tasks) {
    DateTime today = DateTime.now();
    DateTime tomorrow = today.add(const Duration(days: 1));
    return tasks.where((task) {
      DateTime taskDate = DateTime.parse(task.date);
      return taskDate.isAfter(today.subtract(const Duration(days: 1))) &&
          taskDate.isBefore(tomorrow.add(const Duration(days: 1)));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // Dialog untuk menambahkan folder baru
    void showAddFolderDialog() {
      final TextEditingController folderNameController =
          TextEditingController();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Add Folder"),
            content: TextField(
              controller: folderNameController,
              decoration: const InputDecoration(
                hintText: "Enter folder name",
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Tutup dialog tanpa menyimpan
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  final folderName = folderNameController.text.trim();
                  if (folderName.isNotEmpty) {
                    // Tambahkan folder ke folderNotifier
                    folderNotifier.addFolder(FolderModel(name: folderName));
                    Navigator.pop(context); // Tutup dialog setelah menyimpan
                  }
                },
                child: const Text("Add"),
              ),
            ],
          );
        },
      );
    }

    Widget header() {
      return Container(
        margin: EdgeInsets.only(
          top: 50,
          left: defaultMargin,
          right: defaultMargin,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hello dear,",
                        style: tertiaryTextStyle.copyWith(
                          fontSize: 24,
                          fontWeight: bold,
                        ),
                      ),
                      Text(
                        "Welcome!",
                        style: tertiaryTextStyle.copyWith(
                          fontSize: 24,
                          fontWeight: bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 54,
                  height: 54,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(
                        "assets/image-profile.png",
                      ),
                    ),
                  ),
                )
              ],
            ),
            // Tambahkan Divider di bawah teks
            Container(
              margin:
                  const EdgeInsets.only(top: 8), // Jarak antara teks dan garis
              child: const Divider(
                color: Colors.grey, // Warna garis
                thickness: 1, // Ketebalan garis
              ),
            ),
          ],
        ),
      );
    }

    Widget taskOnGoingTitle() {
      return Container(
        margin: EdgeInsets.only(
          top: 20,
          right: defaultMargin,
          left: defaultMargin,
        ),
        child: Text(
          "Ongoing Tasks",
          style: tertiaryTextStyle.copyWith(
            fontSize: 20,
            fontWeight: semibold,
          ),
        ),
      );
    }

    Widget listOnGoingTask() {
      return Consumer<TaskProvider>(
        builder: (context, taskProvider, _) {
          List<TaskModel> nonExpiredTasks =
              getNonExpiredTasks(taskProvider.tasks);
          if (nonExpiredTasks.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: MediaQuery.of(context).size.height * 0.15),
                child: Column(
                  children: [
                    const SizedBox(height: 70),
                    Icon(
                      Icons.task_alt,
                      size: 40,
                      color: subtitleColor01,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "No ongoing tasks.\nAll caught up!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: subtitleColor01,
                      ),
                    ),
                    const SizedBox(height: 34),
                  ],
                ),
              ),
            );
          }
          // return Container(
          //   margin: const EdgeInsets.only(top: 8, left: 20, right: 20),
          //   child: ListView.builder(
          //     shrinkWrap: true,
          //     itemCount: nonExpiredTasks.length,
          //     itemBuilder: (context, index) {
          //       final task = nonExpiredTasks[index];
          //       return Container(
          //         width: 380,
          //         height: 100,
          //         margin: const EdgeInsets.symmetric(vertical: 4),
          //         padding: const EdgeInsets.all(8),
          //         decoration: BoxDecoration(
          //           color: secondaryColor,
          //           borderRadius: BorderRadius.circular(8),
          //           boxShadow: [
          //             BoxShadow(
          //               color: Colors.grey.withOpacity(0.5),
          //               spreadRadius: 1,
          //               blurRadius: 4,
          //               offset: const Offset(0, 2), // Posisi bayangan
          //             ),
          //           ],
          //         ),
          //         child: ListTile(
          //           title: Text(
          //             task.title,
          //             style: primaryTextStyle.copyWith(
          //               fontSize: 16,
          //               fontWeight: medium,
          //             ),
          //             overflow: TextOverflow.ellipsis,
          //             maxLines: 1,
          //           ),
          //           subtitle: Column(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               const SizedBox(height: 8),
          //               Text(
          //                 'Due: ${task.date}',
          //                 style: primaryTextStyle.copyWith(
          //                   fontSize: 12,
          //                   fontWeight: light,
          //                 ),
          //                 overflow: TextOverflow.ellipsis,
          //               ),
          //               const SizedBox(height: 6),
          //               Text(
          //                 task.note,
          //                 style: primaryTextStyle.copyWith(
          //                   fontSize: 12,
          //                   fontWeight: light,
          //                 ),
          //                 overflow: TextOverflow.ellipsis,
          //               ),
          //             ],
          //           ),
          //           onTap: () {},
          //         ),
          //       );
          //     },
          //   ),
          // );
          return SingleChildScrollView(
            child: Column(
              children: List.generate(nonExpiredTasks.length, (index) {
                final task = nonExpiredTasks[index];
                return Container(
                  width: 380,
                  height: 100,
                  margin:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 2), // Posisi bayangan
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Text(
                      task.title,
                      style: primaryTextStyle.copyWith(
                        fontSize: 16,
                        fontWeight: medium,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          'Due: ${task.date}',
                          style: primaryTextStyle.copyWith(
                            fontSize: 12,
                            fontWeight: light,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          task.note,
                          style: primaryTextStyle.copyWith(
                            fontSize: 12,
                            fontWeight: light,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    onTap: () {},
                  ),
                );
              }),
            ),
          );
        },
      );
    }

    return ListView(
      children: [
        header(),
        taskOnGoingTitle(),
        listOnGoingTask(),
      ],
    );
  }
}
