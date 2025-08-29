import 'package:assignment/models/habit.dart';
import 'package:assignment/models/habit_progress.dart';
import 'package:assignment/models/habitui.dart';
import 'package:assignment/providers/complete_list_provider.dart';
import 'package:assignment/providers/habit_service_repo_provider.dart';
import 'package:assignment/providers/local_storage_specific_providers/local_progress_storage_class_provider.dart';
import 'package:assignment/providers/local_storage_specific_providers/local_store_provider.dart';
import 'package:assignment/ui/widgets/habit_detail_screen_widgets/build_activityItem.dart';
import 'package:assignment/ui/widgets/habit_detail_screen_widgets/show_complete_dialogue.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HabitDetailScreen extends ConsumerStatefulWidget {
  const HabitDetailScreen({super.key});

  @override
  ConsumerState<HabitDetailScreen> createState() => _HabitDetailScreenState();
}

class _HabitDetailScreenState extends ConsumerState<HabitDetailScreen> {
  late HabitUI habit;
  late HabitProgress progress;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    habit = (ModalRoute.of(context)?.settings.arguments as Habit?) != null
        ? mapHabitToUI(ModalRoute.of(context)!.settings.arguments as Habit)
        : mapHabitToUI(
            Habit(
              id: 1,
              title: habit.habit.title,
              description: habit.habit.description,
              category: habit.habit.category,
              frequency: habit.habit.category.name,
              streak: habit.habit.streak,
              completedToday: habit.habit.completedToday,
            ),
          );

    final completedDates = ref
        .read(completelistprovider)
        .getcompletehabitlist(habit.habit.id);
    final missedDates = ref
        .read(completelistprovider)
        .getmissinghabtilist(habit.habit.id);
    progress = HabitProgress(completed: completedDates, missed: missedDates);
  }

  @override
  Widget build(BuildContext context) {
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
                              habit.habit.category.name,
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
                                  '${progress.streak}',
                                  'days',
                                ),
                                _buildStatItem(
                                  'Progress',
                                  '${(progress.progress)}',
                                  '%',
                                ),
                                _buildStatItem(
                                  'Category',
                                  habit.habit.category.name,
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
                                    onPressed: () async {
                                      //updating the progress object
                                      await ref
                                          .watch(localProgressProvider)
                                          .saveUpdateProgress(
                                            habit.habit.id,
                                            ref,
                                          );
                                      //updating the habit object
                                      habit.habit = habit.habit.copyWith(
                                        completedToday: true,
                                        streak: progress.streak,
                                      );
                                      //storing updated habit object locally
                                      await ref
                                          .watch(localStoreProvider)
                                          .saveHabit(habit.habit);
                                      //sending the updated object to backend
                                      try {
                                        await ref
                                            .watch(habitRepoProvider)
                                            .completeHabit(
                                              habit.habit.id.toString(),
                                            );
                                        print("saved the updated habit ");
                                      } catch (e) {
                                        print(e);
                                      }
                                      // FIXED: Show the dialogue properly
                                      ShowCompleteDialogue.show(context);
                                    },
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

  Widget _buildActivityList() {
    return Column(
      children: [
        BuildActivityitem(
          status: 'Completed',
          time: 'Today at 7:00 AM',
          icon: Icons.check_circle,
          color: Color(0xFF00B894),
        ),
        BuildActivityitem(
          status: 'Completed',
          time: 'Yesterday at 7:15 AM',
          icon: Icons.check_circle,
          color: Color(0xFF00B894),
        ),
        BuildActivityitem(
          status: 'Missed',
          time: '2 days ago',
          icon: Icons.cancel,
          color: Color(0xFFE17055),
        ),
        BuildActivityitem(
          status: 'Completed',
          time: '3 days ago at 6:45 AM',
          icon: Icons.check_circle,
          color: Color(0xFF00B894),
        ),
      ],
    );
  }
}
