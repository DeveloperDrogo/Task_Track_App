import 'package:adaptive_theme/adaptive_theme.dart';

import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:readmore/readmore.dart';
import 'package:task_track_app/core/common/widget/rich_text.dart';
import 'package:task_track_app/core/constant/constant.dart';
import 'package:task_track_app/core/theme/app_pallet.dart';
import 'package:task_track_app/core/utils/date_format.dart';
import 'package:task_track_app/core/utils/show_dialog.dart';
import 'package:task_track_app/features/taskTrack/domain/entities/task_data.dart';

class MyTaskList extends StatelessWidget {
  final Function(String) onCancellPress;
  final Function(String, String) onMoveTaskPress;
  final TaskData taskData;
  const MyTaskList(
      {super.key,
      required this.taskData,
      required this.onCancellPress,
      required this.onMoveTaskPress});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 0, right: 0, top: 5, bottom: 5),
      decoration: BoxDecoration(
        border: Border.all(width: 0.5, color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).cardTheme.color,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            Positioned(
                right: -30,
                top: -50,
                child: Container(
                    height: 120,
                    width: 100,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AdaptiveTheme.of(context).mode.isDark
                            ? AppPallete.darkBackgroundColor
                            : AppPallete.lightCircleAvatarColor))),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    top: 10,
                  ),
                  child: RichTextField(
                    keyText: 'Name : ',
                    valueText: taskData.taskName,
                  ),
                ),
                taskData.des != ''
                    ? Padding(
                        padding:
                            const EdgeInsets.only(left: 10, top: 10, right: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Description : ',
                              style: TextStyle(
                                  color: AdaptiveTheme.of(context).mode.isDark
                                      ? const Color.fromARGB(255, 178, 178, 178)
                                      : const Color.fromARGB(
                                          255, 140, 140, 140)),
                            ),
                            Expanded(
                              child: ReadMoreText(taskData.des,
                                  trimMode: TrimMode.Line,
                                  trimLines: 1,
                                  colorClickableText: Colors.pink,
                                  trimCollapsedText: 'Show more',
                                  trimExpandedText: ' Show less',
                                  moreStyle: TextStyle(
                                      fontSize: 14,
                                      color: AdaptiveTheme.of(context)
                                              .mode
                                              .isDark
                                          ? const Color.fromARGB(
                                              255, 177, 166, 245)
                                          : AppPallete.primaryColor,
                                      fontWeight: FontWeight.bold),
                                  lessStyle: TextStyle(
                                      fontSize: 14,
                                      color:
                                          AdaptiveTheme.of(context).mode.isDark
                                              ? const Color.fromARGB(
                                                  255, 254, 152, 145)
                                              : Colors.red,
                                      fontWeight: FontWeight.bold),
                                  style: TextStyle(
                                      height: 1.5,
                                      color:
                                          AdaptiveTheme.of(context).mode.isDark
                                              ? Colors.white
                                              : Colors.black,
                                      fontFamily: "Lato",
                                      fontWeight: FontWeight.w600)),
                            ),
                          ],
                        ),
                      )
                    : Container(),
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 7, bottom: 13),
                  child: Row(
                    children: [
                      RichTextField(
                        keyText: 'Due : ',
                        valueText: formatDateDMMMYYYY(
                          DateTime.parse(taskData.dueDate),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 7, bottom: 13),
                  child: Wrap(
                    spacing: 8.0, // Space between labels
                    children: taskData.labels.map((label) {
                      return Row(
                        mainAxisSize:
                            MainAxisSize.min, // Adjust to content size
                        children: [
                          const Icon(
                            Icons.label_important_outline,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            label,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 0, bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTapDown: (TapDownDetails details) async {
                          // Get the position where the user tapped
                          final tapPosition = details.globalPosition;

                          final selectedOption = await showMenu<String>(
                            context: context,
                            position: RelativeRect.fromLTRB(
                              tapPosition.dx, // x-coordinate
                              tapPosition.dy, // y-coordinate
                              MediaQuery.of(context).size.width -
                                  tapPosition.dx, // Remaining width
                              MediaQuery.of(context).size.height -
                                  tapPosition.dy, // Remaining height
                            ),
                            items: [
                              if (taskData.projectId != '2344765751')
                                PopupMenuItem<String>(
                                  value: '2344765751',
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween, // Align items evenly
                                    children: [
                                      const Text('Not started'),
                                      Icon(
                                        Icons.circle_outlined,
                                        color: AdaptiveTheme.of(context)
                                                .mode
                                                .isDark
                                            ? AppPallete.greyColor
                                            : AppPallete.borderColor,
                                      ),
                                    ],
                                  ),
                                ),
                              if (taskData.projectId != '2344851608')
                                PopupMenuItem<String>(
                                  value: '2344851608',
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween, // Align items evenly
                                    children: [
                                      const Text('In progress'),
                                      Icon(
                                        Icons.timelapse_outlined,
                                        color: AdaptiveTheme.of(context)
                                                .mode
                                                .isDark
                                            ? AppPallete.greyColor
                                            : AppPallete.borderColor,
                                      ),
                                    ],
                                  ),
                                ),
                              if (taskData.projectId != '2344765762')
                                PopupMenuItem<String>(
                                  value: '2344765762',
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween, // Align items evenly
                                    children: [
                                      const Text('Completed'),
                                      Icon(
                                        Icons.check_circle,
                                        color: AdaptiveTheme.of(context)
                                                .mode
                                                .isDark
                                            ? AppPallete.greyColor
                                            : AppPallete.borderColor,
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          );

                          if (selectedOption != null) {
                            // Handle the selected option
                            onMoveTaskPress(taskData.taskID, selectedOption);
                            // Perform any updates or actions based on the selected value
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: taskData.projectId == '2344765751'
                                ? const Color.fromARGB(255, 192, 99, 93)
                                : taskData.projectId == '2344851608'
                                    ? const Color.fromARGB(255, 213, 127, 61)
                                    : const Color.fromARGB(255, 74, 147, 76),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 4, bottom: 4, left: 12, right: 4),
                            child: Row(
                              children: [
                                Text(
                                  '# ${taskData.projectId == '2344765751' ? 'NOT STARTED' : taskData.projectId == '2344851608' ? 'IN PROGRESS' : 'COMPLETED'}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineLarge
                                      ?.copyWith(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                                const Icon(
                                  Icons.arrow_right_sharp,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          IconlyBroken.edit,
                        ),
                      ),
                      const SizedBox(
                        width: 0,
                      ),
                      IconButton(
                        onPressed: () {
                          showAwesomeDialog(
                            context: context,
                            type: Constant.question,
                            title: 'Are you sure?',
                            desc: 'Do you really want to delete this task?',
                            successButtonText: 'Okay',
                            failedButtonText: 'Close',
                            okButtonPress: () {
                              onCancellPress(taskData.taskID);
                              Navigator.pop(context);
                            },
                            cancelButtonPress: () {
                              Navigator.pop(context);
                            },
                          );
                        },
                        icon: const Icon(
                          IconlyBroken.delete,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
                right: 10,
                top: 8,
                child: CircleAvatar(
                  radius: 17,
                  backgroundColor: AdaptiveTheme.of(context).mode.isDark
                      ? AppPallete.borderColor
                      : AppPallete.primaryColor,
                  child: Icon(
                    taskData.projectId == '2344765751'
                        ? Icons.circle_outlined
                        : taskData.projectId == '2344851608'
                            ? Icons.timelapse_rounded
                            : Icons.check_circle,
                    color: Colors.white,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
