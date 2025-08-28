import 'package:flutter/material.dart';
  
// Header Component
class ProgressHeader extends StatelessWidget {
  const ProgressHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Progress',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3436),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Track your habit journey',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF636E72),
          ),
        ),
      ],
    );
  }
}