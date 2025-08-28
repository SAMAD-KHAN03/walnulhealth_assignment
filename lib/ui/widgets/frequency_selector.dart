import 'package:assignment/models/habit.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum HabitFrequency { eachDay, thriceInWeek, onceIn10Days, onceIn2Week }

class FrequencySelector extends StatefulWidget {
  final HabitFrequency frequency;
  WidgetRef ref;
  FrequencySelector({super.key, required this.frequency, required this.ref});

  @override
  State<FrequencySelector> createState() => _FrequencySelectorState();
}

class _FrequencySelectorState extends State<FrequencySelector> {
  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      // use the "options" API (RoundedRectDottedBorderOptions) for rounded corners
      options: RoundedRectDottedBorderOptions(
        dashPattern: const [6, 4],
        strokeWidth: 1.5,
        padding: EdgeInsets.zero, // we handle padding in inner Container
        radius: const Radius.circular(24), // pill radius
        color: widget.frequency == widget.ref.watch(selectedfrequency)
            ? const Color(0xFF1C91F0)
            : const Color(0xFFB2BEC3),
        strokeCap: StrokeCap.round,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          color: widget.frequency == widget.ref.watch(selectedfrequency)
              ? const Color(0xFFE8F4FF)
              : Colors.white,
          child: Text(
            // use a nice label; if you have an extension .label use that
            widget.frequency.name,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: widget.frequency == widget.ref.watch(selectedfrequency)
                  ? const Color(0xFF1C91F0)
                  : const Color(0xFF2D3436),
              letterSpacing: 0.2,
            ),
          ),
        ),
      ),
    );
  }
}

final selectedfrequency = StateProvider<HabitFrequency>(
  (ref) => HabitFrequency.eachDay,
);
