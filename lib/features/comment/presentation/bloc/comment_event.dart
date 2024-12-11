part of 'comment_bloc.dart';

@immutable
sealed class CommentEvent {}

final class GetAllComments extends CommentEvent {
  final String taskId;

  GetAllComments({required this.taskId});
}

final class AddNewCommentEvent extends CommentEvent {
  final String taskId;
  final String comment;

  AddNewCommentEvent({required this.taskId, required this.comment});
}

final class DeleteCommentEvent extends CommentEvent{
  final String commentId;

  DeleteCommentEvent({required this.commentId});
}