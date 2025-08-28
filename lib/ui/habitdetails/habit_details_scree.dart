import 'package:assignment/models/habit.dart';
import 'package:assignment/models/habitui.dart';
import 'package:flutter/material.dart';

class HabitDetailScreen extends StatefulWidget {
  @override
  _HabitDetailScreenState createState() => _HabitDetailScreenState();
}

class _HabitDetailScreenState extends State<HabitDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final habit = (ModalRoute.of(context)?.settings.arguments as Habit?) != null
        ? mapHabitToUI(ModalRoute.of(context)!.settings.arguments as Habit)
        : mapHabitToUI(
            Habit(
              id: 1,
              title: 'Morning Run',
              description: 'Start your day with a 30-minute run',
              category: Category.fitness,
              frequency: 'Daily',
              streak: 12,
              completedToday: false,
            ),
          );
    return Scaffold(
      backgroundColor: habit.color,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.arrow_back_ios,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                Spacer(),
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.more_vert,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 32),
                            Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Icon(
                                habit.icon,
                                color: Colors.white,
                                size: 48,
                              ),
                            ),
                            SizedBox(height: 24),
                            Text(
                              habit.habit.title,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              habit.habit.category.toString(),
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.8),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 32),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildStatItem(
                                  'Streak',
                                  '${habit.habit.streak}',
                                  'days',
                                ),
                                _buildStatItem(
                                  'Progress',
                                  '${(habit.progress * 100).toInt()}',
                                  '%',
                                ),
                                _buildStatItem(
                                  'Category',
                                  habit.habit.category.toString(),
                                  '',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFF8F9FA),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(32),
                              topRight: Radius.circular(32),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Weekly Progress',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2D3436),
                                  ),
                                ),
                                SizedBox(height: 20),
                                _buildWeeklyChart(),
                                SizedBox(height: 32),
                                Text(
                                  'Recent Activity',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2D3436),
                                  ),
                                ),
                                SizedBox(height: 20),
                                _buildActivityList(),
                                Spacer(),
                                Container(
                                  width: double.infinity,
                                  height: 56,
                                  child: ElevatedButton(
                                    onPressed: _showCompletionDialog,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: habit.color,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: Text(
                                      'Mark as Complete',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, String unit) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          unit,
          style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.8)),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.8)),
        ),
      ],
    );
  }

  Widget _buildWeeklyChart() {
    return Container(
      height: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildChartBar('Mon', 0.8),
          _buildChartBar('Tue', 1.0),
          _buildChartBar('Wed', 0.6),
          _buildChartBar('Thu', 0.9),
          _buildChartBar('Fri', 0.7),
          _buildChartBar('Sat', 0.4),
          _buildChartBar('Sun', 0.2),
        ],
      ),
    );
  }

  Widget _buildChartBar(String day, double progress) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 24,
          height: 80 * progress,
          decoration: BoxDecoration(
            color: Color(0xFF6C5CE7),
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Color(0xFF6C5CE7), Color(0xFF6C5CE7).withOpacity(0.6)],
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          day,
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF636E72),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildActivityList() {
    return Column(
      children: [
        _buildActivityItem(
          'Completed',
          'Today at 7:00 AM',
          Icons.check_circle,
          Color(0xFF00B894),
        ),
        _buildActivityItem(
          'Completed',
          'Yesterday at 7:15 AM',
          Icons.check_circle,
          Color(0xFF00B894),
        ),
        _buildActivityItem(
          'Missed',
          '2 days ago',
          Icons.cancel,
          Color(0xFFE17055),
        ),
        _buildActivityItem(
          'Completed',
          '3 days ago at 6:45 AM',
          Icons.check_circle,
          Color(0xFF00B894),
        ),
      ],
    );
  }

  Widget _buildActivityItem(
    String status,
    String time,
    IconData icon,
    Color color,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3436),
                  ),
                ),
                Text(
                  time,
                  style: TextStyle(fontSize: 12, color: Color(0xFF636E72)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Great Job!'),
        content: Text(
          'You\'ve completed your habit for today. Keep up the great work!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Continue'),
          ),
        ],
      ),
    );
  }
}
