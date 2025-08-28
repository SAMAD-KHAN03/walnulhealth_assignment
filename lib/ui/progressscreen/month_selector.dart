import 'package:assignment/providers/progress_screen_specific_providers/selected_date_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Month Selector Component
class MonthSelector extends ConsumerWidget {
  const MonthSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => _navigateToPreviousMonth(ref),
            icon: const Icon(Icons.chevron_left, color: Color(0xFF636E72)),
          ),
          Expanded(
            child: Text(
              '${_getMonthName(selectedDate.month)} ${selectedDate.year}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D3436),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            onPressed: () => _navigateToNextMonth(ref),
            icon: const Icon(Icons.chevron_right, color: Color(0xFF636E72)),
          ),
        ],
      ),
    );
  }

  void _navigateToPreviousMonth(WidgetRef ref) {
    final currentDate = ref.read(selectedDateProvider);
    final previousMonth = DateTime(
      currentDate.year,
      currentDate.month - 1,
      currentDate.day,
    );
    ref.read(selectedDateProvider.notifier).state = previousMonth;
  }

  void _navigateToNextMonth(WidgetRef ref) {
    final currentDate = ref.read(selectedDateProvider);
    final nextMonth = DateTime(
      currentDate.year,
      currentDate.month + 1,
      currentDate.day,
    );
    ref.read(selectedDateProvider.notifier).state = nextMonth;
  }

  String _getMonthName(int month) {
    const months = [
      '', 'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return months[month];
  }
} 