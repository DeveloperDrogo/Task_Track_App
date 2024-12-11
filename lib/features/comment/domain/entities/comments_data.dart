class CommentsData {
  final String comment;
  final String commentId;
  final String commentDate;

  CommentsData({
    required this.comment,
    required this.commentId,
    required this.commentDate,
  });

  static fromMap(Map<String, dynamic> decode) {}
}
