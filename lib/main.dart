import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:task_track_app/core/navigation/app_routes.dart';
import 'package:task_track_app/core/storage/shared_prefs.dart';
import 'package:task_track_app/core/theme/adaptive_theme.dart';
import 'package:task_track_app/features/taskTrack/presentation/screens/task.dart';

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
  await SharedPrefs().init();
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  // Listen to notification actions


  runApp( MyApp(
      savedThemeMode: savedThemeMode,
    ));
}

class MyApp extends StatefulWidget {
  final AdaptiveThemeMode? savedThemeMode;
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
              title: SharedPrefs().institutionName,
              routes: AppRoutes.routes,
              theme: theme,
              debugShowCheckedModeBanner: false,
              home: const TaskTrackPage()
            ));
  }
}