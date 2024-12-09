import 'package:fpdart/fpdart.dart';
import 'package:task_track_app/core/error/failure.dart';
import 'package:task_track_app/core/usecase/usecase.dart';
import 'package:task_track_app/features/taskTrack/domain/repository/task_repository.dart';

class AddTaskUseCase implements UseCase<bool, AddTaskParms> {
  final TaskRepository taskRepository;
  AddTaskUseCase({required this.taskRepository});
  @override
  Future<Either<Failure, bool>> call(AddTaskParms parms) async {
    return await taskRepository.addTask(
      taskName: parms.taskName,
      des: parms.des,
      dueDate: parms.dueDate,
      priority: parms.priority,
      labels: parms.labels,
    );
  }
}

class AddTaskParms {
  final String taskName;
  final String des;
  final String dueDate;
  final String priority;
  final List labels;

  AddTaskParms(
      {required this.taskName,
      required this.des,
      required this.dueDate,
      required this.priority,
      required this.labels});
}
