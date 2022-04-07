import 'package:intl/intl.dart';

final DateFormat dateFormat = DateFormat('dd-MM-yyyy');
final DateFormat dateFormat2 = DateFormat('MMM dd, y');
final DateFormat dateFormatNeat = DateFormat('MMM d, y');
final DateFormat timeFormat = DateFormat('hh:mm a');

final DateFormat dateTimeFormat = DateFormat('d MMM, yyyy h:mm:ss a');

/// Returns the difference (in full days) between the provided date and today.
int calculateDifferenceOfDays(DateTime date) {
  DateTime now = DateTime.now();
  return DateTime(date.year, date.month, date.day)
      .difference(DateTime(now.year, now.month, now.day))
      .inDays;
}
