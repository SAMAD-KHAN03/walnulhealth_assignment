// ignore_for_file: library_private_types_in_public_api
import 'package:assignment/providers/all_habit_list_provider.dart';
import 'package:assignment/providers/complete_list_provider.dart';
import 'package:assignment/providers/habit_details_specific_provider/week_days_provider.dart';
import 'package:assignment/providers/local_storage_specific_providers/local_progress_storage_class_provider.dart';
import 'package:assignment/ui/profile/profile_screen.dart';
import 'package:assignment/ui/progressscreen/progress_screen.dart';
import 'package:assignment/ui/widgets/build_bottom_navigation.dart';
import 'package:assignment/ui/widgets/build_habit_card.dart';
import 'package:assignment/ui/widgets/habit_bottom_sheet.dart';
import 'package:assignment/ui/widgets/habit_detail_screen_widgets/weekly_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

// Dashboard Screen
class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

int countCompleteToday(WidgetRef ref) {
  //this function is for counting how many tasks are marked completed today which will we done by traversing the progress of each taks from internal storage and then counting how many have todays date in their completed list
  final allhabits = ref.read(allhabitProvider);
  int count = 0;
  for (final habit in allhabits) {
    final completelist = ref.read(completelistprovider);
    if (completelist
        .getcompletehabitlist(habit.habit.id)
        .contains(DateFormat('yyyy-MM-dd').format(DateTime.now()))) {
      count++;
    }
  }
  return count;
}

//this method will calculate the number of total habits divided by completed on the particular day
double counthabitsratioforchart(WidgetRef ref, int index) {
  final allhabits = ref.read(allhabitProvider);
  //impporting the week from today for more info read the provider file use below
  final weekdaysfromtoday = ref.read(weekDatesProvider);
  final daytosearchfor = weekdaysfromtoday[index];
  int count = 0;
  for (final habit in allhabits) {
    final completelistofthishabit = ref
        .read(completelistprovider)
        .getcompletehabitlist(habit.habit.id);

    if (completelistofthishabit.contains(daytosearchfor)) {
      count++;
    }
  }
  return allhabits.isEmpty ? 0 : count / allhabits.length;
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _initializeData();
    });
  }

  Future<void> _initializeData() async {
    ref.read(allhabitProvider.notifier).fetchHabits(ref);
    await ref.read(localProgressProvider).updateAllHabits(ref);
  }

  @override
  Widget build(BuildContext context) {
    // final _habits/ = ref.watch(allhabitProvider);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: IndexedStack(
                index: ref.watch(bottomNavigationIndexProvider),
                children: [
                  _buildDashboardContent(ref),
                  ProgressScreen(),
                  ProfileScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: buildBottomNavigation(ref),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddHabitBottomSheet,
        backgroundColor: Color(0xFF6C5CE7),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(24),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Color(0xFF6C5CE7),
            child: Text(
              'JD',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good morning, John!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3436),
                  ),
                ),
                Text(
                  'Ready to build great habits?',
                  style: TextStyle(fontSize: 14, color: Color(0xFF636E72)),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_outlined, color: Color(0xFF636E72)),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardContent(WidgetRef ref) {
    final habits = ref.watch(allhabitProvider);
    return habits.isEmpty
        ? Center(child: Text("No tasks added"))
        : SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Text(
                  'Your Weeky Progress!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3436).withValues(alpha: 0.8),
                  ),
                ),
                WeeklyChart(
                  weeklyData: {
                    'Mon': counthabitsratioforchart(ref, 0),
                    'Tue': counthabitsratioforchart(ref, 1),
                    'Wed': counthabitsratioforchart(ref, 2),
                    'Thu': counthabitsratioforchart(ref, 3),
                    'Fri': counthabitsratioforchart(ref, 4),
                    'Sat': counthabitsratioforchart(ref, 5),
                    'Sun': counthabitsratioforchart(ref, 6),
                  },
                ),
                SizedBox(height: 20),
                _buildStatsCards(ref),
                SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Today\'s Habits',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3436),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'View All',
                        style: TextStyle(
                          color: Color(0xFF6C5CE7),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: habits.length,
                  itemBuilder: (context, index) {
                    return buildHabitCard(habits[index], context, ref);
                  },
                ),
                SizedBox(height: 100), // Space for FAB
              ],
            ),
          );
  }

  Widget _buildStatsCards(WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: 'Total Habits',
            value: ref.read(allhabitProvider).length.toString(),
            icon: Icons.track_changes,
            color: Color(0xFF00B894),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            title: 'Completed Today',
            value: countCompleteToday(ref).toString(),
            icon: Icons.check_circle,
            color: Color(0xFF6C5CE7),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
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
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3436),
            ),
          ),
          Text(title, style: TextStyle(fontSize: 12, color: Color(0xFF636E72))),
        ],
      ),
    );
  }

  void _showAddHabitBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => AddHabitBottomSheet(),
    );
  }
}
