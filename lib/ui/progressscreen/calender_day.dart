import 'package:assignment/providers/progress_screen_specific_providers/selected_date_provider.dart';
import 'package:assignment/ui/progressscreen/task_completion_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

// Individual Calendar Day Component
class CalendarDay extends ConsumerWidget {
  final int dayIndex;

  const CalendarDay({super.key, required this.dayIndex});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final day = dayIndex + 1;

    if (day > 31) {
      return const SizedBox.shrink();
    }

    final dayDate = DateTime(selectedDate.year, selectedDate.month, day);
    final dayDateString = DateFormat('yyyy-MM-dd').format(dayDate);
    final isCompleted = TaskCompletionChecker.isTaskCompleted(
      ref,
      dayDateString,
    );
    final isToday = _isToday(dayDate);

    return Container(
      decoration: BoxDecoration(
        color: _getDayColor(isCompleted),
        borderRadius: BorderRadius.circular(8),
        border: isToday
            ? Border.all(color: const Color(0xFF6C5CE7), width: 2)
            : null,
      ),
      child: Center(
        child: Text(
          '$day',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isCompleted ? Colors.white : const Color(0xFF636E72),
          ),
        ),
      ),
    );
  }

  bool _isToday(DateTime dayDate) {
    final today = DateTime.now();
    return dayDate.day == today.day &&
        dayDate.month == today.month &&
        dayDate.year == today.year;
  }

  Color _getDayColor(bool isCompleted) {
    if (isCompleted) return const Color(0xFF00B894);
    return const Color(0xFFE17055);
  }
}
