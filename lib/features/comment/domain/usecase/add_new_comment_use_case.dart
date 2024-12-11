import 'package:fpdart/fpdart.dart';
import 'package:task_track_app/core/error/failure.dart';
import 'package:task_track_app/core/usecase/usecase.dart';
import 'package:task_track_app/features/comment/domain/reposiotry/comments_repository.dart';

class AddNewCommentUseCase implements UseCase<bool, AddNewCommentParms> {
  final CommnentsRepository commnentsRepository;

  AddNewCommentUseCase({required this.commnentsRepository});

  @override
  Future<Either<Failure, bool>> call(AddNewCommentParms parms) async {
    return commnentsRepository.addComment(
      taskId: parms.taskId,
      comment: parms.comment,
    );
  }
}

class AddNewCommentParms {
  final String taskId;
  final String comment;

  AddNewCommentParms({required this.taskId, required this.comment});
}
