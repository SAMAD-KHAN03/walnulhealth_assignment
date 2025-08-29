import 'package:flutter/material.dart';

class WeeklyChart extends StatelessWidget {
  final Map<String, double> weeklyData;

  const WeeklyChart({
    super.key,
    required this.weeklyData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: weeklyData.entries.map((entry) {
          return _ChartBar(day: entry.key, progress: entry.value);
        }).toList(),
      ),
    );
  }
}

class _ChartBar extends StatelessWidget {
  final String day;
  final double progress;

  const _ChartBar({
    required this.day,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 24,
          height: 80 * progress,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                const Color(0xFF6C5CE7),
                const Color(0xFF6C5CE7).withOpacity(0.6),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          day,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF636E72),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}