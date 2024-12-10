import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:task_track_app/core/common/widget/loader.dart';
import 'package:task_track_app/core/theme/app_pallet.dart';
import 'package:task_track_app/core/utils/show_snackbar.dart';
import 'package:task_track_app/features/taskTrack/presentation/bloc/task_bloc.dart';
import 'package:task_track_app/features/taskTrack/presentation/screens/add_task.dart';
import 'package:task_track_app/features/taskTrack/presentation/screens/update_task.dart';
import 'package:task_track_app/features/taskTrack/presentation/utils/notification_manager.dart';
import 'package:task_track_app/features/taskTrack/presentation/utils/time_calculation.dart';
import 'package:task_track_app/features/taskTrack/presentation/widgets/app_bar_title.dart';
import 'package:task_track_app/features/taskTrack/presentation/widgets/date_time_line.dart';
import 'package:task_track_app/features/taskTrack/presentation/widgets/empty_task.dart';
import 'package:task_track_app/features/taskTrack/presentation/widgets/my_task_list.dart';
import 'package:task_track_app/features/taskTrack/presentation/widgets/task_search_filter.dart';

class TaskTrackPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const TaskTrackPage(),
      );
  const TaskTrackPage({super.key});

  @override
  State<TaskTrackPage> createState() => _TaskTrackPageState();
}

class _TaskTrackPageState extends State<TaskTrackPage> {
  String filterDate = '';
  int? selectedPriority; // Tracks the selected priority (4 for Urgent, etc.)
  String? selectedProject; // Tracks the selected project status

  @override
  void initState() {
    filterDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    context.read<TaskBloc>().add(GetAllTaskEvent());
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
              radius: 16,
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
            width: 16,
          ),
        ],
      ),
      body: BlocConsumer<TaskBloc, TaskState>(
        listenWhen: (previous, current) => current is TaskActionState,
        buildWhen: (previous, current) => current is! TaskActionState,
        listener: (context, state) {
          if (state is TaskErrorState) {
            showSnackBar(context, state.errorMessage);
          } else if (state is MoveTaskSuccessState) {
            ProgressTimeCalculation.storeProgressDateTime(
              projectId: state.projectId,
              taskId: state.taskId,
            );

            NotificationManager.moveNotification(
              taskName: state.taskName,
              projectId: state.projectId,
            );
            Navigator.pushAndRemoveUntil(
              context,
              TaskTrackPage.route(),
              (route) => false,
            );
          } else if (state is DeleteTaskSuccessState) {
            Navigator.pushAndRemoveUntil(
              context,
              TaskTrackPage.route(),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is TaskLoadState) {
            return const Loader();
          } else if (state is GetAllTaskState) {
            return Padding(
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
                              onPressed: () {
                                showMainMenu(context);
                              },
                              icon: const Icon(
                                IconlyBroken.filter,
                                size: 25,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  //date selection using DateTimelinePicker
                  TaskDateTimeLine(onDateChange: (date) {
                    setState(() {
                      filterDate = DateFormat('yyyy-MM-dd').format(date);
                    });
                  }),

                  const SizedBox(
                    height: 16,
                  ),

                  state.taskData
                          .where((task) =>
                              (_searchController.text.isEmpty ||
                                  task.taskName.toLowerCase().contains(
                                        _searchController.text.toLowerCase(),
                                      )) &&
                              (filterDate.isEmpty ||
                                  task.dueDate.contains(filterDate)) &&
                              (selectedProject == null ||
                                  task.projectId ==
                                      selectedProject.toString()) &&
                              (selectedPriority == null ||
                                  task.priority == selectedPriority.toString()))
                          .isEmpty
                      ? const EmptyTask()
                      : Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.only(bottom: 70),
                            itemCount: state.taskData.length,
                            itemBuilder: (context, index) {
                              final task = state.taskData[index];
                              // Apply the same filter logic as above
                              if ((_searchController.text.isNotEmpty &&
                                      !task.taskName.toLowerCase().contains(
                                          _searchController.text
                                              .toLowerCase())) ||
                                  (filterDate.isNotEmpty &&
                                      !task.dueDate.contains(filterDate)) ||
                                  (selectedProject != null &&
                                      task.projectId !=
                                          selectedProject.toString()) ||
                                  (selectedPriority != null &&
                                      task.priority !=
                                          selectedPriority.toString())) {
                                return const SizedBox
                                    .shrink(); // Hide if not matching
                              }
                              return MyTaskList(
                                taskData: task,
                                onCancellPress: (taskId) {
                                  context
                                      .read<TaskBloc>()
                                      .add(DeleteTaskEvent(taskId: taskId));
                                },
                                onMoveTaskPress: (taskId, projectId, taskName) {
                                  context.read<TaskBloc>().add(
                                        MoveTaskEvent(
                                          taskId: taskId,
                                          projectId: projectId,
                                          taskName: taskName,
                                        ),
                                      );
                                },
                                onEditPress: (taskId) {
                                  Navigator.push(context,
                                      UpdateTask.route(taskId: taskId));
                                },
                              );
                            },
                          ),
                        ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  void showMainMenu(BuildContext context) {
    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(100, 50, 0, 0),
      items: [
        PopupMenuItem(
          value: 'priority',
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Priority'),
              if (selectedPriority != null)
                const Icon(
                  Icons.filter_alt_outlined,
                ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'project',
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Project'),
              if (selectedProject != null)
                const Icon(
                  Icons.filter_alt_outlined,
                ),
            ],
          ),
        ),
      ],
    ).then((value) {
      if (value == 'priority') {
        showPriorityMenu(context);
      } else if (value == 'project') {
        showProjectMenu(context);
      }
    });
  }

  void showPriorityMenu(BuildContext context) {
    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(100, 100, 0, 0),
      items: [
        PopupMenuItem(
          value: 4,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Urgent'),
              if (selectedPriority == 4)
                const Icon(
                  Icons.check,
                ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Important'),
              if (selectedPriority == 3)
                const Icon(
                  Icons.check,
                ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Medium'),
              if (selectedPriority == 2)
                const Icon(
                  Icons.check,
                ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Low'),
              if (selectedPriority == 1)
                const Icon(
                  Icons.check,
                ),
            ],
          ),
        ),
        PopupMenuItem(
          value: null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('All'),
              if (selectedPriority == null)
                const Icon(
                  Icons.check,
                ),
            ],
          ),
        ),
      ],
    ).then((value) {
      //if (value != null) {
      setState(() {
        selectedPriority = value;
      });
      // print('Priority selected: $value');
      //}
    });
  }

  void showProjectMenu(BuildContext context) {
    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(100, 100, 0, 0),
      items: [
        PopupMenuItem(
          value: '2344765751',
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Not Started'),
              if (selectedProject == '2344765751')
                const Icon(
                  Icons.check,
                ),
            ],
          ),
        ),
        PopupMenuItem(
          value: '2344851608',
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('In Progress'),
              if (selectedProject == '2344851608')
                const Icon(
                  Icons.check,
                ),
            ],
          ),
        ),
        PopupMenuItem(
          value: '2344765762',
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Completed'),
              if (selectedProject == '2344765762')
                const Icon(
                  Icons.check,
                ),
            ],
          ),
        ),
        PopupMenuItem(
          value: null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('All'),
              if (selectedProject == null)
                const Icon(
                  Icons.check,
                ),
            ],
          ),
        ),
      ],
    ).then((value) {
      // if (value != null) {
      setState(() {
        selectedProject = value;
      });
      //  print('Project status selected: $value');
      //}
    });
  }
}
