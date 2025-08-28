import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

// ignore: subtype_of_sealed_class
//not a provider actually just a function
class CompletedHabitListProvider {
  static List<String> complete = [];
  static List<String> missing = [];
  List<String> getcompletehabitlist(int habitid) {
    final box = Hive.box("progress");
    final progressMap = Map<String, dynamic>.from(
      box.get(habitid) ?? {'completed': <String>[], 'missed': <String>[]},
    );
    complete = List<String>.from(progressMap['completed']);
    return complete;
  }

  List<String> getmissinghabtilist(int habitid) {
    final box = Hive.box("progress");
    final progressMap = Map<String, dynamic>.from(
      box.get(habitid) ?? {'completed': <String>[], 'missed': <String>[]},
    );
    missing = List<String>.from(progressMap['missed']);
    return missing;
  }
}
