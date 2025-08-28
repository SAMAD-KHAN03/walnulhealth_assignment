// ignore_for_file: library_private_types_in_public_api

import 'package:assignment/models/habit.dart';
import 'package:assignment/models/habitui.dart';
import 'package:assignment/providers/all_habit_list_provider.dart';
import 'package:assignment/providers/habit_service_repo_provider.dart';
import 'package:assignment/ui/progressscreen/progress_screen.dart';
import 'package:assignment/ui/widgets/build_bottom_navigation.dart';
import 'package:assignment/ui/widgets/build_habit_card.dart';
import 'package:assignment/ui/widgets/habit_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Dashboard Screen
class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(allhabitProvider.notifier).fetchHabits(ref);
    });
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
                  Center(child: Text('Profile Screen')),
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
    final _habits = ref.watch(allhabitProvider);
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatsCards(),
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
            itemCount: _habits.length,
            itemBuilder: (context, index) {
              return buildHabitCard(_habits[index], context);
            },
          ),
          SizedBox(height: 100), // Space for FAB
        ],
      ),
    );
  }

  Widget _buildStatsCards() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: 'Total Habits',
            value: '12',
            icon: Icons.track_changes,
            color: Color(0xFF00B894),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            title: 'Completed Today',
            value: '8',
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
