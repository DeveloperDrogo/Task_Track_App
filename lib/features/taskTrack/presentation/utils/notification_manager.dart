import 'package:intl/intl.dart';
import 'package:task_track_app/notification_service.dart';

class NotificationManager {
  static final Set<String> _scheduledTasks = {};

  static notificationDateFormat(String inputDateTime) {
    // Parse the input string to a DateTime object
    DateTime dateTime = DateFormat("yyyy-MM-dd HH:mm").parse(inputDateTime);
    // Format the DateTime object to "d MMM, yyyy"
    return DateFormat("d MMM, yyyy").format(dateTime);
  }

  static Future<void> scheduleNotifications(
      String scheduleDateTimeStr, String taskName) async {
    // Combine scheduleDateTimeStr and taskName as a unique identifier
    String taskIdentifier = "$scheduleDateTimeStr|$taskName";

    // Check if this task has already been scheduled
    if (_scheduledTasks.contains(taskIdentifier)) {
      //debugPrint("Task already scheduled: $taskIdentifier");
      return;
    }

    // Parse the string to DateTime
    DateTime scheduleDateTime =
        DateFormat("yyyy-MM-dd HH:mm").parse(scheduleDateTimeStr);

    // Get the current time
    DateTime currentTime = DateTime.now();

    // Calculate the difference in seconds
    Duration difference = scheduleDateTime.difference(currentTime);

    // If the target time is in the past, handle this scenario
    if (difference.isNegative) {
     // debugPrint("Scheduled time is in the past: $scheduleDateTimeStr");
      return;
    }

    // Calculate the interval
    int interval = difference.inSeconds;

    // Schedule the notification
    await NotificationService.showNotification(
      title: "Task Reminder",
      body:
          "Your task $taskName is scheduled at ${notificationDateFormat(scheduleDateTimeStr)} as a reminder.",
      scheduled: true,
      interval: interval,
    );

    // Add the task to the set after successful scheduling
    _scheduledTasks.add(taskIdentifier);
   // debugPrint("Task scheduled: $taskIdentifier");
  }

  static moveNotification(
      {required String taskName, required String projectId}) async {
    String movedTo = projectId == '2344765751'
        ? 'Not Started'
        : projectId == '2344851608'
            ? 'In Progress'
            : 'Completed';

    String body;

    if (movedTo == 'Not Started') {
      body =
          "Your task $taskName is now in Not Started. Plan your work and get started soon!";
    } else if (movedTo == 'In Progress') {
      body =
          "Your task $taskName has been moved to In Progress. Keep up the good work!";
    } else if (movedTo == 'Completed') {
      body =
          "Your task $taskName has been marked as Completed. Great job finishing it!";
    } else {
      body = "Your task $taskName has been updated.";
    }

    await NotificationService.showNotification(
      title: "Task Updated: $movedTo",
      body: body,
    );
  }
}
