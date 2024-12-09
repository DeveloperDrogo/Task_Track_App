import 'package:fpdart/fpdart.dart';
import 'package:task_track_app/core/error/failure.dart';
import 'package:task_track_app/core/usecase/usecase.dart';
import 'package:task_track_app/features/taskTrack/domain/entities/label_data.dart';
import 'package:task_track_app/features/taskTrack/domain/repository/task_repository.dart';

class GetAllLabelsUseCase implements UseCase<List<LabelsData>,NoParms>{
  final TaskRepository taskRepository;
  GetAllLabelsUseCase({required this.taskRepository});
  @override
  Future<Either<Failure, List<LabelsData>>> call(NoParms parms) async{
    return await taskRepository.getAllLabels();
  }
  
}