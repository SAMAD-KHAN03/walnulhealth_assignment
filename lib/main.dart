import 'package:assignment/ui/auth/login_screen.dart';
import 'package:assignment/ui/auth/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(child: HabitBuilderApp()));
}

class HabitBuilderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Builder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Color(0xFF6C5CE7),
        fontFamily: 'SF Pro Display',
        scaffoldBackgroundColor: Color(0xFFF8F9FA),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Color(0xFF2D3436)),
          titleTextStyle: TextStyle(
            color: Color(0xFF2D3436),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      home: LoginScreen(),
      routes: {'/login': (context) => LoginScreen(),
       '/signup': (context) => SignupScreen(),
      },
    );
  }
}
