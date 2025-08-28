import 'package:assignment/models/habitui.dart';
import 'package:assignment/providers/habit_service_repo_provider.dart';
import 'package:assignment/providers/local_store_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AllHabitListProvider extends StateNotifier<List<HabitUI>> {
  AllHabitListProvider() : super([]);

  void fetchHabits(WidgetRef ref) async {
    final localStore = ref.read(localStoreProvider);
    final repo = ref.read(habitRepoProvider);

    // ✅ Step 1: Load from local storage
    final localHabits = localStore.getHabits();
    for (final habit in localHabits) {
      print(" habit is ${habit.toString()}");
    }
    if (localHabits.isNotEmpty) {
      state = localHabits.map((habit) => mapHabitToUI(habit)).toList();
    }
    print("after fetching local habits the state length is ${state.length}");
    // ✅ Step 2: Fetch from backend
    try {
      final remoteHabits = await repo.fetchHabits();

      if (remoteHabits.isNotEmpty) {
        final remoteUI = remoteHabits.map((h) => mapHabitToUI(h)).toList();

        final merged = [
          ...state, // always keep existing local
          ...remoteUI.where(
            (remote) =>
                !state.any((local) => local.habit.id == remote.habit.id),
          ),
        ];

        state = merged;
        await localStore.saveHabits(merged.map((ui) => ui.habit).toList());
      }
    } catch (e) {
      debugPrint("⚠️ Failed to fetch remote habits: $e");
      // keep showing local state
    }
  }
}

final allhabitProvider =
    StateNotifierProvider<AllHabitListProvider, List<HabitUI>>(
      (ref) => AllHabitListProvider(),
    );
