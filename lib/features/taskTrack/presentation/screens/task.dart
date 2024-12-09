import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_track_app/core/theme/app_pallet.dart';
import 'package:task_track_app/features/taskTrack/presentation/screens/add_task.dart';
import 'package:task_track_app/features/taskTrack/presentation/widgets/app_bar_title.dart';
import 'package:task_track_app/features/taskTrack/presentation/widgets/badge.dart';
import 'package:task_track_app/features/taskTrack/presentation/widgets/date_time_line.dart';
import 'package:task_track_app/features/taskTrack/presentation/widgets/task_search_filter.dart';
import 'package:task_track_app/notification_service.dart';

class TaskTrackPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const TaskTrackPage(),
      );
  const TaskTrackPage({super.key});

  @override
  State<TaskTrackPage> createState() => _TaskTrackPageState();
}

class _TaskTrackPageState extends State<TaskTrackPage> {

  Future<void> scheduleNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> tasks = prefs.getStringList('tasks') ?? [];

    print(tasks);

    for (int i = 0; i < tasks.length; i++) {
      // Split the stored string to get task details
      List<String> taskDetails = tasks[i].split('|');
      String taskName = taskDetails[0];
      String scheduleDateTimeStr = taskDetails[1];

      // Parse the string to DateTime
      DateTime scheduleDateTime =
          DateFormat("yyyy-MM-dd HH:mm").parse(scheduleDateTimeStr);

      // Get the current time
      DateTime currentTime = DateTime.now();

      // Calculate the difference in seconds
      Duration difference = scheduleDateTime.difference(currentTime);
    print(difference);

      // If the target time is in the past, handle this scenario
      if (difference.isNegative) {

        // Remove this task from SharedPreferences
        tasks.removeAt(i);

        // Store the updated list back in SharedPreferences
        await prefs.setStringList('tasks', tasks);

        // Adjust the index to avoid skipping a task due to list modification
        i--;

        continue; // Skip scheduling this notification
      }

      // Calculate the interval
      int interval = difference.inSeconds;
      if (interval < 5) {
        interval = 5;
      }

      // Schedule the notification
      await NotificationService.showNotification(
        title: "Task Reminder",
        body:
            "Your task $taskName is scheduled at $scheduleDateTimeStr as a reminder.",
        scheduled: true,
        interval: interval,
      );
    }
  }

  @override
  void initState() {
    scheduleNotifications();
    super.initState();
  }

  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SizedBox(
        width: 65,
        height: 65,
        child: FloatingActionButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          backgroundColor: AdaptiveTheme.of(context).mode.isDark
              ? AppPallete.primaryDarkColor
              : AppPallete.primaryColor,
          onPressed: () {
            Navigator.push(context, AddTaskPage.route());
          },
          tooltip: 'Add Task',
          child: const Icon(
            Icons.post_add_rounded,
            color: Colors.white,
            size: 35,
          ),
        ),
      ),
      appBar: AppBar(
        shadowColor: AppPallete.transparentColor,
        leading: Transform.translate(
          offset: const Offset(-20, 0),
          child: const Icon(Icons.android, color: AppPallete.transparentColor),
        ),
        titleSpacing: -40,
        centerTitle: false,
        title: const AppBarTitle(),
        actions: [
          //light and dark mode theme set
          PopupMenuButton<int>(
            icon: CircleAvatar(
              radius: 14,
              backgroundColor: AppPallete.transparentColor,
              child: AdaptiveTheme.of(context).mode.isDark
                  ? Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Image.asset('assets/images/brightness.png'),
                    )
                  : Image.asset('assets/images/moon.png'),
            ),
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<int>(
                value: 1,
                child: Row(
                  children: [
                    Text(
                      AdaptiveTheme.of(context).mode.isDark
                          ? 'Enable light mode'
                          : 'Enable dark mode',
                      style:
                          Theme.of(context).textTheme.headlineLarge?.copyWith(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                    ),
                    const Spacer(),
                    Switch(
                      value: AdaptiveTheme.of(context).mode.isDark,
                      onChanged: (value) {
                        if (value) {
                          AdaptiveTheme.of(context).setDark();
                        } else {
                          AdaptiveTheme.of(context).setLight();
                        }
                        Navigator.pop(context); // Close the popup
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            width: 2,
          ),
          CustomBadge(
            badgeCount: 0,
            onTap: () {},
          ),
          const SizedBox(
            width: 12,
          ),
          GestureDetector(
            onTap: () {},
            child: const Icon(
              Icons.menu_sharp,
              size: 27,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0).copyWith(top: 10),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 6,
                  child: TaskSearchFilter(
                    searchController: _searchController,
                    onclear: () {
                      setState(() {
                        _searchController.clear();
                      });
                    },
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.5, color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                      // color: Theme.of(context).cardTheme.color,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 0, bottom: 0),
                      child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            IconlyBroken.filter,
                            size: 25,
                          )),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 6,
            ),
            //date selection using DateTimelinePicker
            TaskDateTimeLine(onDateChange: (date) {}),

            const SizedBox(
              height: 16,
            ),

            // Row(
            //   children: [
            //     SingleChildScrollView(
            //       scrollDirection: Axis.horizontal,
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.start,
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: ['To do', 'On progress', 'Completed']
            //             .map(
            //               (e) => Padding(
            //                 padding: const EdgeInsets.only(
            //                     top: 0, bottom: 0, right: 10),
            //                 child: GestureDetector(
            //                   onTap: () {
            //                     setState(() {
            //                       // Set the selected topic
            //                       selectedTopic = selectedTopic == e ? null : e;
            //                     });
            //                   },
            //                   child: Chip(
            //                     label: Text(e,style: TextStyle(color: selectedTopic == e?Colors.white:null),),
            //                     backgroundColor: selectedTopic == e
            //                         ? AdaptiveTheme.of(context).mode.isDark?AppPallete.primaryDarkColor:AppPallete.primaryColor
            //                         : null,
            //                     side: selectedTopic == e
            //                         ? null
            //                         : const BorderSide(
            //                             width: 0.2,
            //                             color: Color.fromARGB(255, 239, 239, 239)),
            //                   ),
            //                 ),
            //               ),
            //             )
            //             .toList(),
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
