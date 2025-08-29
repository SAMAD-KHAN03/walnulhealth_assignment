import 'package:assignment/models/habit_progress.dart';
import 'package:assignment/models/habitui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Widget buildHabitCard(HabitUI habitui, BuildContext context, WidgetRef ref) {
  final progress = HabitProgress(ref: ref);
  return Container(
    margin: EdgeInsets.only(bottom: 16),
    padding: EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: habitui.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(habitui.icon, color: habitui.color, size: 20),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    habitui.habit.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D3436),
                    ),
                  ),
                  Text(
                    habitui.habit.description,
                    style: TextStyle(fontSize: 12, color: Color(0xFF636E72)),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Color(0xFFE17055).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${progress.streak(habitui.habit.id)} days',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFE17055),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Progress',
                    style: TextStyle(fontSize: 12, color: Color(0xFF636E72)),
                  ),
                  SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: progress.progress(habitui.habit.id),
                    backgroundColor: habitui.color.withOpacity(0.1),
                    valueColor: AlwaysStoppedAnimation(habitui.color),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${progress.progress(habitui.habit.id).toStringAsFixed(2)}% Complete',
                    style: TextStyle(fontSize: 10, color: Color(0xFF636E72)),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/habit-detail',
                  arguments: habitui.habit,
                );
              },
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: habitui.color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.check, color: Colors.white, size: 16),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
