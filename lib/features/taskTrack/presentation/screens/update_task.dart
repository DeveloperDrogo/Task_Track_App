import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:task_track_app/analytics_service.dart';
import 'package:task_track_app/core/common/widget/loader.dart';
import 'package:task_track_app/core/constant/constant.dart';
import 'package:task_track_app/core/utils/show_dialog.dart';
import 'package:task_track_app/core/utils/show_loading_dialog.dart';
import 'package:task_track_app/core/utils/show_snackbar.dart';
import 'package:task_track_app/features/taskTrack/domain/entities/label_data.dart';
import 'package:task_track_app/features/taskTrack/presentation/bloc/task_bloc.dart';
import 'package:task_track_app/features/taskTrack/presentation/screens/task.dart';
import 'package:task_track_app/features/taskTrack/presentation/widgets/date_picker.dart';
import 'package:task_track_app/features/taskTrack/presentation/widgets/submit_button.dart';
import 'package:task_track_app/features/taskTrack/presentation/widgets/task_dropDown.dart';
import 'package:task_track_app/features/taskTrack/presentation/widgets/text_form_field.dart';

class UpdateTask extends StatefulWidget {
  final String taskId;

  static route({
    required String taskId,
  }) =>
      MaterialPageRoute(
        builder: (context) => UpdateTask(
          taskId: taskId,
        ),
      );
  const UpdateTask({
    super.key,
    required this.taskId,
  });

  @override
  State<UpdateTask> createState() => _UpdateTaskState();
}

class _UpdateTaskState extends State<UpdateTask> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _desc = TextEditingController();
  String? priority;
  String? priorityName;
  String? initialdueDate;
  String? dueDate;
  List labelValue = [];
  String? scheduleDate;
  bool isLoadingDialogVisible = false;
  Time? scheduleTime;
  final DateFormat format = DateFormat("hh:mm a"); // Use AM/PM format

  final controller = MultiSelectController<LabelsData>();

  @override
  void initState() {
    context
        .read<TaskBloc>()
        .add(GetSelectedTaskInfoEvent(taskId: widget.taskId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SubmitButton(
            onpressed: () {
              if (_formKey.currentState!.validate()) {
                context.read<TaskBloc>().add(
                      UpdateTaskEvent(
                          taskName: _title.text,
                          des: _desc.text,
                          dueDate: dueDate != null ? dueDate! : initialdueDate!,
                          priority: priority!,
                          taskId: widget.taskId),
                    );
              }
            },
            buttonText: "Update Task"),
      ),
      appBar: AppBar(
        title: Text(
          'Update Task ',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.push(context, TaskTrackPage.route());
          },
          icon: const Icon(Icons.close),
        ),
      ),
      body: BlocConsumer<TaskBloc, TaskState>(
        listenWhen: (previous, current) => current is TaskActionState,
        buildWhen: (previous, current) => current is! TaskActionState,
        listener: (context, state) {
          // if (!isLoadingDialogVisible) {
          //   isLoadingDialogVisible = true;
          //   LoadingDialog.show(context);
          // }
          if (state is TaskErrorState) {
            showSnackBar(context, state.errorMessage);
          } else if (state is TaskActionLoadeState) {
            LoadingDialog.show(context);
          } else if (state is TaskSuccessActionState) {
            LoadingDialog.dismiss(context);
            AnalyticsService().editTask().then((value) => debugPrint('edit event added to firebase'),);
            showAwesomeDialog(
              context: context,
              type: Constant.success,
              title: 'Success',
              desc: 'You have successfully updated the Task.',
              successButtonText: 'Okay',
              failedButtonText: 'Close',
              okButtonPress: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  UpdateTask.route(taskId: widget.taskId),
                  (route) => false,
                );
              },
              cancelButtonPress: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  UpdateTask.route(taskId: widget.taskId),
                  (route) => false,
                );
              },
            );
          } else if (state is TaskFailedActionState) {
            LoadingDialog.dismiss(context);
            showAwesomeDialog(
              context: context,
              type: Constant.failure,
              title: 'Failure',
              desc: 'Updating task failed. Please try again.',
              successButtonText: 'Okay',
              failedButtonText: 'Close',
              okButtonPress: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  UpdateTask.route(taskId: widget.taskId),
                  (route) => false,
                );
              },
              cancelButtonPress: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  UpdateTask.route(taskId: widget.taskId),
                  (route) => false,
                );
              },
            );
          }
        },
        builder: (context, state) {
          if (state is TaskLoadState) {
            return const Loader();
          }
          if (state is GetTaskInfoState) {
            _title.text = state.taskModel.taskName;
            _desc.text = state.taskModel.des;
            initialdueDate = state.taskModel.dueDate;
            priority = state.taskModel.priority;

            if (priority == '4') {
              priorityName = 'Urgent';
            } else if (priority == '3') {
              priorityName = 'Important';
            } else if (priority == '2') {
              priorityName = 'Medium';
            } else if (priority == '1') {
              priorityName = 'Low';
            }

            

            return WillPopScope(
              onWillPop: () async {
                Navigator.push(context, TaskTrackPage.route());
                return false;
              },
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TaskTextFormField(
                          validateRequired: true,
                          label: 'Task Name',
                          hintText: 'Enter Task Name',
                          controller: _title,
                          minLines: 1,
                          maxLines: 2,
                          icon: const Icon(Icons.title),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TaskTextFormField(
                          validateRequired: false,
                          label: 'Description',
                          hintText: 'Enter Description',
                          controller: _desc,
                          minLines: 4,
                          maxLines: 8,
                          icon: const Icon(IconlyBroken.document),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TaskDatePicker(
                          initialDate: DateTime.parse(state.taskModel.dueDate),
                          validatorRequired: true,
                          label: 'Due Date',
                          hintText: 'Enter Due Date',
                          onDateSelected: (date) {
                            setState(() {
                              FocusScope.of(context).requestFocus(FocusNode());
                              dueDate = DateFormat('yyyy-MM-dd').format(date);
                            });
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TaskDropDownField(
                            selectedValue: priorityName,
                            icon: const Icon(Icons.flag_outlined),
                            onChanged: (value) {
                              priorityName = value;
                              if (value == 'Urgent') {
                                priority = '4';
                              } else if (value == 'Important') {
                                priority = '3';
                              } else if (value == 'Medium') {
                                priority = '2';
                              } else if (value == 'Low') {
                                priority = '1';
                              }
                            },
                            label: 'Priority',
                            dropdownValues: const [
                              'Urgent',
                              'Important',
                              'Medium',
                              'Low'
                            ]),
                        const SizedBox(
                          height: 16,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
