import 'package:fpdart/fpdart.dart';
import 'package:task_track_app/core/error/failure.dart';
import 'package:task_track_app/features/taskTrack/domain/entities/label_data.dart';

abstract interface class TaskRepository{
  Future<Either<Failure,List<LabelsData>>> getAllLabels();
}