import 'package:assignment/models/habit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



class HabitCache {
  /// Internal cache of habits from local storage
  static List<Habit> habits = [];
}