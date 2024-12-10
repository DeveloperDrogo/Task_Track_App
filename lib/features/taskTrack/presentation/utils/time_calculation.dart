import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ProgressTimeCalculation {

  static void storeProgressDateTime(
      {required String taskId, required String projectId}) {
    if (projectId == '2344765751') {
      deleteInprogressDateTime(taskId);
      deleteCompletedProgressDateTime(taskId);
    } else if (projectId == '2344851608') {
      deleteCompletedProgressDateTime(taskId);
      deleteInprogressDateTime(taskId);
      saveInprogressDateTime(taskId, DateTime.now().toString());
    } else {
      saveCompletedDateTime(taskId, DateTime.now().toString());
    }
  }

  static Future<void> saveInprogressDateTime(
      String taskId, String updatedTime) async {
    final prefs = await SharedPreferences.getInstance();

    // Retrieve the current map or initialize an empty one
    final updatedTimesString = prefs.getString('in_progress_times') ?? '{}';
    final Map<String, String> updatedTimes =
        Map<String, String>.from(json.decode(updatedTimesString));

    // Check if the taskId already exists
    if (updatedTimes.containsKey(taskId)) {
      // If it exists, ignore the update
      return;
    }

    // Add the updated time for the task
    updatedTimes[taskId] = updatedTime;

    // Save the updated map back to SharedPreferences
    await prefs.setString('in_progress_times', json.encode(updatedTimes));
  }

  static Future<void> saveCompletedDateTime(
      String taskId, String updatedTime) async {
    final prefs = await SharedPreferences.getInstance();

    // Retrieve the current map or initialize an empty one
    final updatedTimesString = prefs.getString('completed_times') ?? '{}';
    final Map<String, String> updatedTimes =
        Map<String, String>.from(json.decode(updatedTimesString));

    // Check if the taskId already exists
    if (updatedTimes.containsKey(taskId)) {
      // If it exists, ignore the update
      return;
    }

    // Add the updated time for the task
    updatedTimes[taskId] = updatedTime;

    // Save the updated map back to SharedPreferences
    await prefs.setString('completed_times', json.encode(updatedTimes));
  }

  static Future<void> deleteInprogressDateTime(String taskId) async {
    final prefs = await SharedPreferences.getInstance();

    // Retrieve the current map or initialize an empty one
    final updatedTimesString = prefs.getString('in_progress_times') ?? '{}';
    final Map<String, String> updatedTimes =
        Map<String, String>.from(json.decode(updatedTimesString));

    // Check if the taskId exists in the map
    if (updatedTimes.containsKey(taskId)) {
      // Remove the taskId from the map
      updatedTimes.remove(taskId);

      // Save the updated map back to SharedPreferences
      await prefs.setString('in_progress_times', json.encode(updatedTimes));
    }
    // If the taskId does not exist, do nothing
  }

  static Future<void> deleteCompletedProgressDateTime(String taskId) async {
    final prefs = await SharedPreferences.getInstance();

    // Retrieve the current map or initialize an empty one
    final updatedTimesString = prefs.getString('completed_times') ?? '{}';
    final Map<String, String> updatedTimes =
        Map<String, String>.from(json.decode(updatedTimesString));

    // Check if the taskId exists in the map
    if (updatedTimes.containsKey(taskId)) {
      // Remove the taskId from the map
      updatedTimes.remove(taskId);

      // Save the updated map back to SharedPreferences
      await prefs.setString('completed_times', json.encode(updatedTimes));
    }
    // If the taskId does not exist, do nothing
  }
  static Future<String> getCompletedDateTime(String taskId) async {
   
    final prefs = await SharedPreferences.getInstance();

    // Retrieve the stored map
    final updatedTimesString = prefs.getString('completed_times') ?? '{}';
    final Map<String, String> updatedTimes =
        Map<String, String>.from(json.decode(updatedTimesString));
   
    // Return the updated time for the task, if it exists
    return "${updatedTimes[taskId.toString()]}";
  }

  static Future<String> calculateTaskDuration(String taskId) async {
    final prefs = await SharedPreferences.getInstance();

    // Retrieve in-progress times and completed times maps
    final inProgressString = prefs.getString('in_progress_times') ?? '{}';
    final completedString = prefs.getString('completed_times') ?? '{}';

    final Map<String, String> inProgressTimes =
        Map<String, String>.from(json.decode(inProgressString));
    final Map<String, String> completedTimes =
        Map<String, String>.from(json.decode(completedString));

    // Check if taskId exists in both maps
    if (!inProgressTimes.containsKey(taskId) ||
        !completedTimes.containsKey(taskId)) {
      return "Task times not found.";
    }

    // Parse the datetime strings into DateTime objects
    final inProgressDateTime = DateTime.parse(inProgressTimes[taskId]!);
    final completedDateTime = DateTime.parse(completedTimes[taskId]!);

    // Calculate the difference
    final duration = completedDateTime.difference(inProgressDateTime);

    // Format the duration into a human-readable string
    if (duration.inSeconds < 60) {
      return "${duration.inSeconds} sec";
    } else if (duration.inMinutes < 60) {
      return "${duration.inMinutes} mins";
    } else if (duration.inHours < 24) {
      return "${duration.inHours} hours ${duration.inMinutes % 60} mins";
    } else {
      final days = duration.inDays;
      final hours = duration.inHours % 24;
      return "$days days $hours hours";
    }
  }
}
