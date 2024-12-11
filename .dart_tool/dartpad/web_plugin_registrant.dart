// Flutter web plugin registrant file.
//
// Generated file. Do not edit.
//

// @dart = 2.13
// ignore_for_file: type=lint

import 'package:awesome_notifications/awesome_notifications_web.dart';
import 'package:connectivity_plus/src/connectivity_plus_web.dart';
import 'package:rive_common/rive_web.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void registerPlugins([final Registrar? pluginRegistrar]) {
  final Registrar registrar = pluginRegistrar ?? webPluginRegistrar;
  AwesomeNotificationsWeb.registerWith(registrar);
  ConnectivityPlusWebPlugin.registerWith(registrar);
  RivePlugin.registerWith(registrar);
  SharedPreferencesPlugin.registerWith(registrar);
  registrar.registerMessageHandler();
}
