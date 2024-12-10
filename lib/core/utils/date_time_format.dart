
import 'package:intl/intl.dart';

String formatDateTime(String dateTimeString) {

  print(dateTimeString);
  // Parse the date-time string to a DateTime object including milliseconds
  DateTime dateTime = DateFormat("yyyy-MM-dd HH:mm:ss.SSSSSS").parse(dateTimeString);
  
  // Format the DateTime object to the desired format
  return DateFormat("d MMM, yyyy h:mm a").format(dateTime);
}
