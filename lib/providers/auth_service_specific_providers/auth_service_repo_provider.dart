import 'package:assignment/providers/auth_service_specific_providers/dio_provider.dart';
import 'package:assignment/services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider<AuthService>((ref) {
  final dio = ref.watch(dioProvider);
  return AuthService(dio);  
});
