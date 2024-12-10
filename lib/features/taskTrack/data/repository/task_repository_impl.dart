import 'package:fpdart/fpdart.dart';
import 'package:task_track_app/core/error/exception.dart';
import 'package:task_track_app/core/error/failure.dart';
import 'package:task_track_app/features/taskTrack/data/datasource/task_remote_data_source.dart';
import 'package:task_track_app/features/taskTrack/data/model/task_model.dart';
import 'package:task_track_app/features/taskTrack/domain/entities/label_data.dart';
import 'package:task_track_app/features/taskTrack/domain/entities/task_data.dart';
import 'package:task_track_app/features/taskTrack/domain/repository/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource taskRemoteDataSource;
  TaskRepositoryImpl({required this.taskRemoteDataSource});
  @override
  Future<Either<Failure, List<LabelsData>>> getAllLabels() async {
    try {
      final result = await taskRemoteDataSource.getAllLabels();
      return right(result);
    } on ServerException catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> addTask(
      {required String taskName,
      required String des,
      required String dueDate,
      required String priority,
      required List labels}) async {
    try {
      final result = await taskRemoteDataSource.addTask(
        taskName: taskName,
        des: des,
        dueDate: dueDate,
        priority: priority,
        labels: labels,
      );
      return right(result);
    } on ServerException catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TaskData>>> getAllTask() async {
    try {
      final result = await taskRemoteDataSource.getAllTask();
      return right(result);
    } on ServerException catch (e) {
      return left(
        Failure(
          e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> moveTask(
      {required String taskId, required String projectId}) async {
    try {
      final result = await taskRemoteDataSource.moveTask(
          taskId: taskId, projectId: projectId);
      return right(result);
    } on ServerException catch (e) {
      return left(
        Failure(
          e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> deleteTask({required String taskId}) async {
    try {
      final result = await taskRemoteDataSource.deleteTask(taskId: taskId);
      return right(result);
    } on ServerException catch (e) {
      return left(
        Failure(
          e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, TaskModel>> getTaskDetails({required String taskId}) async{
    try {
      final result = await taskRemoteDataSource.getTaskDetailsForTaskId(taskId: taskId);
      return right(result);
    } on ServerException catch (e) {
      return left(
        Failure(
          e.toString(),
        ),
      );
    }
  }
  
  @override
  Future<Either<Failure, bool>> updateTask({required String taskName, required String des, required String dueDate, required String priority, required String taskId}) async{
     try {
      final result = await taskRemoteDataSource.updateTask(
        taskName: taskName,
        des: des,
        dueDate: dueDate,
        priority: priority,
        taskId: taskId,
      );
      return right(result);
    } on ServerException catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
