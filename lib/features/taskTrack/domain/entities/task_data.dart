class TaskData {
  final String taskID;
  final String taskName;
  final String des;
  final String dueDate;
  final String priority;
  final List labels;
  final String projectId;

  TaskData(
      {required this.taskID,
      required this.taskName,
      required this.des,
      required this.dueDate,
      required this.priority,
      required this.projectId,
      required this.labels});
}
