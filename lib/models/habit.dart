class Habit {
  final int id;
  final String title;
  final String description;
  final String category; // Fitness / Health / Mindfulness
  final String frequency; // Daily / Weekly
  final int streak;
  final bool completedToday;

  Habit({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.frequency,
    required this.streak,
    required this.completedToday,
  });

  factory Habit.fromJson(Map<String, dynamic> j) => Habit(
    id: j['id'],
    title: j['title'],
    description: j['description'],
    category: j['category'],
    frequency: j['frequency'],
    streak: j['streak'],
    completedToday: j['completed_today'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'category': category,
    'frequency': frequency,
    'streak': streak,
    'completed_today': completedToday,
  };

  Habit copyWith({int? streak, bool? completedToday}) => Habit(
    id: id,
    title: title,
    description: description,
    category: category,
    frequency: frequency,
    streak: streak ?? this.streak,
    completedToday: completedToday ?? this.completedToday,
  );
}
