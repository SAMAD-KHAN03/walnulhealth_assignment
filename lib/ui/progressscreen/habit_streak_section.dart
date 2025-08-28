import 'package:assignment/providers/progress_screen_specific_providers/selected_date_provider.dart';
import 'package:assignment/ui/progressscreen/habit_streak_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Habit Streaks Section Component
class HabitStreaksSection extends ConsumerWidget {
  const HabitStreaksSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(   
            'Current Streaks',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3436),
            ),
          ),
          const SizedBox(height: 16),
          ...HabitStreakBuilder.buildHabitStreaks(
            ref, 
            selectedDate.month, 
            selectedDate.year,
          ),
        ],
      ),
    );
  }
}         