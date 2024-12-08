import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/material.dart';

Time timeOfDayToTime(TimeOfDay timeOfDay) {
  return Time(
    hour: timeOfDay.hour,
    minute: timeOfDay.minute,
    second: 0, // Defaulting to 0 seconds
  );
}
