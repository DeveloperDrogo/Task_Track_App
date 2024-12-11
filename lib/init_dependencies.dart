import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_track_app/core/network/connection_checker.dart';
import 'package:task_track_app/features/comment/data/datasource/comments_remote_data_source.dart';
import 'package:task_track_app/features/comment/data/repository/comment_repository_impl.dart';
import 'package:task_track_app/features/comment/domain/reposiotry/comments_repository.dart';
import 'package:task_track_app/features/comment/domain/usecase/add_new_comment_use_case.dart';
import 'package:task_track_app/features/comment/domain/usecase/delete_comment_use_case.dart';
import 'package:task_track_app/features/comment/presentation/bloc/comment_bloc.dart';
import 'package:task_track_app/features/taskTrack/data/datasource/task_local_data_source.dart';
import 'package:task_track_app/features/taskTrack/data/datasource/task_remote_data_source.dart';
import 'package:task_track_app/features/taskTrack/data/repository/task_repository_impl.dart';
import 'package:task_track_app/features/taskTrack/domain/repository/task_repository.dart';
import 'package:task_track_app/features/taskTrack/domain/usecase/get_all_labels_use_case.dart';
import 'package:task_track_app/features/taskTrack/domain/usecase/get_all_task_use_case.dart';
import 'package:task_track_app/features/taskTrack/domain/usecase/move_task_use_case.dart';
import 'package:task_track_app/features/taskTrack/domain/usecase/update_task.dart';
import 'package:task_track_app/features/taskTrack/presentation/bloc/task_bloc.dart';
import 'features/comment/domain/usecase/get_all_comments_use_case.dart';
import 'features/taskTrack/domain/usecase/add_task_use_case.dart';
import 'features/taskTrack/domain/usecase/delete_task_use_case.dart';
import 'features/taskTrack/domain/usecase/get_selected_task_info_use_case.dart';
import 'package:path_provider/path_provider.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
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



  Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;
  serviceLocator.registerLazySingleton(() => Hive.box(name: 'blogs'));

  serviceLocator.registerFactory(
    () => InternetConnection(),
  );

  serviceLocator.registerFactory<ConnectionChecker>(
    () => ConnectionCheckerImpl(
      serviceLocator(),
    ),
  );

  _initTask();
  _initComments();
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

  serviceLocator.registerFactory<TaskLocalDataSource>(
    () => TaskLocalDataSourceImpl(serviceLocator()),
  );

  //repo
  serviceLocator.registerFactory<TaskRepository>(
    () => TaskRepositoryImpl(
      connectionChecker: serviceLocator(),
      taskLocalDataSource: serviceLocator(),
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

  serviceLocator.registerFactory(
    () => DeleteTaskUseCase(
      taskRepository: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => GetSelectedTaskUseCase(
      taskRepository: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => UpdateTaskUseCase(
      taskRepository: serviceLocator(),
    ),
  );

  //bloc
  serviceLocator.registerFactory(
    () => TaskBloc(
        updateTaskUseCase: serviceLocator(),
        getSelectedTaskUseCase: serviceLocator(),
        deleteTaskUseCase: serviceLocator(),
        moveTaskUseCase: serviceLocator(),
        getAllTaskUseCase: serviceLocator(),
        getAllLabelsUseCase: serviceLocator(),
        addTaskUseCase: serviceLocator()),
  );
}

void _initComments() {
  serviceLocator.registerFactory<CommentsRemoteDataSource>(
    () => CommentsRemoteDataSourceImpl(
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

  serviceLocator.registerFactory<CommnentsRepository>(
    () => CommnentsRepositoryImpl(commentsRemoteDataSource: serviceLocator()),
  );

  serviceLocator.registerFactory(
    () => GetAllCommentsUseCase(commnentsRepository: serviceLocator()),
  );

  serviceLocator.registerFactory(
    () => AddNewCommentUseCase(commnentsRepository: serviceLocator()),
  );
  serviceLocator.registerFactory(
    () => DeleteCommentUsecase(commnentsRepository: serviceLocator()),
  );

  serviceLocator.registerFactory(
    () => CommentBloc(
      deleteCommentUsecase: serviceLocator(),
      getAllCommentsUseCase: serviceLocator(),
      addNewCommentUseCase: serviceLocator(),
    ),
  );
}
