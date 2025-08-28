import 'package:assignment/services/local_progress_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


/// Static singleton provider for ProgressStore
final localProgressProvider = Provider<ProgressStore>((ref) {
  return ProgressStore();
});