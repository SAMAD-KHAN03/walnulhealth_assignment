import 'package:assignment/services/token_storage.dart';
import 'package:dio/dio.dart';
import '../models/habit.dart';
import '../models/habit_history.dart';

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

  Future<Habit> createHabit(Map<String, dynamic> payload) async {
    final res = await dio.post('/habits', data: payload);
    return Habit.fromJson(res.data);
  }

  Future<Habit> completeHabit(int id) async {
    final res = await dio.post(
      '/habits/$id/complete',
      data: {"completed": true},
    );

    final r = res.data;
    return Habit(
      id: r['id'],
      title: r['title'],
      description: '', // not provided by mock response
      category: Category.none,
      frequency: 'Daily',
      streak: r['streak'],
      completedToday: r['completed_today'],
    );
  }

  Future<HabitHistory> getHistory(int id) async {
    final res = await dio.get('/habits/$id/history');
    return HabitHistory.fromJson(res.data);
  }
}
