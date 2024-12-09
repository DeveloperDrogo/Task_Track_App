part of 'task_bloc.dart';

@immutable
//only fro builder
sealed class TaskState {}

//only for action
sealed class TaskActionState extends TaskState{}

final class TaskLoadState extends TaskState{}

final class TaskInitial extends TaskState {}

final class GetAllAddTask extends TaskState{
  final List<LabelsData> labels;
  GetAllAddTask({required this.labels});
}

final class TaskErrorState extends TaskActionState{
  final String errorMessage;
  TaskErrorState({required this.errorMessage});
}