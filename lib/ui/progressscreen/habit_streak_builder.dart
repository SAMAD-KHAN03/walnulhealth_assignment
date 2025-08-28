import 'package:assignment/providers/all_habit_list_provider.dart';
import 'package:assignment/providers/complete_list_provider.dart';
import 'package:assignment/ui/progressscreen/streak_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Habit Streak Builder Utility Class
class HabitStreakBuilder {
  static List<Widget> buildHabitStreaks(WidgetRef ref, int month, int year) {
    final allHabitListProvider = ref.read(allhabitProvider);
    List<Widget> habitWidgets = [];

    for (final habitData in allHabitListProvider) {
      final completed = ref
          .read(completelistprovider)
          .getcompletehabitlist(habitData.habit.id);

      final missed = ref
          .read(completelistprovider)
          .getmissinghabtilist(habitData.habit.id);

      if (_hasEntriesInMonthYear(completed, missed, month, year)) {
        habitWidgets.add(
          StreakItem(
            habitName: habitData.habit.title,
            streakDays: habitData.habit.streak,
            color: habitData.color,
          ),
        );
      }
    }

    return habitWidgets;
  }

  static bool _hasEntriesInMonthYear(
    List<String> completed,
    List<String> missed,
    int month,
    int year,
  ) {
    return _checkDatesForMonthYear(completed, month, year) ||
           _checkDatesForMonthYear(missed, month, year);
  }

  static bool _checkDatesForMonthYear(
    List<String> dates,
    int month,
    int year,
  ) {
    for (String dateString in dates) {
      try {
        DateTime date = DateTime.parse(dateString);
        if (date.month == month && date.year == year) {
          return true;
        }
      } catch (e) {
        continue;
      }
    }
    return false;
  }
}
