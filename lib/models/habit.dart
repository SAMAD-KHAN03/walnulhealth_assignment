enum Category { fitness, health, mindfulness, learning, productivity, none }

class Habit {
  @override
String toString() {
  return 'Habit(id: $id, title: $title, freq: $frequency, streak: $streak, completedToday: $completedToday)';
}
  final int id;
  final String title;
  final String description;
  final Category category;
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

  /// Convert JSON -> Habit
  factory Habit.fromJson(Map<String, dynamic> j) => Habit(
    id: j['id'],
    title: j['title'],
    description: j['description'],
    category: _categoryFromString(j['category']),
    frequency: j['frequency'],
    streak: j['streak'],
    completedToday: j['completed_today'],
  );

  /// Convert Habit -> JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'category': category.name, // save enum as string
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

  /// Helper: String -> Enum
  static Category _categoryFromString(String? value) {
    if (value == null) return Category.none;
    return Category.values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => Category.none,
    );
  }
}
