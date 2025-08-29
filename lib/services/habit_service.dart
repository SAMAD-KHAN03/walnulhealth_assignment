import 'dart:convert';
import 'package:assignment/services/token_storage.dart';
import 'package:dio/dio.dart';
import '../models/habit.dart';

class HabitService {
  final Dio dio;
  HabitService(this.dio);
  Future<List<Habit>> fetchHabits() async {
    try {
      final token = await TokenStorage.getToken();
      if (token == null) throw Exception("No auth token found");

      final res = await dio.get(
        '/habits',
        options: Options(headers: {"token": token}),
      );

      if (res.statusCode == 200) {
        final list = (res.data as List).map((e) => Habit.fromJson(e)).toList();
        print("✅ fetched list of habits $list");
        return list;
      } else {
        throw Exception("Fetch habits failed: ${res.statusCode}");
      }
    } on DioException catch (e) {
      print("❌ fetchHabits Dio error: ${e.response?.data ?? e.message}");
      rethrow;
    } catch (e) {
      print("❌ Unexpected fetchHabits error: $e");
      rethrow;
    }
  }

  Future<Habit> createHabit(Habit payload) async {
    try {
      final token = await TokenStorage.getToken();
      if (token == null) throw Exception("No auth token found");

      final res = await dio.post(
        '/habits',
        data: payload.toJson(),
        options: Options(headers: {"token": token}),
      );

      if (res.statusCode == 201 || res.statusCode == 200) {
        final data = res.data is String ? jsonDecode(res.data) : res.data;
        return Habit.fromJson(data as Map<String, dynamic>);
      } else {
        throw Exception("Create habit failed: ${res.statusCode}");
      }
    } on DioException catch (e) {
      print(" createHabit Dio error: ${e.response?.data ?? e.message}");
      rethrow;
    } catch (e) {
      print(" Unexpected createHabit error: $e");
      rethrow;
    }
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
