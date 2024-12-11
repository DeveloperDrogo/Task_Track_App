import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService{

  final _instance = FirebaseAnalytics.instance;

  Future<void> addTask() async{
    await _instance.logEvent(name: "add_task");
  }

  Future<void> editTask() async{
    await _instance.logEvent(name: "edit_task");
  }

  Future<void> deleteTask() async{
    await _instance.logEvent(name: "delete_task");
  }

  Future<void> progressChanger() async{
    await _instance.logEvent(name: "progress_change");
  }

  Future<void> commentTask() async{
    await _instance.logEvent(name: "commnent_Task");
  }
  

}