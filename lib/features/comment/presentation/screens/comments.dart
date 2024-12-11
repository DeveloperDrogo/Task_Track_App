import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:task_track_app/core/common/widget/loader.dart';
import 'package:task_track_app/core/theme/app_pallet.dart';
import 'package:task_track_app/core/utils/date_format.dart';
import 'package:task_track_app/core/utils/show_loading_dialog.dart';
import 'package:task_track_app/core/utils/show_snackbar.dart';
import 'package:task_track_app/features/comment/presentation/bloc/comment_bloc.dart';
import 'package:task_track_app/features/comment/presentation/widgets/comments_empty.dart';
import 'package:task_track_app/features/comment/presentation/widgets/comments_text_form_field.dart';
import 'package:task_track_app/features/comment/presentation/widgets/my_comments_list.dart';
import 'package:task_track_app/features/taskTrack/presentation/screens/task.dart';

class CommentsPage extends StatefulWidget {
  final String taskId;
  final String taskName;
  final String dueDate;
  static route({
    required String taskId,
    required String taskName,
    required String dueDate,
  }) =>
      MaterialPageRoute(
        builder: (context) => CommentsPage(
          taskName: taskName,
          dueDate: dueDate,
          taskId: taskId,
        ),
      );
  const CommentsPage(
      {super.key,
      required this.taskId,
      required this.taskName,
      required this.dueDate});

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final _formKey = GlobalKey<FormState>();
  final _commentController = TextEditingController();
  @override
  void initState() {
    context.read<CommentBloc>().add(
          GetAllComments(taskId: widget.taskId),
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: CommentsTextFormField(
                  validateRequired: true,
                  label: 'Coment',
                  hintText: 'Enter comment',
                  controller: _commentController,
                  minLines: 1,
                  maxLines: 2,
                  icon: const Icon(Icons.comment),
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppPallete.primaryColor,
                    border: Border.all(width: 0.5, color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                    // color: Theme.of(context).cardTheme.color,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 0, bottom: 0),
                    child: IconButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<CommentBloc>().add(
                                AddNewCommentEvent(
                                  taskId: widget.taskId,
                                  comment: _commentController.text,
                                ),
                              );
                        }
                      },
                      icon: const Icon(
                        IconlyBroken.send,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: Text(
          'Comments',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.push(context, TaskTrackPage.route());
          },
          icon: const Icon(Icons.close),
        ),
      ),
      body: WillPopScope(
        onWillPop: () async{
          Navigator.push(context, TaskTrackPage.route());
          return false;
        },
        child: BlocConsumer<CommentBloc, CommentState>(
          listenWhen: (previous, current) => current is CommentActionState,
          buildWhen: (previous, current) => current is! CommentActionState,
          listener: (context, state) {
            if (state is CommentsErrorState) {
              showSnackBar(context, state.errorMessage);
            } else if (state is CommentActionLoadState) {
              LoadingDialog.show(context);
            } else if (state is CommentSuccessState) {
              LoadingDialog.dismiss(context);
              Navigator.push(
                context,
                CommentsPage.route(
                  taskId: widget.taskId,
                  taskName: widget.taskName,
                  dueDate: widget.dueDate,
                ),
              );
            } else if (state is CommentFailedState) {
              LoadingDialog.dismiss(context);
              Navigator.push(
                context,
                CommentsPage.route(
                  taskId: widget.taskId,
                  taskName: widget.taskName,
                  dueDate: widget.dueDate,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is CommentsLoadState) {
              return const Loader();
            }
      
            if (state is GetAllCommentsState) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                          left: 0, right: 0, top: 5, bottom: 5),
                      decoration: BoxDecoration(
                        border: Border.all(width: 0.5, color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                        color: AppPallete.primaryColor,
                      ),
                      child: ListTile(
                        leading: const Icon(
                          IconlyBroken.chat,
                          color: Colors.white,
                        ),
                        title: Text(
                          widget.taskName,
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                        ),
                        subtitle: Text(
                          formatDateDMMMYYYY(
                            DateTime.parse(widget.dueDate),
                          ),
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.copyWith(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color:
                                      const Color.fromARGB(255, 213, 213, 213)),
                        ),
                      ),
                    ),
                    state.comments.isEmpty
                        ? const CommentEmpty()
                        : Expanded(
                            child: ListView.builder(
                              itemCount: state.comments.length,
                              itemBuilder: (context, index) {
                                DateTime parsedDate = DateTime.parse(
                                    state.comments[index].commentDate);
      
                                // Format the date to 'yyyy-MM-dd'
                                String formattedDate =
                                    DateFormat('yyyy-MM-dd').format(parsedDate);
      
                                return MyCommentsList(
                                  commentsData: state.comments[index],
                                  index: index,
                                  formatedDate: formattedDate,
                                  onDeletePress: (commentId) {
                                    context.read<CommentBloc>().add(
                                        DeleteCommentEvent(commentId: commentId));
                                  },
                                );
                              },
                            ),
                          )
                  ],
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
