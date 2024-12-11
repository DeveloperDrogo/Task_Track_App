// ignore_for_file: deprecated_member_use

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:task_track_app/core/error/exception.dart';
import 'package:task_track_app/features/taskTrack/data/datasource/task_remote_data_source.dart';
import 'package:task_track_app/features/taskTrack/data/model/label_model.dart';
import 'package:task_track_app/features/taskTrack/data/model/task_model.dart';
import 'dio_mock.mocks.dart'; // Ensure the path is correct

void main() {
  late MockDio mockDio;
  late TaskRemoteDataSourceImpl dataSource;

  String restApiUrl = 'https://api.todoist.com/rest/v2/';
  String syncApiUrl = 'https://api.todoist.com/sync/v9/';
  String apiToken = '275d9ffa195a8351367369f78e03f6a49e5dba6d';

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
    test('should return a list of LabelsModel when the response is successful',
        () async {
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

    test('should throw a ServerException when the response is an error',
        () async {
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

    test('should return false when the response status code is not 200',
        () async {
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
      )).thenThrow(
          DioError(requestOptions: RequestOptions(path: '${restApiUrl}tasks')));

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

  group('getAllTask', () {
    test(
        'should return a sorted list of TaskModel when the response is successful',
        () async {
      final mockResponse = [
        {
          "id": "1",
          "project_id": "1",
          "due": {
            "date": "2024-12-11",
            "string": "2024-12-11",
            "lang": "en",
            "is_recurring": false
          },
          "content": "task 1",
          "description": "task 1 description",
          "priority": 4,
          "labels": ["APP"],
          "creator_id": 51834956,
          "created_at": "2024-12-11T13:31:59.760951Z",
          "url": "https://app.todoist.com/app/task/8670955345"
        }
      ];

      when(mockDio.get(
        '${restApiUrl}tasks',
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
          data: mockResponse,
          statusCode: 200,
          requestOptions: RequestOptions(path: '${restApiUrl}tasks')));

      final dataSource = TaskRemoteDataSourceImpl(
          dio: mockDio,
          apiToken: apiToken,
          restApiUrl: restApiUrl,
          syncApiUrl: syncApiUrl);
      final result = await dataSource.getAllTask();

      expect(result, isA<List<TaskModel>>());
      expect(result.length, 1);

      // Check if TaskModel is correctly created from map
      final taskModel = result[0];
      expect(taskModel.taskID, '1');
    });

    test('should throw ServerException when the response data is null',
        () async {
      // Arrange
      when(mockDio.get(
        '${restApiUrl}tasks',
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
          data: null,
          statusCode: 200,
          requestOptions: RequestOptions(path: '${restApiUrl}tasks')));

      // Act & Assert
      expect(() => dataSource.getAllTask(), throwsA(isA<ServerException>()));
    });

    test('should throw ServerException when created_at is missing', () async {
      // Arrange
      final mockResponse = [
        {"id": "1", "content": "Task1"}, // Missing created_at
        {"id": "2", "created_at": "2024-12-02T12:00:00", "content": "Task2"}
      ];

      when(mockDio.get(
        '${restApiUrl}tasks',
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
          data: mockResponse,
          statusCode: 200,
          requestOptions: RequestOptions(path: '${restApiUrl}tasks')));

      final dataSource = TaskRemoteDataSourceImpl(
          dio: mockDio,
          apiToken: apiToken,
          restApiUrl: restApiUrl,
          syncApiUrl: syncApiUrl);

      // Act & Assert
      expect(() => dataSource.getAllTask(), throwsA(isA<ServerException>()));
    });

    test('should throw ServerException when Dio throws an error', () async {
      // Arrange
      when(mockDio.get(
        '${restApiUrl}tasks',
        options: anyNamed('options'),
      )).thenThrow(DioError(
          requestOptions: RequestOptions(path: '${restApiUrl}tasks'),
          error: "Network error"));

      // Act & Assert
      expect(() => dataSource.getAllTask(), throwsA(isA<ServerException>()));
    });
  });

  group('moveTask', () {
    test('should return true when the task is moved successfully', () async {
      when(mockDio.post(
        '${syncApiUrl}sync',
        options: anyNamed('options'),
        data: anyNamed('data'),
      )).thenAnswer((_) async => Response(
          data: {"status": "success"},
          statusCode: 200,
          requestOptions: RequestOptions(path: '${syncApiUrl}sync')));

      final result = await dataSource.moveTask(taskId: "1", projectId: "123");

      expect(result, true);
    });

    test('should return false when the response status code is not 200',
        () async {
      when(mockDio.post(
        '${syncApiUrl}sync',
        options: anyNamed('options'),
        data: anyNamed('data'),
      )).thenAnswer((_) async => Response(
          statusCode: 400,
          requestOptions: RequestOptions(path: '${syncApiUrl}sync')));

      final result = await dataSource.moveTask(taskId: "1", projectId: "123");

      expect(result, false);
    });

    test('should throw a ServerException when there is a DioError', () async {
      when(mockDio.post(
        '${syncApiUrl}sync',
        options: anyNamed('options'),
        data: anyNamed('data'),
      )).thenThrow(
          DioError(requestOptions: RequestOptions(path: '${syncApiUrl}sync')));

      expect(
        () => dataSource.moveTask(taskId: "1", projectId: "123"),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('deleteTask', () {
    test('should return true when the task is deleted successfully', () async {
      when(mockDio.delete(
        '${restApiUrl}tasks/1',
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
          statusCode: 204,
          requestOptions: RequestOptions(path: '${restApiUrl}tasks/1')));

      final result = await dataSource.deleteTask(taskId: "1");

      expect(result, true);
    });

  });

}
