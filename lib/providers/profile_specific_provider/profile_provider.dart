import 'package:assignment/providers/auth_service_specific_providers/dio_provider.dart';
import 'package:assignment/services/profile/fetchprofile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileprovider = Provider<Profile>((ref) {
  final dio = ref.watch(dioProvider);
  return Profile(dio:dio);
});
