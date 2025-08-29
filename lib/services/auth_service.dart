import 'dart:convert';
import 'package:assignment/models/user.dart';
import 'package:assignment/providers/texteditingcontroller_provider/text_editing_controllers_provider.dart';
import 'package:assignment/services/token_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final Dio dio;
  AuthService(this.dio);

  Future<User?> login(WidgetRef ref) async {
    try {
      final username = ref.read(usernameController).text;
      final password = ref.read(passwordControllerProvider).text;

      final res = await dio.post(
        '/auth/login',
        data: {"username": username, "password": password},
      );

      if (res.statusCode == 200) {
        final token = res.data['token'] as String;
        await TokenStorage.saveToken(token);

        final data = res.data['user'] is String
            ? jsonDecode(res.data['user'])
            : res.data['user'];

        return User.fromJson(data as Map<String, dynamic>);
      } else {
        throw Exception("Unexpected status code: ${res.statusCode}");
      }
    } on DioException catch (e) {
      // Dio network/response error
      print("Login failed: ${e.response?.data ?? e.message}");
      rethrow; // rethrow so caller can handle (e.g., show snackbar)
    } catch (e) {
      // Other errors
      print("Unexpected login error: $e");
      rethrow;
    }
  }

  Future<bool> signup(WidgetRef ref) async {
    try {
      final username = ref.read(usernameController).text;
      final email = ref.read(emailControllerProvider).text;
      final password = ref.read(passwordControllerProvider).text;

      final res = await dio.post(
        '/auth/signup',
        data: {"username": username, "email": email, "password": password},
      );

      if (res.statusCode == 201) {
        return true;
      } else {
        throw Exception("Signup failed with status: ${res.statusCode}");
      }
    } on DioException catch (e) {
      print("Signup failed: ${e.response?.data ?? e.message}");
      return false; // return false so UI knows signup failed
    } catch (e) {
      print("Unexpected signup error: $e");
      return false;
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
    } catch (e) {
      print("Logout failed: $e");
      rethrow; // optional: you can also swallow the error
    }
  }
}
