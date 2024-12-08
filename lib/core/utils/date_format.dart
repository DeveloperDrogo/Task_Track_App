import 'package:intl/intl.dart';

String formatDateDMMMYYYY(DateTime dateTime) {
  return DateFormat("d MMM, yyyy").format(dateTime);
}
