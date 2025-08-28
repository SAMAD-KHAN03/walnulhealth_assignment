import 'package:assignment/providers/local_storage_habits_list_provider.dart';
import 'package:hive/hive.dart';
import '../models/habit.dart';

class LocalStore {
  static const habitsBox = 'habits';
  static const pendingBox = 'pending_ops';

  // List<Habit > _habits = []; // internal cache of habits

  Future<void> saveHabits(List<Habit> habits) async {
    final box = Hive.box(habitsBox);
    await box.put('list', habits.map((h) => h.toJson()).toList());
    HabitCache.habits = habits; // update internal cache
  }

  /// Save a single habit and update cache
  Future<void> saveHabit(Habit habit) async {
    HabitCache.habits.add(habit); // add in-memory
    print(
      "after adding new habit the size of habits cache is ${HabitCache.habits.length}",
    );
    await saveHabits(HabitCache.habits); // persist all
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
