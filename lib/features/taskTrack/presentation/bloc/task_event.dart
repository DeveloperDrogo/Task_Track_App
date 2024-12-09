part of 'task_bloc.dart';

@immutable
sealed class TaskEvent {}

final class GetAllAddTaskEvent extends TaskEvent {}