import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:task_track_app/core/navigation/app_routes.dart';
import 'package:task_track_app/core/theme/adaptive_theme.dart';
import 'package:task_track_app/features/comment/presentation/bloc/comment_bloc.dart';
import 'package:task_track_app/features/taskTrack/presentation/bloc/task_bloc.dart';
import 'package:task_track_app/features/taskTrack/presentation/screens/task.dart';
import 'package:task_track_app/firebase_options.dart';
import 'package:task_track_app/init_dependencies.dart';
import 'package:task_track_app/notification_service.dart';

extension StringExtension on String {
  String capitalizeFirstLetter() {
    if (isEmpty) {
      return this;
    }
    return this[0].toUpperCase() + substring(1);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: ".env");
  await NotificationService.initializeNotification();
  await initDependencies();
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  // Listen to notification actions

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (_) => serviceLocator<TaskBloc>(),
      ),
      BlocProvider(
        create: (_) => serviceLocator<CommentBloc>(),
      ),
    ],
    child: MyApp(
      savedThemeMode: savedThemeMode,
    ),
  ));
}

class MyApp extends StatefulWidget {
  final AdaptiveThemeMode? savedThemeMode;
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  const MyApp({super.key, this.savedThemeMode});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String institutionId = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
        light: AdaptiveThemeConfig.lightTheme,
        dark: AdaptiveThemeConfig.darkTheme,
        initial: widget.savedThemeMode ?? AdaptiveThemeConfig.initialThemeMode,
        builder: (theme, darkTheme) => MaterialApp(
            title: 'Task Vision',
            routes: AppRoutes.routes,
            theme: theme,
            debugShowCheckedModeBanner: false,
            home: const TaskTrackPage()));
  }
}
