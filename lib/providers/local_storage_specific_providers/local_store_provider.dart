import 'package:assignment/services/local_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

  // Create a provider that exposes a single instance of LocalStore
  final localStoreProvider = Provider<LocalStore>((ref) {
    return LocalStore();
  });