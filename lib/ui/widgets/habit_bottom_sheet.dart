// Add Habit Bottom Sheet
// ignore_for_file: library_private_types_in_public_api
import 'dart:math';
import 'package:assignment/models/habit.dart';
import 'package:assignment/providers/all_habit_list_provider.dart';
import 'package:assignment/providers/habit_service_repo_provider.dart';
import 'package:assignment/providers/local_store_provider.dart';
import 'package:assignment/providers/text_editing_controllers_provider.dart';
import 'package:assignment/ui/widgets/frequency_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddHabitBottomSheet extends ConsumerStatefulWidget {
  const AddHabitBottomSheet({super.key});

  @override
  _AddHabitBottomSheetState createState() => _AddHabitBottomSheetState();
}

int generateTwoDigitId() {
  final random = Random();
  final number = random.nextInt(100); // 0 to 99
  return int.parse(
    number.toString().padLeft(2, '0'),
  ); // ensures 2 digits like 07, 42
}

class _AddHabitBottomSheetState extends ConsumerState<AddHabitBottomSheet> {
  Category _selectedCategory = Category.fitness;
  Color _selectedColor = Color(0xFF6C5CE7);
  IconData _selectedIcon = Icons.fitness_center;

  final List<Color> _colors = [
    Color(0xFF6C5CE7),
    Color(0xFF00B894),
    Color(0xFF0984E3),
    Color(0xFFE17055),
    Color(0xFFA29BFE),
    Color(0xFFFDCB6E),
  ];
  final List<IconData> _icons = [
    Icons.fitness_center,
    Icons.directions_run,
    Icons.local_drink,
    Icons.book,
    Icons.self_improvement,
    Icons.work,
    Icons.school,
    Icons.music_note,
  ];

  @override
  Widget build(BuildContext context) {
    final _nameController = ref.watch(habitNameController);
    final _descriptionController = ref.watch(descriptionController);
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Create New Habit',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3436),
              ),
            ),
            SizedBox(height: 32),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField(
                      controller: _nameController,
                      label: 'Habit Name',
                      hint: 'e.g., Morning Run',
                    ),
                    SizedBox(height: 20),
                    _buildTextField(
                      controller: _descriptionController,
                      label: 'Description',
                      hint: 'Brief description of your habit',
                      maxLines: 3,
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Category',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3436),
                      ),
                    ),
                    SizedBox(height: 12),
                    _buildCategorySelector(),
                    SizedBox(height: 24),
                    // 👇 Add FrequencySelector here
                    Text(
                      'Frequency',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3436),
                      ),
                    ),
                    SizedBox(height: 12),
                    Wrap(
                      spacing: 12, // horizontal space
                      runSpacing: 12, // vertical space between lines
                      children: HabitFrequency.values
                          .map(
                            (freq) => GestureDetector(
                              onTap: () {
                                ref.watch(selectedfrequency.notifier).state =
                                    freq;
                              },
                              child: FrequencySelector(
                                frequency: freq,
                                ref: ref,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    SizedBox(height: 24),
                    //use frequency selector here
                    Text(
                      'Color',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3436),
                      ),
                    ),
                    SizedBox(height: 12),
                    _buildColorSelector(),
                    SizedBox(height: 24),
                    Text(
                      'Icon',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3436),
                      ),
                    ),
                    SizedBox(height: 12),
                    _buildIconSelector(),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: Color(0xFFE0E0E0)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Color(0xFF636E72),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final habit = Habit(
                        id: generateTwoDigitId(),
                        title: _nameController.text,
                        description: _descriptionController.text,
                        category: _selectedCategory,
                        frequency: ref
                            .read(selectedfrequency.notifier)
                            .state
                            .name,
                        streak: 0,
                        completedToday: false,
                      );
                      await ref
                          .watch(localStoreProvider)
                          .saveHabit(habit); //saving locally
                      try {
                        await ref
                            .read(habitRepoProvider)
                            .createHabit(habit); //saving backend(mock)
                        print("saved successfully  ");
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            duration: Duration(minutes: 1),
                            content: Text(
                              "some error occures in saving to backend $e",
                            ),
                          ),
                        );
                      }
                      ref.watch(allhabitProvider.notifier).fetchHabits(ref);

                      // Close bottom sheet first
                      Navigator.pop(context);

                      // Then show success dialog
                      _showSuccessDialog();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedColor,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Create Habit',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3436),
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xFFE0E0E0)),
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySelector() {
    return Wrap(
      // verticalDirection: VerticalDirection.down,
      runSpacing: 12,
      spacing: 6,
      children: Category.values.map((category) {
        bool isSelected = category == _selectedCategory;
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedCategory = category;
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? _selectedColor.withOpacity(0.1)
                  : Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? _selectedColor : Color(0xFFE0E0E0),
              ),
            ),
            child: Text(
              category.name,
              style: TextStyle(
                color: isSelected ? _selectedColor : Color(0xFF636E72),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildColorSelector() {
    return Row(
      children: _colors.map((color) {
        bool isSelected = color == _selectedColor;
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedColor = color;
            });
          },
          child: Container(
            margin: EdgeInsets.only(right: 12),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20),
              border: isSelected ? Border.all(color: color, width: 3) : null,
            ),
            child: isSelected
                ? Icon(Icons.check, color: Colors.white, size: 20)
                : null,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildIconSelector() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: _icons.map((icon) {
        bool isSelected = icon == _selectedIcon;
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedIcon = icon;
            });
          },
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected
                  ? _selectedColor.withOpacity(0.1)
                  : Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? _selectedColor : Color(0xFFE0E0E0),
              ),
            ),
            child: Icon(
              icon,
              color: isSelected ? _selectedColor : Color(0xFF636E72),
              size: 20,
            ),
          ),
        );
      }).toList(),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Habit Created!'),
        content: Text(
          'Your new habit has been added successfully. Start building your streak today!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Great!'),
          ),
        ],
      ),
    );
  }
}
