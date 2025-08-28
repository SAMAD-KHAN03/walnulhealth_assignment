import 'dart:convert';

import 'package:assignment/models/user_profile.dart';
import 'package:assignment/services/token_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Profile extends StateNotifier<UserProfile?> {
  final Dio dio;
  Profile({required this.dio}) : super(null);
  Future<UserProfile?> fetchprofile() async {
    final token = TokenStorage.getToken();
    final profile = await dio.get(
      "/users/me",
      options: Options(headers: {"Bearer": "token"}),
    );
    if (profile.statusCode != 200) {
      return null;
    }
    final data = profile.data is String ? jsonDecode(profile.data) : profile.data;
    return UserProfile.fromJson(data);
  }
}
