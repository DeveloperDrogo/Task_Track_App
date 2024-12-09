import 'package:dio/dio.dart';
import 'package:task_track_app/core/error/exception.dart';
import 'package:task_track_app/features/taskTrack/data/model/label_model.dart';

abstract interface class TaskRemoteDataSource {
  Future<List<LabelsModel>> getAllLabels();
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
      print(e.toString());
      throw ServerException(e.toString());
    }
  }
}
