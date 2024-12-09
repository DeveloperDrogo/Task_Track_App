import 'package:fpdart/fpdart.dart';
import 'package:task_track_app/core/error/failure.dart';
import 'package:task_track_app/features/taskTrack/domain/entities/label_data.dart';
import 'package:task_track_app/features/taskTrack/domain/entities/task_data.dart';

abstract interface class TaskRepository {
  Future<Either<Failure, List<LabelsData>>> getAllLabels();
  Future<Either<Failure, bool>> addTask({
    required String taskName,
    required String des,
    required String dueDate,
    required String priority,
    required List labels,
  });
  Future<Either<Failure, List<TaskData>>> getAllTask();
  Future<Either<Failure, bool>> moveTask(
      {required String taskId, required String projectId});
}
