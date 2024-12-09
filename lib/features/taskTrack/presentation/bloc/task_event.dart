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

  AddTaskEvent({
    required this.taskName,
    required this.des,
    required this.dueDate,
    required this.priority,
    required this.labels,
    required this.scheduleDate,
    required this.scheduleTime
  });
}
