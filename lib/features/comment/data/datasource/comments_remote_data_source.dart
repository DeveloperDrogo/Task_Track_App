import 'package:dio/dio.dart';
import 'package:task_track_app/core/error/exception.dart';
import 'package:task_track_app/features/comment/data/model/comments_model.dart';

abstract interface class CommentsRemoteDataSource {
  Future<List<CommentsModel>> getAllComments({required String taskId});
  Future<bool> addComment({
    required String taskId,
    required String comment,
  });
  Future<bool> deleteComment({
    required String commentId,
  });
}

class CommentsRemoteDataSourceImpl implements CommentsRemoteDataSource {
  final Dio dio;
  final String restApiUrl;
  final String syncApiUrl;
  final String apiToken;

  CommentsRemoteDataSourceImpl({
    required this.dio,
    required this.restApiUrl,
    required this.syncApiUrl,
    required this.apiToken,
  });

  @override
  Future<List<CommentsModel>> getAllComments({required String taskId}) async {
    try {
      List<CommentsModel> posts = [];
      final response = await dio.get(
        '${restApiUrl}comments?task_id=$taskId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $apiToken',
          },
        ),
      );


      // Correctly decode the response as a list of maps
      List<Map<String, dynamic>> result =
          List<Map<String, dynamic>>.from(response.data);

      // Sort the result based on created_at in descending order
      result.sort((a, b) {
        DateTime dateA = DateTime.parse(a['posted_at']);
        DateTime dateB = DateTime.parse(b['posted_at']);
        return dateB.compareTo(dateA); // Descending order
      });

      // Convert each map to a CommentsModel
      for (Map<String, dynamic> map in result) {
        CommentsModel post = CommentsModel.fromMap(map);
        posts.add(post);
      }
      return posts;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> addComment(
      {required String taskId, required String comment}) async {
    try {
      final response = await dio.post(
        '${restApiUrl}comments',
        options: Options(
          headers: {
            'Authorization': 'Bearer $apiToken',
            'Content-Type': 'application/json'
          },
        ),
        data: {
          "task_id": taskId,
          "content": comment,
        },
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> deleteComment({required String commentId}) async {
    try {
      final Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer $apiToken";
      final response = await dio.delete('${restApiUrl}comments/$commentId');
      if (response.statusCode == 204 || response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
