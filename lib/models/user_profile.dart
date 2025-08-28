
// UserProfile Model
import 'package:intl/intl.dart';

class UserProfile {
  final int id;
  final String username;
  final String email;
  final String joined;

  UserProfile({
    required this.id,
    required this.username,
    required this.email,
    required this.joined,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      joined: json['joined'],
    );
  }

  // Format joined date for display
  String get formattedJoinedDate {
    try {
      DateTime date = DateTime.parse(joined);
      return DateFormat('MMMM dd, yyyy').format(date);
    } catch (e) {
      return joined; // Return original if parsing fails
    }
  }

  // Get initials for avatar
  String get initials {
    List<String> names = username.split('_');
    if (names.length >= 2) {
      return '${names[0][0].toUpperCase()}${names[1][0].toUpperCase()}';
    }
    return username.isNotEmpty ? username[0].toUpperCase() : 'U';
  }
}
