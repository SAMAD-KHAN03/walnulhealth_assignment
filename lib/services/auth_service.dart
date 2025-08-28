import 'package:assignment/models/user.dart';
import 'package:assignment/providers/text_editing_controllers_provider.dart';
import 'package:assignment/services/token_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final Dio dio;
  AuthService(this.dio);

  Future<User?> login(WidgetRef ref) async {
    final username = ref.read(usernameController).text;
    final password = ref.read(passwordControllerProvider).text;
    final res = await dio.post(
      '/auth/login',
      data: {"username": username, "password": password},
    );
    if (res.statusCode == 200) {
      final token = res.data['token'] as String;
      await TokenStorage.saveToken(token);
      return User.fromJson(res.data['user']);
    }
    return null;
  }

  Future<bool> signup(WidgetRef ref) async {
    final username = ref.read(usernameController).text;
    final email = ref.read(emailControllerProvider).text;
    final password = ref.read(passwordControllerProvider).text;
    final res = await dio.post(
      '/auth/signup',
      data: {"username": username, "email": email, "password": password},
    );
    return res.statusCode == 201;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }
}
