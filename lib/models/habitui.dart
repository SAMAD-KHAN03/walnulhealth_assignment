import 'package:assignment/models/habit.dart';
import 'package:flutter/material.dart';

class HabitUI {
  final Habit habit;
  final double progress;
  final Color color;
  final IconData icon;

  HabitUI({
    required this.habit,
    required this.progress,
    required this.color,
    required this.icon,
  });
}

HabitUI mapHabitToUI(Habit habit) {
  Color color;
  IconData icon;

  switch (habit.category) {
    case Category.fitness:
      color = const Color(0xFF00B894);
      icon = Icons.directions_run;
      break;
    case Category.mindfulness:
      color = const Color(0xFF0984E3);
      icon = Icons.local_drink;
      break;
    case Category.health:
      color = const Color(0xFFA29BFE);
      icon = Icons.self_improvement;
      break;
    default:
      color = const Color(0xFFE17055);
      icon = Icons.book;
  }

  return HabitUI(
    habit: habit,
    progress: (habit.streak % 30) / 30.0,
    color: color,
    icon: icon,
  );
}
