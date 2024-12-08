import 'package:intl/intl.dart';

String formatTimeTo12Hour(String time24Hour) {
  // Parse the time string to a DateTime object
  DateTime dateTime = DateFormat("HH:mm:ss").parse(time24Hour);
  
  // Format the DateTime object to 12-hour time with AM/PM
  return DateFormat("h:mm a").format(dateTime);
}