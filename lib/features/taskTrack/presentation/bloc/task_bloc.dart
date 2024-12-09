import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_track_app/core/usecase/usecase.dart';
import 'package:task_track_app/features/taskTrack/domain/entities/label_data.dart';
import 'package:task_track_app/features/taskTrack/domain/usecase/get_all_labels_use_case.dart';
part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetAllLabelsUseCase _getAllLabelsUseCase;
  TaskBloc({required GetAllLabelsUseCase getAllLabelsUseCase})
      : _getAllLabelsUseCase = getAllLabelsUseCase,
        super(TaskInitial()) {
    on<GetAllAddTaskEvent>(_getAllAddTaskEvent);
  }

  FutureOr<void> _getAllAddTaskEvent(
      GetAllAddTaskEvent event, Emitter<TaskState> emit) async {
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
}
