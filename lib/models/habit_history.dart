class HabitDay {
  final DateTime date;
  final bool completed;
  HabitDay({required this.date, required this.completed});

  factory HabitDay.fromJson(Map<String, dynamic> j) =>
      HabitDay(date: DateTime.parse(j['date']), completed: j['completed']);
}

class HabitHistory {
  final int habitId;
  final List<HabitDay> history;
  HabitHistory({required this.habitId, required this.history});

  factory HabitHistory.fromJson(Map<String, dynamic> j) => HabitHistory(
    habitId: j['habit_id'],
    history: (j['history'] as List).map((e) => HabitDay.fromJson(e)).toList(),
  );
}