import 'package:assignment/models/user_profile.dart';
import 'package:assignment/providers/profile_specific_provider/profile_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// User Profile Model (assuming this structure)

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  UserProfile? profile;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      profile = await ref.read(profileprovider).fetchprofile();
    } catch (e) {
      print('Error loading profile: $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Fallback user data
    final userData = {
      "id": 1,
      "username": "john_doe",
      "email": "john@example.com",
      "joined": "2025-01-15",
    };

    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Profile', style: TextStyle(color: Colors.black)),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF6C5CE7)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Profile', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // Avatar
            CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFF6C5CE7),
              child: Text(
                _getInitials(),
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            SizedBox(height: 30),

            // Profile Info
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFF6C5CE7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildInfoRow('ID', _getId()),
                  SizedBox(height: 12),
                  _buildInfoRow('Username', _getUsername()),
                  SizedBox(height: 12),
                  _buildInfoRow('Email', _getEmail()),
                  SizedBox(height: 12),
                  _buildInfoRow('Joined', _getJoined()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods to safely get data
  String _getId() {
    if (profile != null) {
      return profile!.id.toString();
    }
    return "1"; // fallback
  }

  String _getUsername() {
    if (profile != null) {
      return profile!.username;
    }
    return "john_doe"; // fallback
  }

  String _getEmail() {
    if (profile != null) {
      return profile!.email;
    }
    return "john@example.com"; // fallback
  }

  String _getJoined() {
    if (profile != null) {
      return profile!.joined;
    }
    return "2025-01-15"; // fallback
  }

  String _getInitials() {
    String username = _getUsername();
    if (username.contains('_')) {
      List<String> parts = username.split('_');
      return '${parts[0][0].toUpperCase()}${parts[1][0].toUpperCase()}';
    }
    return username.isNotEmpty ? username[0].toUpperCase() : 'U';
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            '$label:',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
