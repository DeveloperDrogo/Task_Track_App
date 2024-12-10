import 'dart:convert';
import 'package:task_track_app/features/taskTrack/domain/entities/task_data.dart';

class TaskModel extends TaskData {
  TaskModel(
      {required super.taskID,
      required super.taskName,
      required super.des,
      required super.dueDate,
      required super.priority,
      required super.labels,
      required super.projectId});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'task_id': taskID,
      'taskName': taskName,
      'des': des,
      'dueDate': dueDate,
      'priority': priority,
      'labels': labels,
      'project_id': projectId
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      taskID: map['id'].toString(),
      taskName: map['content'] ?? '',
      des: map['description'] ?? '',
      dueDate: map['due']['date'] ?? '',
      priority: map['priority'].toString(),
      projectId: map['project_id'].toString(),
      labels: List.from(
        (map['labels'] ?? []),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory TaskModel.fromJson(dynamic source) {
    if (source is String) {
      return TaskModel.fromMap(json.decode(source) as Map<String, dynamic>);
    } else if (source is Map<String, dynamic>) {
      return TaskModel.fromMap(source);
    } else {
      throw ArgumentError('Invalid source type for ProfileModel.fromJson');
    }
  }
}
