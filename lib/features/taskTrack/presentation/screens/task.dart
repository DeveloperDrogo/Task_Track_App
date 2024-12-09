import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:task_track_app/core/common/widget/loader.dart';
import 'package:task_track_app/core/theme/app_pallet.dart';
import 'package:task_track_app/core/utils/show_snackbar.dart';
import 'package:task_track_app/features/taskTrack/presentation/bloc/task_bloc.dart';
import 'package:task_track_app/features/taskTrack/presentation/screens/add_task.dart';
import 'package:task_track_app/features/taskTrack/presentation/widgets/app_bar_title.dart';
import 'package:task_track_app/features/taskTrack/presentation/widgets/badge.dart';
import 'package:task_track_app/features/taskTrack/presentation/widgets/date_time_line.dart';
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
  @override
  void initState() {
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
      body: BlocConsumer<TaskBloc, TaskState>(
        listenWhen: (previous, current) => current is TaskActionState,
        buildWhen: (previous, current) => current is! TaskActionState,
        listener: (context, state) {
          if (state is TaskErrorState) {
            showSnackBar(context, state.errorMessage);
          }else if (state is MoveTaskSuccessState) {
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

                  Expanded(
                    child: ListView.builder(
                      itemCount: state.taskData.length,
                      itemBuilder: (context, index) {
                        return MyTaskList(
                          taskData: state.taskData[index],
                          onCancellPress: (p0) {},
                          onMoveTaskPress: (taskId, projectId) {
                            context.read<TaskBloc>().add(MoveTaskEvent(
                                taskId: taskId, projectId: projectId));
                          },
                        );
                      },
                    ),
                  )
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
