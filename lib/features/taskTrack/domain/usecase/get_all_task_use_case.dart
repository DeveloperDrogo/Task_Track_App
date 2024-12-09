import 'package:fpdart/fpdart.dart';
import 'package:task_track_app/core/error/failure.dart';
import 'package:task_track_app/core/usecase/usecase.dart';
import 'package:task_track_app/features/taskTrack/domain/entities/task_data.dart';
import 'package:task_track_app/features/taskTrack/domain/repository/task_repository.dart';

class GetAllTaskUseCase implements UseCase<List<TaskData>, NoParms> {
  final TaskRepository taskRepository;
  GetAllTaskUseCase({required this.taskRepository});

  @override
  Future<Either<Failure, List<TaskData>>> call(NoParms parms) async {
    return await taskRepository.getAllTask();
  }
}
