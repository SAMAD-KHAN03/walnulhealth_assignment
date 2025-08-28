import 'package:intl/intl.dart';

class HabitProgress {
  final List<String> completed; // dates in 'yyyy-MM-dd'
  final List<String> missed; // dates in 'yyyy-MM-dd'

  HabitProgress({
    required this.completed,
    required this.missed,
  });

  /// Compute max consecutive streak from completed dates
  int get streak {
    if (completed.isEmpty) return 0;

    final sortedDates = completed.map((d) => DateTime.parse(d)).toList()
      ..sort();

    int maxStreak = 1;
    int currentStreak = 1;

    for (int i = 1; i < sortedDates.length; i++) {
      final diff = sortedDates[i].difference(sortedDates[i - 1]).inDays;
      if (diff == 1) {
        currentStreak++;
        if (currentStreak > maxStreak) maxStreak = currentStreak;
      } else {
        currentStreak = 1;
      }
    }
    return maxStreak;
  }

  /// Compute progress percentage
  double get progress {
    final totalDays = completed.length + missed.length;
    if (totalDays == 0) return 0;
    return (completed.length / totalDays) * 100;
  }

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() => {
        'completed': completed,
        'missed': missed,
      };

  /// Convert from storage JSON
  factory HabitProgress.fromJson(Map<String, dynamic> json) => HabitProgress(
        completed: List<String>.from(json['completed'] ?? []),
        missed: List<String>.from(json['missed'] ?? []),
      );

  /// Generate backend-compatible JSON with habitId
  Map<String, dynamic> toBackendJson(int habitId) {
    final allDates = <String>{...completed, ...missed}.toList()..sort();

    final history = allDates.map((date) {
      return {
        "date": date,
        "completed": completed.contains(date),
      };
    }).toList();

    return {
      "habit_id": habitId,
      "history": history,
    };
  }

  /// Create HabitProgress from backend JSON
  factory HabitProgress.fromBackendJson(Map<String, dynamic> json) {
    final history = (json['history'] as List<dynamic>? ?? []);
    final completed = <String>[];
    final missed = <String>[];

    for (final entry in history) {
      final date = entry['date'] as String;
      final isCompleted = entry['completed'] as bool? ?? false;

      if (isCompleted) {
        completed.add(date);
      } else {
        missed.add(date);
      }
    }

    return HabitProgress(
      completed: completed,
      missed: missed,
    );
  }
}