import 'package:fpdart/fpdart.dart';
import 'package:task_track_app/core/error/failure.dart';
import 'package:task_track_app/core/usecase/usecase.dart';
import 'package:task_track_app/features/taskTrack/domain/repository/task_repository.dart';

class DeleteTaskUseCase implements UseCase<bool, DeleteTaskParms> {
  final TaskRepository taskRepository;
  DeleteTaskUseCase({required this.taskRepository});

  @override
  Future<Either<Failure, bool>> call(DeleteTaskParms parms) async {
    return await taskRepository.deleteTask(taskId: parms.taskId);
  }
}

class DeleteTaskParms {
  final String taskId;

  DeleteTaskParms({required this.taskId});
}
