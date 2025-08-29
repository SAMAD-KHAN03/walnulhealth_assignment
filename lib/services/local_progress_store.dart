import 'package:assignment/models/habit.dart';
import 'package:assignment/providers/all_habit_list_provider.dart';
import 'package:assignment/providers/complete_list_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class ProgressStore {
  static const progressbox = 'progress';

  Future<void> saveUpdateProgress(int id, WidgetRef ref) async {
    try {
      final box = await Hive.openBox(progressbox);

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

      final updated = {'completed': completed, 'missed': missed};

      await box.put(id, updated);
      print("✅ Progress updated for habit $id → $updated");
    } catch (e, st) {
      print("❌ saveUpdateProgress failed for id=$id: $e");
      print(st);
      rethrow;
    }
  }

  /// Update progress for a single habit
  Future<void> updateDailyProgress(Habit habit, WidgetRef ref) async {
    try {
      final box = await Hive.openBox(progressbox);

      final completed = ref
          .read(completelistprovider)
          .getcompletehabitlist(habit.id);
      final missed = ref
          .read(completelistprovider)
          .getmissinghabtilist(habit.id);

      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

      if (!completed.contains(today) && !missed.contains(today)) {
        missed.add(today);
      }

      await box.put(habit.id, {"completed": completed, "missed": missed});
      print("✅ Daily progress updated for habit ${habit.id}");
    } catch (e, st) {
      print("❌ updateDailyProgress failed for habit=${habit.id}: $e");
      print(st);
      rethrow;
    }
  }

  /// Update progress for all habits
  Future<void> updateAllHabits(WidgetRef ref) async {
    try {
      print("inside the updateAllHabits method");
      final habits = ref.read(allhabitProvider);

      print("the length of all habits array = ${habits.length}");
      for (final habit in habits) {
        await updateDailyProgress(habit.habit, ref);
      }
      print("✅ updateAllHabits completed");
    } catch (e, st) {
      print("❌ updateAllHabits failed: $e");
      print(st);
      rethrow;
    }
  }
}
