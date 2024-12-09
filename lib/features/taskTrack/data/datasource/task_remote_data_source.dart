import 'package:dio/dio.dart';
import 'package:task_track_app/core/error/exception.dart';
import 'package:task_track_app/features/taskTrack/data/model/label_model.dart';

abstract interface class TaskRemoteDataSource {
  Future<List<LabelsModel>> getAllLabels();
  Future<bool> addTask({
    required String taskName,
    required String des,
    required String dueDate,
    required String priority,
    required List labels,
  });
}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final Dio dio;
  final String restApiUrl;
  final String syncApiUrl;
  final String apiToken;
  TaskRemoteDataSourceImpl({
    required this.dio,
    required this.restApiUrl,
    required this.syncApiUrl,
    required this.apiToken,
  });
  @override
  Future<List<LabelsModel>> getAllLabels() async {
    try {
      List<LabelsModel> posts = [];
      final response = await dio.get(
        '${restApiUrl}labels',
        options: Options(
          headers: {
            'Authorization': 'Bearer $apiToken',
          },
        ),
      );
      // Correctly decode the response as a list of maps
      List<Map<String, dynamic>> result =
          List<Map<String, dynamic>>.from(response.data);

      // Convert each map to a LabelsModel
      for (Map<String, dynamic> map in result) {
        LabelsModel post = LabelsModel.fromMap(map);
        posts.add(post);
      }
      return posts;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> addTask({
    required String taskName,
    required String des,
    required String dueDate,
    required String priority,
    required List labels,
  }) async {
    try {
      final response = await dio.post(
        '${restApiUrl}tasks',
        options: Options(
          headers: {
            'Authorization': 'Bearer $apiToken',
            'Content-Type': 'application/json'
          },
        ),
        data: {
          "content": taskName,
          "description": des,
          "labels": labels,
          "priority": priority,
          "project_id": "2344765751",
          "due_string": dueDate,
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
}
