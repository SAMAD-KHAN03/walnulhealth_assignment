import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

/* Riverpod provider that returns the current week’s dates already formatted with DateFormat("yyyyy.MMMM.dd").example

02025.August.25
02025.August.26
02025.August.27
02025.August.28
02025.August.29
02025.August.30
02025.August.31
 */
final weekDatesProvider = Provider<List<String>>((ref) {
  final now = DateTime.now();

  // Get Monday
  final monday = now.subtract(Duration(days: now.weekday - 1));

  // Formatter
  final formatter = DateFormat('yyyy-MM-dd');

  // Build list Monday → Sunday with formatted strings
  return List.generate(
    7,
    (index) => formatter.format(monday.add(Duration(days: index))),
  );
});
