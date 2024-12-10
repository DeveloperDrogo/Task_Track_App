part of 'task_bloc.dart';

@immutable
sealed class TaskEvent {}

final class GetAllAddTaskEvent extends TaskEvent {}

final class AddTaskEvent extends TaskEvent {
  final String taskName;
  final String des;
  final String dueDate;
  final String priority;
  final List labels;
  final String scheduleDate;
  final Time scheduleTime;

  AddTaskEvent(
      {required this.taskName,
      required this.des,
      required this.dueDate,
      required this.priority,
      required this.labels,
      required this.scheduleDate,
      required this.scheduleTime});
}

final class GetAllTaskEvent extends TaskEvent {}

final class MoveTaskEvent extends TaskEvent {
  final String taskId;
  final String projectId;
  final String taskName;

  MoveTaskEvent({
    required this.taskId,
    required this.projectId,
    required this.taskName,
  });
}

final class DeleteTaskEvent extends TaskEvent {
  final String taskId;
  DeleteTaskEvent({required this.taskId});
}
