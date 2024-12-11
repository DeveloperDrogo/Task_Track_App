import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:iconly/iconly.dart';
import 'package:task_track_app/core/constant/constant.dart';
import 'package:task_track_app/core/utils/date_format.dart';
import 'package:task_track_app/core/utils/show_dialog.dart';
import 'package:task_track_app/core/utils/time_ago.dart';
import 'package:task_track_app/features/comment/domain/entities/comments_data.dart';

class MyCommentsList extends StatelessWidget {
  final CommentsData commentsData;
  final int index;
  final String formatedDate;
  final Function(String) onDeletePress;
  const MyCommentsList({
    super.key,
    required this.commentsData,
    required this.index,
    required this.formatedDate,
    required this.onDeletePress,
  });

  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.staggeredList(
      position: index,
      duration: const Duration(milliseconds: 500),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: Container(
            margin: const EdgeInsets.only(left: 0, right: 0, top: 5, bottom: 5),
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              border: Border.all(width: 0.5, color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              trailing: IconButton(
                  onPressed: () {
                    showAwesomeDialog(
                      context: context,
                      type: Constant.question,
                      title: 'Are you sure?',
                      desc: 'Do you really want to delete this comment?',
                      successButtonText: 'Okay',
                      failedButtonText: 'Close',
                      okButtonPress: () {
                        onDeletePress(
                          commentsData.commentId,
                        );
                        Navigator.pop(context);
                      },
                      cancelButtonPress: () {
                        Navigator.pop(context);
                      },
                    );
                  },
                  icon: const Icon(IconlyBroken.delete)),
              title: Text(
                commentsData.comment,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Row(
                  children: [
                    Text(
                      formatDateDMMMYYYY(
                        DateTime.parse(formatedDate),
                      ),
                      style:
                          Theme.of(context).textTheme.headlineLarge?.copyWith(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w500,
                              ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      timeAgo(
                        DateTime.parse(commentsData.commentDate),
                      ),
                      style: TextStyle(
                        //fontFamily: "Lato",

                        fontSize: 12.5,
                        fontWeight: FontWeight.w400,
                        color: AdaptiveTheme.of(context).mode.isDark
                            ? Colors.grey
                            : const Color.fromARGB(255, 132, 132, 132),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
