import 'package:fpdart/fpdart.dart';
import 'package:task_track_app/core/error/exception.dart';
import 'package:task_track_app/core/error/failure.dart';
import 'package:task_track_app/features/taskTrack/data/datasource/task_remote_data_source.dart';
import 'package:task_track_app/features/taskTrack/domain/entities/label_data.dart';
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
}
