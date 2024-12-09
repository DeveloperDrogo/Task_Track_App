import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_track_app/features/taskTrack/data/datasource/task_remote_data_source.dart';
import 'package:task_track_app/features/taskTrack/data/repository/task_repository_impl.dart';
import 'package:task_track_app/features/taskTrack/domain/repository/task_repository.dart';
import 'package:task_track_app/features/taskTrack/domain/usecase/get_all_labels_use_case.dart';
import 'package:task_track_app/features/taskTrack/domain/usecase/get_all_task_use_case.dart';
import 'package:task_track_app/features/taskTrack/domain/usecase/move_task_use_case.dart';
import 'package:task_track_app/features/taskTrack/presentation/bloc/task_bloc.dart';
import 'features/taskTrack/domain/usecase/add_task_use_case.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initTask();

  final Dio dio = Dio();
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  final apiToken = dotenv.get('API_TOKEN', fallback: '');
  final restApiUrl = dotenv.get('REST_API_URL', fallback: '');
  final syncApiUrl = dotenv.get('SYNC_API_URL', fallback: '');

  serviceLocator.registerLazySingleton(() => dio);
  serviceLocator.registerLazySingleton(() => prefs);
  serviceLocator.registerLazySingleton(() => apiToken);
  if (!serviceLocator.isRegistered<String>(instanceName: 'syncApiUrl')) {
    serviceLocator.registerLazySingleton<String>(() => syncApiUrl,
        instanceName: 'syncApiUrl');
  }
  if (!serviceLocator.isRegistered<String>(instanceName: 'restApiUrl')) {
    serviceLocator.registerLazySingleton<String>(() => restApiUrl,
        instanceName: 'restApiUrl');
  }
}

void _initTask() {
  //dataSource
  serviceLocator.registerFactory<TaskRemoteDataSource>(
    () => TaskRemoteDataSourceImpl(
      dio: serviceLocator<Dio>(), // Fetch Dio instance from serviceLocator
      apiToken: serviceLocator<String>(), // Fetch apiToken from serviceLocator
      restApiUrl: serviceLocator<String>(
          instanceName:
              'restApiUrl'), // Fetch restApiUrl from serviceLocator with instanceName
      syncApiUrl: serviceLocator<String>(
          instanceName:
              'syncApiUrl'), // Fetch syncApiUrl from serviceLocator with instanceName
    ),
  );

  //repo
  serviceLocator.registerFactory<TaskRepository>(
    () => TaskRepositoryImpl(
      taskRemoteDataSource: serviceLocator(),
    ),
  );

  //usecase
  serviceLocator.registerFactory(
    () => GetAllLabelsUseCase(
      taskRepository: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => AddTaskUseCase(
      taskRepository: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => GetAllTaskUseCase(
      taskRepository: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => MoveTaskUseCase(
      taskRepository: serviceLocator(),
    ),
  );

  //bloc
  serviceLocator.registerFactory(
    () => TaskBloc(
      moveTaskUseCase: serviceLocator(),
      getAllTaskUseCase: serviceLocator(),
      getAllLabelsUseCase: serviceLocator(),
      addTaskUseCase: serviceLocator()
    ),
  );
}
