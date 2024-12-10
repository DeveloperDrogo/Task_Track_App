import 'package:fpdart/fpdart.dart';
import 'package:task_track_app/core/error/failure.dart';
import 'package:task_track_app/core/usecase/usecase.dart';
import 'package:task_track_app/features/taskTrack/domain/repository/task_repository.dart';

class UpdateTaskUseCase implements UseCase<bool, UpdateTaskParms> {
  final TaskRepository taskRepository;
  UpdateTaskUseCase({required this.taskRepository});

  @override
  Future<Either<Failure, bool>> call(UpdateTaskParms parms) async {
    return await taskRepository.updateTask(
      taskName: parms.taskName,
      des: parms.des,
      dueDate: parms.dueDate,
      priority: parms.priority,
      taskId: parms.taskId,
    );
  }
}

class UpdateTaskParms {
  final String taskName;
  final String des;
  final String dueDate;
  final String priority;
  final String taskId;

  UpdateTaskParms(
      {required this.taskName,
      required this.des,
      required this.dueDate,
      required this.priority,
      required this.taskId});
}
