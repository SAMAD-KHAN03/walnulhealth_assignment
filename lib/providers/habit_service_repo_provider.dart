import 'package:assignment/providers/dio_provider.dart';
import 'package:assignment/services/habit_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final habitRepoProvider = Provider<HabitService>((ref) {
  final dio = ref.watch(dioProvider);
  return HabitService(dio);
});
