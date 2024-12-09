// ignore_for_file: deprecated_member_use

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:task_track_app/core/error/exception.dart';
import 'package:task_track_app/features/taskTrack/data/datasource/task_remote_data_source.dart';
import 'package:task_track_app/features/taskTrack/data/model/label_model.dart';
import 'dio_mock.mocks.dart'; // Ensure the path is correct


void main() {
  late MockDio mockDio;
  late TaskRemoteDataSourceImpl dataSource;

  String restApiUrl = dotenv.get('REST_API_URL', fallback: '');
  String syncApiUrl = dotenv.get('REST_API_URL', fallback: '');
  String apiToken = dotenv.get('API_TOKEN', fallback: '');

  setUp(() {
    mockDio = MockDio();
    dataSource = TaskRemoteDataSourceImpl(
      dio: mockDio,
      restApiUrl: restApiUrl,
      syncApiUrl: syncApiUrl,
      apiToken: apiToken,
    );
  });

  group('getAllLabels', () {
    test('should return a list of LabelsModel when the response is successful', () async {
      final mockResponse = [
        {"id": "1", "name": "Label1"},
        {"id": "2", "name": "Label2"}
      ];

      when(mockDio.get(
        '${restApiUrl}labels',
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
          data: mockResponse,
          statusCode: 200,
          requestOptions: RequestOptions(path: '${restApiUrl}labels')));

      final result = await dataSource.getAllLabels();

      expect(result, isA<List<LabelsModel>>());
      expect(result.length, 2);
    });

    test('should throw a ServerException when the response is an error', () async {
      when(mockDio.get(
        '${restApiUrl}labels',
        options: anyNamed('options'),
      )).thenThrow(DioError(
          requestOptions: RequestOptions(path: '${restApiUrl}labels')));

      expect(dataSource.getAllLabels, throwsA(isA<ServerException>()));
    });
  });

  group('addTask', () {
    test('should return true when the task is added successfully', () async {
      final taskData = {
        "content": "Task 1",
        "description": "Description",
        "labels": ["Label1"],
        "priority": "High",
        "project_id": "2344765751",
        "due_string": "2024-12-31",
      };

      when(mockDio.post(
        '${restApiUrl}tasks',
        options: anyNamed('options'),
        data: taskData,
      )).thenAnswer((_) async => Response(
          data: {"status": "success"},
          statusCode: 200,
          requestOptions: RequestOptions(path: '${restApiUrl}tasks')));

      final result = await dataSource.addTask(
        taskName: "Task 1",
        des: "Description",
        dueDate: "2024-12-31",
        priority: "High",
        labels: ["Label1"],
      );

      expect(result, true);
    });

    test('should return false when the response status code is not 200', () async {
      when(mockDio.post(
        '${restApiUrl}tasks',
        options: anyNamed('options'),
        data: anyNamed('data'),
      )).thenAnswer((_) async => Response(
          statusCode: 400,
          requestOptions: RequestOptions(path: '${restApiUrl}tasks')));

      final result = await dataSource.addTask(
        taskName: "Task 1",
        des: "Description",
        dueDate: "2024-12-31",
        priority: "High",
        labels: ["Label1"],
      );

      expect(result, false);
    });

    test('should throw a ServerException when there is a DioError', () async {
      when(mockDio.post(
        '${restApiUrl}tasks',
        options: anyNamed('options'),
        data: anyNamed('data'),
      )).thenThrow(DioError(
          requestOptions: RequestOptions(path: '${restApiUrl}tasks')));

      expect(
        () => dataSource.addTask(
          taskName: "Task 1",
          des: "Description",
          dueDate: "2024-12-31",
          priority: "High",
          labels: ["Label1"],
        ),
        throwsA(isA<ServerException>()),
      );
    });
  });
}
