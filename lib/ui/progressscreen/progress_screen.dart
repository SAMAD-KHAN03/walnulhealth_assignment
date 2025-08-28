import 'package:assignment/ui/progressscreen/calender_view.dart';
import 'package:assignment/ui/progressscreen/habit_streak_section.dart';
import 'package:assignment/ui/progressscreen/month_selector.dart';
import 'package:assignment/ui/progressscreen/progress_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Main Progress Screen - Simplified
class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ProgressHeader(),
          const SizedBox(height: 32),
          const MonthSelector(),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const CalendarView(),
                  const SizedBox(height: 24),
                  const HabitStreaksSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
