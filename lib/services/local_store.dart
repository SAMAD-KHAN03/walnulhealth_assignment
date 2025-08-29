import 'package:assignment/providers/local_storage_specific_providers/local_storage_habits_list_provider.dart';
import 'package:hive/hive.dart';
import '../models/habit.dart';

class LocalStore {
  static const habitsBox = 'habits';
  static const pendingBox = 'pending_ops';

  Future<void> saveHabits(List<Habit> habits) async {
    try {
      final box = await Hive.openBox(habitsBox);
      await box.put('list', habits.map((h) => h.toJson()).toList());
      HabitCache.habits = habits;
      print("✅ Saved ${habits.length} habits to local store");
    } catch (e, st) {
      print("❌ saveHabits failed: $e");
      print(st);
      rethrow;
    }
  }

  Future<void> saveHabit(Habit habit) async {
    try {
      final index = HabitCache.habits.indexWhere((h) => h.id == habit.id);

      if (index >= 0) {
        HabitCache.habits[index] = habit;
        print("🔄 Updated existing habit with id ${habit.id}");
      } else {
        HabitCache.habits.add(habit);
        print("➕ Added new habit with id ${habit.id}");
      }

      print("Current habits cache size: ${HabitCache.habits.length}");
      await saveHabits(HabitCache.habits);
    } catch (e, st) {
      print("❌ saveHabit failed for id=${habit.id}: $e");
      print(st);
      rethrow;
    }
  }

  List<Habit> getHabits() {
    try {
      final box = Hive.box(habitsBox);
      final data = (box.get('list') as List?) ?? [];
      HabitCache.habits = data
          .map((e) => Habit.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      print("✅ Loaded ${HabitCache.habits.length} habits from local store");
      return HabitCache.habits;
    } catch (e, st) {
      print("❌ getHabits failed: $e");
      print(st);
      return []; // fail-safe fallback
    }
  }

  List<Habit> get cachedHabits => List.unmodifiable(HabitCache.habits);

  Future<void> queueOperation(Map<String, dynamic> op) async {
    try {
      final box = await Hive.openBox(pendingBox);
      final list = (box.get('ops') as List?) ?? [];
      list.add(op);
      await box.put('ops', list);
      print("📥 Queued operation → $op");
    } catch (e, st) {
      print("❌ queueOperation failed: $e");
      print(st);
      rethrow;
    }
  }

  List<Map<String, dynamic>> getQueuedOps() {
    try {
      final box = Hive.box(pendingBox);
      final list = (box.get('ops') as List?) ?? [];
      final ops = list.map((e) => Map<String, dynamic>.from(e)).toList();
      print("📤 Retrieved ${ops.length} queued operations");
      return ops;
    } catch (e, st) {
      print("❌ getQueuedOps failed: $e");
      print(st);
      return [];
    }
  }

  Future<void> clearQueue() async {
    try {
      final box = await Hive.openBox(pendingBox);
      await box.put('ops', []);
      print("🧹 Cleared queued operations");
    } catch (e, st) {
      print("❌ clearQueue failed: $e");
      print(st);
      rethrow;
    }
  }
}
