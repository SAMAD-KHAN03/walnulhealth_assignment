import 'dart:convert';

import 'package:assignment/services/token_storage.dart';
import 'package:dio/dio.dart';
import '../models/habit.dart';

class HabitService {
  final Dio dio;
  HabitService(this.dio);

  Future<List<Habit>> fetchHabits() async {
    final token = await TokenStorage.getToken();
    final res = await dio.get(
      '/habits',
      options: Options(headers: {"token": token}),
    );
    final list = (res.data as List).map((e) => Habit.fromJson(e)).toList();
    print("fetched list of habits $list");
    return list;
  }

  Future<Habit> createHabit(Habit payload) async {
    final res = await dio.post('/habits', data: payload.toJson());

    // Ensure correct type
      final data = res.data is String ? jsonDecode(res.data) : res.data;

    return Habit.fromJson(data as Map<String, dynamic>);
  }

  Future<void> completeHabit(String habitId) async {
    final token = await TokenStorage.getToken();
    print("the token for the complete habit function is $token");

    if (token == null) {
      throw Exception("the token is null");
    }

    try {
      final res = await dio.post(
        '/habits/1/complete', // Fixed: Added /api and use habitId
        data: {
          "id": habitId, // Use the actual habit ID
          "completed_today": true, // Match the API response format
        },
        options: Options(
          headers: {
            "Authorization": "Bearer $token", // Fixed: Proper Bearer token
            "Content-Type": "application/json", // Fixed: Added content type
          },
        ),
      );

      final data = res.data is String ? jsonDecode(res.data) : res.data;
      // return Habit.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      print("Error completing habit: $e");
      rethrow;
    }
  }
}
