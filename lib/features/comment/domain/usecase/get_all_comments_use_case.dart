import 'package:fpdart/fpdart.dart';
import 'package:task_track_app/core/error/failure.dart';
import 'package:task_track_app/core/usecase/usecase.dart';
import 'package:task_track_app/features/comment/domain/entities/comments_data.dart';
import 'package:task_track_app/features/comment/domain/reposiotry/comments_repository.dart';

class GetAllCommentsUseCase
    implements UseCase<List<CommentsData>, GetAllCommentsParms> {
  final CommnentsRepository commnentsRepository;
  GetAllCommentsUseCase({required this.commnentsRepository});

  @override
  Future<Either<Failure, List<CommentsData>>> call(
      GetAllCommentsParms parms) async {
    return await commnentsRepository.getAllComments(
      taskId: parms.taskId,
    );
  }
}

class GetAllCommentsParms {
  final String taskId;

  GetAllCommentsParms({
    required this.taskId,
  });
}
