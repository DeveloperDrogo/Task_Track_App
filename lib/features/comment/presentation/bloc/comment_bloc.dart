import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_track_app/features/comment/domain/entities/comments_data.dart';
import 'package:task_track_app/features/comment/domain/usecase/add_new_comment_use_case.dart';
import 'package:task_track_app/features/comment/domain/usecase/delete_comment_use_case.dart';
import 'package:task_track_app/features/comment/domain/usecase/get_all_comments_use_case.dart';
part 'comment_event.dart';
part 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final GetAllCommentsUseCase _getAllCommentsUseCase;
  final AddNewCommentUseCase _addNewCommentUseCase;
  final DeleteCommentUsecase _deleteCommentUsecase;

  CommentBloc({
    required GetAllCommentsUseCase getAllCommentsUseCase,
    required AddNewCommentUseCase addNewCommentUseCase,
    required DeleteCommentUsecase deleteCommentUsecase,
  })  : _getAllCommentsUseCase = getAllCommentsUseCase,
        _addNewCommentUseCase = addNewCommentUseCase,
        _deleteCommentUsecase = deleteCommentUsecase,
        super(CommentInitial()) {
    on<GetAllComments>(_getAllComments);
    on<AddNewCommentEvent>(_addNewCommentEvent);
    on<DeleteCommentEvent>(_deleteCommentEvent);
  }

  FutureOr<void> _getAllComments(
      GetAllComments event, Emitter<CommentState> emit) async {
    emit(CommentsLoadState());
    final result = await _getAllCommentsUseCase(
      GetAllCommentsParms(
        taskId: event.taskId,
      ),
    );
    result.fold(
      (l) => emit(
        CommentsErrorState(
          errorMessage: l.message,
        ),
      ),
      (r) => emit(
        GetAllCommentsState(
          comments: r,
        ),
      ),
    );
  }

  FutureOr<void> _addNewCommentEvent(
      AddNewCommentEvent event, Emitter<CommentState> emit) async {
    emit(CommentActionLoadState());
    final result = await _addNewCommentUseCase(
      AddNewCommentParms(
        taskId: event.taskId,
        comment: event.comment,
      ),
    );
    result.fold(
        (l) => emit(
              CommentsErrorState(
                errorMessage: l.message,
              ),
            ), (r) {
      r == true ? emit(CommentSuccessState()) : emit(CommentFailedState());
    });
  }

  FutureOr<void> _deleteCommentEvent(
      DeleteCommentEvent event, Emitter<CommentState> emit) async {
    emit(CommentActionLoadState());
    final result = await _deleteCommentUsecase(
      DeleteCommentParms(commentId: event.commentId),
    );
    result.fold(
        (l) => emit(
              CommentsErrorState(
                errorMessage: l.message,
              ),
            ), (r) {
      r == true ? emit(CommentSuccessState()) : emit(CommentFailedState());
    });
  }
}
