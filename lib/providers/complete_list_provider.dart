//this is a provider which will will provider a static object for the complete list class in services directory

import 'package:assignment/services/completed_habit_list_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final completelistprovider = Provider<CompletedHabitListProvider>((ref) {
  return CompletedHabitListProvider();
});
