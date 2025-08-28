import 'package:assignment/providers/local_storage_habits_list_provider.dart';
import 'package:hive/hive.dart';
import '../models/habit.dart';

class LocalStore {
  static const habitsBox = 'habits';
  static const pendingBox = 'pending_ops';

  Future<void> saveHabits(List<Habit> habits) async {
    final box = Hive.box(habitsBox);
    await box.put('list', habits.map((h) => h.toJson()).toList());
    HabitCache.habits = habits; // update internal cache
  }

  /// Save a single habit and update cache (add or update if exists)
  Future<void> saveHabit(Habit habit) async {
    // Find index of existing habit with the same id
    final index = HabitCache.habits.indexWhere((h) => h.id == habit.id);

    if (index >= 0) {
      // Habit exists → update
      HabitCache.habits[index] = habit;
      print(" Updated existing habit with id ${habit.id}");
    } else {
      // Habit doesn't exist → add
      HabitCache.habits.add(habit);
      print(" Added new habit with id ${habit.id}");
    }

    print("Current habits cache size: ${HabitCache.habits.length}");

    // Persist updated list
    await saveHabits(HabitCache.habits);
  }

  List<Habit> getHabits() {
    final box = Hive.box(habitsBox);
    final data = (box.get('list') as List?) ?? [];
    HabitCache.habits = data
        .map((e) => Habit.fromJson(Map<String, dynamic>.from(e)))
        .toList();
    return HabitCache.habits;
  }

  /// Expose cached habits (fast)
  List<Habit> get cachedHabits => List.unmodifiable(HabitCache.habits);

  Future<void> queueOperation(Map<String, dynamic> op) async {
    final box = Hive.box(pendingBox);
    final list = (box.get('ops') as List?) ?? [];
    list.add(op);
    await box.put('ops', list);
  }

  List<Map<String, dynamic>> getQueuedOps() {
    final box = Hive.box(pendingBox);
    final list = (box.get('ops') as List?) ?? [];
    return list.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  Future<void> clearQueue() async {
    final box = Hive.box(pendingBox);
    await box.put('ops', []);
  }
}
