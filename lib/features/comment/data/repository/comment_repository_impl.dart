import 'package:fpdart/fpdart.dart';
import 'package:task_track_app/core/error/exception.dart';
import 'package:task_track_app/core/error/failure.dart';
import 'package:task_track_app/features/comment/data/datasource/comments_remote_data_source.dart';
import 'package:task_track_app/features/comment/domain/entities/comments_data.dart';
import 'package:task_track_app/features/comment/domain/reposiotry/comments_repository.dart';

class CommnentsRepositoryImpl implements CommnentsRepository {
  final CommentsRemoteDataSource commentsRemoteDataSource;

  CommnentsRepositoryImpl({required this.commentsRemoteDataSource});
  @override
  Future<Either<Failure, List<CommentsData>>> getAllComments({
    required String taskId,
  }) async {
    try {
      final result = await commentsRemoteDataSource.getAllComments(
        taskId: taskId,
      );
      return right(result);
    } on ServerException catch (e) {
      return left(
        Failure(
          e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> addComment(
      {required String taskId, required String comment}) async {
    try {
      final result = await commentsRemoteDataSource.addComment(
        taskId: taskId,
        comment: comment,
      );
      return right(result);
    } on ServerException catch (e) {
      return left(
        Failure(
          e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> deleteComment(
      {required String commentId}) async {
    try {
      final result = await commentsRemoteDataSource.deleteComment(
        commentId: commentId,
      );
      return right(result);
    } on ServerException catch (e) {
      return left(
        Failure(
          e.toString(),
        ),
      );
    }
  }
}
