import 'package:assignment/models/habit.dart';
import 'package:assignment/providers/all_habit_list_provider.dart';
import 'package:assignment/providers/complete_list_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class ProgressStore {
  static const progressbox = 'progress';

  Future<void> saveUpdateProgress(int id, WidgetRef ref) async {
    final box = Hive.box(progressbox);

    // 🔹 Always use yyyy-MM-dd format for consistency
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final completed = ref.read(completelistprovider).getcompletehabitlist(id);
    final missed = ref.read(completelistprovider).getmissinghabtilist(id);

    if (missed.contains(today)) {
      // Switch today's status → from missed → completed
      missed.remove(today);
      if (!completed.contains(today)) {
        completed.add(today);
      }
    } else if (!completed.contains(today)) {
      // Edge case: if today not in either, mark as completed
      completed.add(today);
    }

    // Save back updated record
    final updated = {'completed': completed, 'missed': missed};

    await box.put(id, updated);
    print("✅ Progress updated for habit $id → $updated");
  }

  /// Update progress for a single habit
  /// Ensures that today's date is in missed if not already marked completed.
  Future<void> updateDailyProgress(Habit habit, WidgetRef ref) async {
    final box = await Hive.openBox(progressbox);
    final completed = ref
        .read(completelistprovider)
        .getcompletehabitlist(habit.id);
    final missed = ref.read(completelistprovider).getmissinghabtilist(habit.id);

    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // ✅ If today is neither completed nor missed → mark as missed
    if (!completed.contains(today) && !missed.contains(today)) {
      missed.add(today);
    }

    await box.put(habit.id, {"completed": completed, "missed": missed});
  }

  /// Update progress for all habits
  Future<void> updateAllHabits(WidgetRef ref) async {
    final habits = ref.read(allhabitProvider);
    for (final habit in habits) {
      await updateDailyProgress(habit.habit, ref);
    }
  }
}
