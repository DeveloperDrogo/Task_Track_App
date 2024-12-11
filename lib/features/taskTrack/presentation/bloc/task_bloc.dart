import 'dart:async';
import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_track_app/core/usecase/usecase.dart';
import 'package:task_track_app/features/taskTrack/data/model/task_model.dart';
import 'package:task_track_app/features/taskTrack/domain/entities/label_data.dart';
import 'package:task_track_app/features/taskTrack/domain/entities/task_data.dart';
import 'package:task_track_app/features/taskTrack/domain/usecase/add_task_use_case.dart';
import 'package:task_track_app/features/taskTrack/domain/usecase/delete_task_use_case.dart';
import 'package:task_track_app/features/taskTrack/domain/usecase/get_all_labels_use_case.dart';
import 'package:task_track_app/features/taskTrack/domain/usecase/get_all_task_use_case.dart';
import 'package:task_track_app/features/taskTrack/domain/usecase/move_task_use_case.dart';
import 'package:task_track_app/features/taskTrack/domain/usecase/update_task.dart';
import '../../domain/usecase/get_selected_task_info_use_case.dart';
part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetAllLabelsUseCase _getAllLabelsUseCase;
  final AddTaskUseCase _addTaskUseCase;
  final GetAllTaskUseCase _getAllTaskUseCase;
  final MoveTaskUseCase _moveTaskUseCase;
  final DeleteTaskUseCase _deleteTaskUseCase;
  final GetSelectedTaskUseCase _getSelectedTaskUseCase;
  final UpdateTaskUseCase _updateTaskUseCase;

  TaskBloc({
    required GetAllLabelsUseCase getAllLabelsUseCase,
    required AddTaskUseCase addTaskUseCase,
    required GetAllTaskUseCase getAllTaskUseCase,
    required MoveTaskUseCase moveTaskUseCase,
    required DeleteTaskUseCase deleteTaskUseCase,
    required GetSelectedTaskUseCase getSelectedTaskUseCase,
    required UpdateTaskUseCase updateTaskUseCase,
  })  : _getAllLabelsUseCase = getAllLabelsUseCase,
        _addTaskUseCase = addTaskUseCase,
        _getAllTaskUseCase = getAllTaskUseCase,
        _moveTaskUseCase = moveTaskUseCase,
        _deleteTaskUseCase = deleteTaskUseCase,
        _getSelectedTaskUseCase = getSelectedTaskUseCase,
        _updateTaskUseCase = updateTaskUseCase,
        super(TaskInitial()) {
    on<GetAllAddTaskEvent>(_getAllAddTaskEvent);
    on<AddTaskEvent>(_addTaskEvent);
    on<GetAllTaskEvent>(_getAllTaskEvent);
    on<MoveTaskEvent>(_moveTaskEvent);
    on<DeleteTaskEvent>(_deleteTaskEvent);
    on<GetSelectedTaskInfoEvent>(_getSelectedTaskInfoEvent);
    on<UpdateTaskEvent>(_updateTaskEvent);
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

  FutureOr<void> _getAllTaskEvent(
      GetAllTaskEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoadState());
    final result = await _getAllTaskUseCase(NoParms());
    result.fold(
      (l) => emit(
        TaskErrorState(
          errorMessage: l.message,
        ),
      ),
      (r) => emit(
        GetAllTaskState(taskData: r),
      ),
    );
  }

  FutureOr<void> _moveTaskEvent(
      MoveTaskEvent event, Emitter<TaskState> emit) async {
    final result = await _moveTaskUseCase(
        MoveTaskParms(taskId: event.taskId, projectId: event.projectId));
    result.fold(
        (l) => emit(
              TaskErrorState(
                errorMessage: l.message,
              ),
            ),
        (r) => emit(
              MoveTaskSuccessState(
                  taskName: event.taskName,
                  projectId: event.projectId,
                  taskId: event.taskId),
            ));
  }

  FutureOr<void> _deleteTaskEvent(
      DeleteTaskEvent event, Emitter<TaskState> emit) async {
    final result =
        await _deleteTaskUseCase(DeleteTaskParms(taskId: event.taskId));
    result.fold(
        (l) => emit(
              TaskErrorState(errorMessage: l.message),
            ),
        (r) => emit(DeleteTaskSuccessState()));
  }

  FutureOr<void> _getSelectedTaskInfoEvent(
      GetSelectedTaskInfoEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoadState());
    final task = await _getSelectedTaskUseCase(
      GetSelectedTaskUseCaseParms(taskId: event.taskId),
    );

    task.fold(
      (l) => emit(
        TaskErrorState(
          errorMessage: l.message,
        ),
      ),
      (r) => emit(
        GetTaskInfoState(taskModel: r),
      ),
    );
  }

  FutureOr<void> _updateTaskEvent(
      UpdateTaskEvent event, Emitter<TaskState> emit) async {
    emit(TaskActionLoadeState());
    final result = await _updateTaskUseCase(UpdateTaskParms(
      taskName: event.taskName,
      des: event.des,
      dueDate: event.dueDate,
      priority: event.priority,
      taskId: event.taskId,
    ));

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
                scheduleDate: '',
                sheduleTime: Time(hour: 0, minute: 0),
              ),
            )
          : emit(TaskFailedActionState());
    });
  }
}
