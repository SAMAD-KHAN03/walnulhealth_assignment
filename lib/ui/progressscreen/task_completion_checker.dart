import 'package:assignment/providers/all_habit_list_provider.dart';
import 'package:assignment/providers/complete_list_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Task Completion Utility Class
class TaskCompletionChecker {
  static bool isTaskCompleted(WidgetRef ref, String dateToCheck) {
    final allhabits = ref.read(allhabitProvider);

    if (allhabits.isEmpty) return false;

    for (final habit in allhabits) {
      final completed = ref
          .read(completelistprovider)
          .getcompletehabitlist(habit.habit.id);

      if (completed.contains(dateToCheck)) {
        return true;
      }
    }
    return false;
  }
}