import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String mergeDateTime(String scheduleDate, TimeOfDay scheduleTime) {

  // if(scheduleDate=='' ){
  //   return null;
  // }

  // Parse the date
  DateTime date = DateFormat("yyyy-MM-dd").parse(scheduleDate);

  // Create a DateTime object using the date and the given time
  DateTime dateTime = DateTime(
    date.year,
    date.month,
    date.day,
    scheduleTime.hour,
    scheduleTime.minute,
  );

  // Return the formatted DateTime string
  return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
}