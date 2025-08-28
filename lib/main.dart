import 'package:assignment/models/habit.dart';
import 'package:assignment/providers/local_storage_habits_list_provider.dart';
import 'package:assignment/ui/auth/login_screen.dart';
import 'package:assignment/ui/auth/signup_screen.dart';
import 'package:assignment/ui/dashboard/dashboard.dart';
import 'package:assignment/ui/habitdetails/habit_details_scree.dart';
import 'package:assignment/ui/progressscreen/progress_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

// import 'package:hive';
void main() async {
  // Hive.init
  WidgetsFlutterBinding.ensureInitialized();

  //  Initialize Hive
  await Hive.initFlutter();

  //  Open the boxes you plan to use BEFORE runApp
  await Hive.openBox('habits'); // example
  await Hive.openBox('pending_ops'); // example (optional)FF
  await Hive.openBox('progress'); 
  runApp(ProviderScope(child: HabitBuilderApp()));
}

class HabitBuilderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: MaterialApp(
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
        routes: {
          '/login': (context) => LoginScreen(),
          '/signup': (context) => SignupScreen(),
          '/dashboard': (context) => DashboardScreen(),
          '/habit-detail': (context) => HabitDetailScreen(),
          '/progress': (context) => ProgressScreen(),
        },
      ),
    );
  }
}

//specially for ios
class KeyboardDismissOnTap extends StatelessWidget {
  final Widget child;
  const KeyboardDismissOnTap({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent, // <- important for iOS
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          currentFocus.unfocus();
        }
      },
      child: child,
    );
  }
}
