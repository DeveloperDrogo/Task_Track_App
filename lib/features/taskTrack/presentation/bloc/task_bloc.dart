import 'dart:async';
import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_track_app/core/usecase/usecase.dart';
import 'package:task_track_app/features/taskTrack/domain/entities/label_data.dart';
import 'package:task_track_app/features/taskTrack/domain/usecase/add_task_use_case.dart';
import 'package:task_track_app/features/taskTrack/domain/usecase/get_all_labels_use_case.dart';
part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetAllLabelsUseCase _getAllLabelsUseCase;
  final AddTaskUseCase _addTaskUseCase;

  TaskBloc({
    required GetAllLabelsUseCase getAllLabelsUseCase,
    required AddTaskUseCase addTaskUseCase,
  })  : _getAllLabelsUseCase = getAllLabelsUseCase,
        _addTaskUseCase = addTaskUseCase,
        super(TaskInitial()) {
    on<GetAllAddTaskEvent>(_getAllAddTaskEvent);
    on<AddTaskEvent>(_addTaskEvent);
  }

  FutureOr<void> _getAllAddTaskEvent(
      GetAllAddTaskEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoadState());
    final result = await _getAllLabelsUseCase(NoParms());
    result.fold(
      (l) => emit(
        TaskErrorState(
          errorMessage: l.message,
        ),
      ),
      (r) => emit(
        GetAllAddTask(labels: r),
      ),
    );
  }

  FutureOr<void> _addTaskEvent(
      AddTaskEvent event, Emitter<TaskState> emit) async {
    emit(TaskActionLoadeState());
    final result = await _addTaskUseCase(
      AddTaskParms(
        taskName: event.taskName,
        des: event.des,
        dueDate: event.dueDate,
        priority: event.priority,
        labels: event.labels,
      ),
    );

    result.fold(
        (l) => emit(
              TaskErrorState(
                errorMessage: l.message,
              ),
            ), (r) {
      r == true
          ? emit(
              TaskSuccessActionState(
                taskDuration: event.dueDate,
                taskName: event.taskName,
                scheduleDate: event.scheduleDate,
                sheduleTime: event.scheduleTime,
              ),
            )
          : emit(TaskFailedActionState());
    });
  }
}
