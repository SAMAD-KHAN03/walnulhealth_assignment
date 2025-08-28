// Progress Screen
import 'package:assignment/providers/all_habit_list_provider.dart';
import 'package:assignment/providers/complete_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ProgressScreen extends ConsumerStatefulWidget {
  const ProgressScreen({super.key});

  @override
  ConsumerState<ProgressScreen> createState() => _ProgressScreenState();
}

bool istasktoday(WidgetRef ref, String dateToCheck) {
  final allhabits = ref.read(allhabitProvider);

  // If no habits exist, nothing is completed
  if (allhabits.isEmpty) {
    return false;
  }

  bool hasAnyCompletedHabit = false;

  for (final habit in allhabits) {
    // Check if this habit was completed on the given date
    final completed = ref
        .read(completelistprovider)
        .getcompletehabitlist(habit.habit.id);

    if (completed.contains(dateToCheck)) {
      hasAnyCompletedHabit = true;
      break; // Found at least one completed habit for this date
    }
  }
  return hasAnyCompletedHabit;
}

class _ProgressScreenState extends ConsumerState<ProgressScreen> {
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Progress',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3436),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Track your habit journey',
            style: TextStyle(fontSize: 16, color: Color(0xFF636E72)),
          ),
          SizedBox(height: 32),
          _buildMonthSelector(),
          SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildCalendarView(),
                  SizedBox(height: 24),
                  _buildHabitStreaks(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthSelector() {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                if (_selectedMonth == 1) {
                  _selectedMonth = 12;
                  _selectedYear--;
                } else {
                  _selectedMonth--;
                }
              });
            },
            icon: Icon(Icons.chevron_left, color: Color(0xFF636E72)),
          ),
          Expanded(
            child: Text(
              _getMonthName(_selectedMonth) + ' $_selectedYear',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D3436),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                if (_selectedMonth == 12) {
                  _selectedMonth = 1;
                  _selectedYear++;
                } else {
                  _selectedMonth++;
                }
              });
            },
            icon: Icon(Icons.chevron_right, color: Color(0xFF636E72)),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarView() {
    return Container(
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                .map(
                  (day) => Text(
                    day,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF636E72),
                    ),
                  ),
                )
                .toList(),
          ),
          SizedBox(height: 16),
          _buildCalendarGrid(),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: 35, // 5 weeks
      itemBuilder: (context, index) {
        int day = index + 1;

        // 🔹 Create the actual date for this calendar day
        DateTime dayDate = DateTime(_selectedYear, _selectedMonth, day);
        String dayDateString = DateFormat('yyyy-MM-dd').format(dayDate);

        // 🔹 Check if this specific day is completed
        bool isCompleted = istasktoday(
          ref,
          dayDateString, // Use the actual date for this day, not today's date
        );

        bool ismissed = !isCompleted;

        // 🔹 Check if this day is today
        bool isToday =
            day == DateTime.now().day &&
            _selectedMonth == DateTime.now().month &&
            _selectedYear == DateTime.now().year;
        return Container(
          decoration: BoxDecoration(
            color: isCompleted
                ? Color(0xFF00B894)
                : ismissed
                ? Color(0xFFE17055)
                : Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(8),
            border: isToday
                ? Border.all(color: Color(0xFF6C5CE7), width: 2)
                : null,
          ),
          child: Center(
            child: Text(
              day <= 31 ? '$day' : '',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isCompleted || ismissed
                    ? Colors.white
                    : Color(0xFF636E72),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHabitStreaks() {
    return Container(
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
          Text(
            'Current Streaks',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3436),
            ),
          ),
          SizedBox(height: 16),
          ...checkhabitsformonthyear(_selectedMonth, _selectedYear),
        ],
      ),
    );
  }

  Widget _buildStreakItem(String habit, int days, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              habit,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF2D3436),
              ),
            ),
          ),
          Text(
            '$days days',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month];
  }

  List<Widget> checkhabitsformonthyear(int month, int year) {
    final allHabitListProvider = ref.read(allhabitProvider);
    List<Widget> habitWidgets = [];

    for (final habitData in allHabitListProvider) {
      // Get completed and missed lists for this habit
      final completed = ref
          .read(completelistprovider)
          .getcompletehabitlist(habitData.habit.id);

      final missed = ref
          .read(completelistprovider)
          .getmissinghabtilist(habitData.habit.id);

      // Check if this habit has any entries for the specified month/year
      bool hasEntriesInMonthYear = false;
      int completedDaysInMonth = 0;
      int missedDaysInMonth = 0;

      // Check completed dates
      for (String dateString in completed) {
        try {
          DateTime date = DateTime.parse(dateString);
          if (date.month == month && date.year == year) {
            hasEntriesInMonthYear = true;
            completedDaysInMonth++;
          }
        } catch (e) {
          // Skip invalid date strings
          continue;
        }
      }

      // Check missed dates
      for (String dateString in missed) {
        try {
          DateTime date = DateTime.parse(dateString);
          if (date.month == month && date.year == year) {
            hasEntriesInMonthYear = true;
            missedDaysInMonth++;
          }
        } catch (e) {
          // Skip invalid date strings
          continue;
        }
      }

      // Only add to list if habit has entries in this month/year
      if (hasEntriesInMonthYear) {
        String habitName = habitData.habit.title;

        habitWidgets.add(
          _buildStreakItem(habitName, habitData.habit.streak, habitData.color),
        );
      }
    }

    return habitWidgets;
    // Return a container with all habit widgets
  }
}
