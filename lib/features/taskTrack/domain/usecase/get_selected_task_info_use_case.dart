import 'package:fpdart/fpdart.dart';
import 'package:task_track_app/core/error/failure.dart';
import 'package:task_track_app/core/usecase/usecase.dart';
import 'package:task_track_app/features/taskTrack/data/model/task_model.dart';
import 'package:task_track_app/features/taskTrack/domain/repository/task_repository.dart';

class GetSelectedTaskUseCase
    implements UseCase<TaskModel, GetSelectedTaskUseCaseParms> {
  final TaskRepository taskRepository;
  GetSelectedTaskUseCase({required this.taskRepository});

  @override
  Future<Either<Failure, TaskModel>> call(GetSelectedTaskUseCaseParms parms) async{
    return await taskRepository.getTaskDetails(taskId: parms.taskId);
  }
}

class GetSelectedTaskUseCaseParms {
  final String taskId;

  GetSelectedTaskUseCaseParms({required this.taskId});
}
