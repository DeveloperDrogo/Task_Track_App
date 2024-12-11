part of 'comment_bloc.dart';

@immutable
sealed class CommentState {}

sealed class CommentActionState extends CommentState {}

final class CommentsLoadState extends CommentState {}

final class CommentActionLoadState extends CommentActionState {}

final class CommentsErrorState extends CommentActionState {
  final String errorMessage;

  CommentsErrorState({required this.errorMessage});
}

final class GetAllCommentsState extends CommentState {
  final List<CommentsData> comments;
  GetAllCommentsState({required this.comments});
}

final class CommentInitial extends CommentState {}

final class CommentSuccessState extends CommentActionState{}

final class CommentFailedState extends CommentActionState{}