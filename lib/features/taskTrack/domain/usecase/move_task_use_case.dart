import 'package:fpdart/fpdart.dart';
import 'package:task_track_app/core/error/failure.dart';
import 'package:task_track_app/core/usecase/usecase.dart';
import '../repository/task_repository.dart';

class MoveTaskUseCase implements UseCase<bool, MoveTaskParms> {
  final TaskRepository taskRepository;
  MoveTaskUseCase({required this.taskRepository});

  @override
  Future<Either<Failure, bool>> call(MoveTaskParms parms) async {
    return await taskRepository.moveTask(
      taskId: parms.taskId,
      projectId: parms.projectId,
    );
  }
}

class MoveTaskParms {
  final String taskId;
  final String projectId;

  MoveTaskParms({required this.taskId, required this.projectId});
}
