import 'package:dio/dio.dart';
import 'package:task_track_app/core/error/exception.dart';
import 'package:task_track_app/features/taskTrack/data/model/label_model.dart';
import 'package:task_track_app/features/taskTrack/data/model/task_model.dart';
import 'package:uuid/uuid.dart';

abstract interface class TaskRemoteDataSource {
  Future<List<LabelsModel>> getAllLabels();
  Future<bool> addTask({
    required String taskName,
    required String des,
    required String dueDate,
    required String priority,
    required List labels,
  });
  Future<List<TaskModel>> getAllTask();
  Future<bool> moveTask({required String taskId, required String projectId});
  Future<bool> deleteTask({required String taskId});
  Future<TaskModel> getTaskDetailsForTaskId({required String taskId});
  Future<bool> updateTask(
      {required String taskName,
      required String des,
      required String dueDate,
      required String priority,
      required String taskId});
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

  @override
  Future<List<TaskModel>> getAllTask() async {
    try {
      List<TaskModel> posts = [];
      final response = await dio.get(
        '${restApiUrl}tasks',
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
        DateTime dateA = DateTime.parse(a['created_at']);
        DateTime dateB = DateTime.parse(b['created_at']);
        return dateB.compareTo(dateA); // Descending order
      });

      // Convert each map to a TaskModel
      for (Map<String, dynamic> map in result) {
        TaskModel post = TaskModel.fromMap(map);
        posts.add(post);
      }
      return posts;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> moveTask(
      {required String taskId, required String projectId}) async {
    try {
      final response = await dio.post(
        '${syncApiUrl}sync',
        options: Options(
          headers: {
            'Authorization': 'Bearer $apiToken',
          },
        ),
        data: {
          "commands": [
            {
              "type": "item_move",
              "args": {"id": taskId, "project_id": projectId},
              "uuid": const Uuid().v4(),
            },
          ],
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
  Future<bool> deleteTask({required String taskId}) async {
    try {
      final Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer $apiToken";
      final response = await dio.delete('${restApiUrl}tasks/$taskId');
      if (response.statusCode == 204 || response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<TaskModel> getTaskDetailsForTaskId({required String taskId}) async {
    try {
      final response = await dio.get(
        '${restApiUrl}tasks/$taskId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $apiToken',
          },
        ),
      );

      // Directly pass response.data to TaskModel.fromJson
      return TaskModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
   
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> updateTask(
      {required String taskName,
      required String des,
      required String dueDate,
      required String priority,
      required String taskId}) async {
    try {
      final response = await dio.post(
        '${restApiUrl}tasks/$taskId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $apiToken',
            'Content-Type': 'application/json'
          },
        ),
        data: {
          "content": taskName,
          "description": des,
          "priority": priority,
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
