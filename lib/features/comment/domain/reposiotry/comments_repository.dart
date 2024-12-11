import 'package:fpdart/fpdart.dart';
import 'package:task_track_app/core/error/failure.dart';
import 'package:task_track_app/features/comment/domain/entities/comments_data.dart';

abstract interface class CommnentsRepository {
  Future<Either<Failure, List<CommentsData>>> getAllComments({
    required String taskId,
  });
  Future<Either<Failure, bool>> addComment({
    required String taskId,
    required String comment,
  });
   Future<Either<Failure, bool>> deleteComment({
    required String commentId,
  });
  
}
