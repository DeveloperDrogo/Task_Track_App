import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:task_track_app/core/common/widget/loader.dart';
import 'package:task_track_app/core/theme/app_pallet.dart';
import 'package:task_track_app/core/utils/show_snackbar.dart';
import 'package:task_track_app/features/taskTrack/domain/entities/label_data.dart';
import 'package:task_track_app/features/taskTrack/presentation/bloc/task_bloc.dart';
import 'package:task_track_app/features/taskTrack/presentation/screens/task.dart';
import 'package:task_track_app/features/taskTrack/presentation/widgets/date_picker.dart';
import 'package:task_track_app/features/taskTrack/presentation/widgets/multi_drop_down_field.dart';
import 'package:task_track_app/features/taskTrack/presentation/widgets/submit_button.dart';
import 'package:task_track_app/features/taskTrack/presentation/widgets/task-dropDown.dart';
import 'package:task_track_app/features/taskTrack/presentation/widgets/task_time_filed.dart';
import 'package:task_track_app/features/taskTrack/presentation/widgets/text_form_field.dart';

class AddTaskPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const AddTaskPage(),
      );
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _desc = TextEditingController();
  String? priority;
  String? label;
  final DateFormat format = DateFormat("hh:mm a"); // Use AM/PM format
  Time? _remainderTime;

  void _onInTimeChanged(Time newTime) {
    setState(() {
      _remainderTime = newTime; // Update the selected time
    });
  }

  final controller = MultiSelectController<LabelsData>();

  @override
  void initState() {
    context.read<TaskBloc>().add(GetAllAddTaskEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:  Padding(
        padding: const EdgeInsets.all(16.0),
        child: SubmitButton(onpressed: () {
          if(_formKey.currentState!.validate()){

          }
        }, buttonText: "Add Task"),
      ),
      appBar: AppBar(
        title: Text(
          'Add Task ',
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
          if (state is TaskErrorState) {
            showSnackBar(context, state.errorMessage);
          }
        },
        builder: (context, state) {
          if (state is TaskLoadState) {
            return const Loader();
          }
          if (state is GetAllAddTask) {
            final labels = state.labels; // Your list of LabelsData

            final items = labels.map((labelData) {
              return DropdownItem<LabelsData>(
                label: labelData.labelName, // Display name
                value: labelData, // The actual LabelsData object
              );
            }).toList();
            
            return SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TaskTextFormField(
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
                        validatorRequired:true,
                        label: 'Due Date',
                        hintText: 'Enter Due Date',
                        onDateSelected: (p0) {
                          setState(() {
                            FocusScope.of(context).requestFocus(FocusNode());
                          });
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TaskDropDownField(
                          selectedValue: priority,
                          icon: const Icon(Icons.flag_outlined),
                          onChanged: (value) {
                            priority = value;
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
                     TaskMultiDropDownField(controller: controller, items: items, onChanged:(values) {
                       setState(() {
                        //  print('values $values');
                       });
                     },),
                      const SizedBox(
                        height: 16,
                      ),
                      DottedBorder(
                        color: AppPallete.greyColor,
                        radius: const Radius.circular(10),
                        borderType: BorderType.RRect,
                        strokeCap: StrokeCap.round,
                        dashPattern: const [10, 4],
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    Text(
                                      'Task Remainder',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineLarge
                                          ?.copyWith(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    const Icon(IconlyBroken.notification)
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0)
                                    .copyWith(left: 16, right: 16),
                                child: TaskDatePicker(
                                  label: 'Date',
                                  hintText: 'Select Date',
                                  onDateSelected: (p0) {
                                    setState(() {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                    });
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0).copyWith(
                                    left: 16,
                                    right: 16,
                                    top: 6,
                                    bottom: _remainderTime != null ? null : 28),
                                child: TimePickerWidget(
                                  is12Hour: true,
                                  label: 'Time',
                                  time: _remainderTime,
                                  onTimeChanged: _onInTimeChanged,
                                  format: format,
                                  defaultText:
                                      "Select Time", // Default text if no time is selected
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                     
                    ],
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
