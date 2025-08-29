import 'package:assignment/providers/all_habit_list_provider.dart';
import 'package:assignment/providers/complete_list_provider.dart';
import 'package:assignment/providers/habit_details_specific_provider/week_days_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ActivityList extends ConsumerWidget {
  const ActivityList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allHabits = ref.watch(allhabitProvider);
    final weekDays = ref.watch(weekDatesProvider); // List<String> (yyyy-MM-dd)

    final activityItems = <Widget>[];
    final dateParser = DateFormat('yyyy-MM-dd');

    for (final habit in allHabits) {
      final completedDates = ref
          .read(completelistprovider)
          .getcompletehabitlist(habit.habit.id); // should be List<String>

      for (final dateStr in weekDays) {
        final date = dateParser.parse(dateStr);

        final isCompleted = completedDates.contains(dateStr);

        final status = isCompleted ? "Completed" : "Missed";
        final icon = isCompleted ? Icons.check_circle : Icons.cancel;
        final color = isCompleted
            ? const Color(0xFF00B894)
            : const Color(0xFFE17055);

        // Human-readable label
        final now = DateTime.now();
        String timeLabel;
        if (_isSameDay(date, now)) {
          timeLabel = "Today at ${DateFormat('h:mm a').format(date)}";
        } else if (_isSameDay(date, now.subtract(const Duration(days: 1)))) {
          timeLabel = "Yesterday at ${DateFormat('h:mm a').format(date)}";
        } else {
          final diff = now.difference(date).inDays;
          timeLabel = "$diff days ago";
        }

        activityItems.add(
          BuildActivityItem(
            status: status,
            time: timeLabel,
            icon: icon,
            color: color,
          ),
        );

        // ✅ Stop collecting once we have 4 items
        if (activityItems.length >= 4) break;
      }
      if (activityItems.length >= 4) break;
    }

    return Column(children: activityItems);
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

class BuildActivityItem extends StatelessWidget {
  final String status;
  final String time;
  final IconData icon;
  final Color color;

  const BuildActivityItem({
    super.key,
    required this.status,
    required this.time,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        status,
        style: TextStyle(fontWeight: FontWeight.bold, color: color),
      ),
      subtitle: Text(time),
    );
  }
}
