import 'package:fpdart/fpdart.dart';
import 'package:task_track_app/core/error/failure.dart';
import 'package:task_track_app/core/usecase/usecase.dart';
import 'package:task_track_app/features/comment/domain/reposiotry/comments_repository.dart';

class DeleteCommentUsecase implements UseCase<bool, DeleteCommentParms> {
  final CommnentsRepository commnentsRepository;
  DeleteCommentUsecase({required this.commnentsRepository});

  @override
  Future<Either<Failure, bool>> call(DeleteCommentParms parms) async {
    return await commnentsRepository.deleteComment(commentId: parms.commentId);
  }
}

class DeleteCommentParms {
  final String commentId;

  DeleteCommentParms({required this.commentId});
}
