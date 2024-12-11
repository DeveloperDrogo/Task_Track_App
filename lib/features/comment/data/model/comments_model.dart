import 'dart:convert';

import 'package:task_track_app/features/comment/domain/entities/comments_data.dart';

class CommentsModel extends CommentsData {
  CommentsModel({required super.comment, required super.commentId,required super.commentDate,});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'comment': comment,
      'commentId': commentId,
      'comment_date':commentDate
    };
  }

  factory CommentsModel.fromMap(Map<String, dynamic> map) {
    return CommentsModel(
      comment: map['content'] ?? '',
      commentId: map['id'] ?? '',
      commentDate: map['posted_at']??''
    );
  }

  String toJson() => json.encode(toMap());

  factory CommentsModel.fromJson(String source) =>
      CommentsModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
