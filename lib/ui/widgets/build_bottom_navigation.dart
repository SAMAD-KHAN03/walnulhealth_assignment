import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Widget buildBottomNavigation(WidgetRef ref) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: Offset(0, -2),
        ),
      ],
    ),
    child: BottomNavigationBar(
      currentIndex: ref.watch(bottomNavigationIndexProvider),
      onTap: (index) {
        ref.watch(bottomNavigationIndexProvider.notifier).state = index;
      },
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.transparent,
      elevation: 0,
      selectedItemColor: Color(0xFF6C5CE7),
      unselectedItemColor: Color(0xFF636E72),
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Progress'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    ),
  );
}

final bottomNavigationIndexProvider = StateProvider<int>((ref) => 0);
