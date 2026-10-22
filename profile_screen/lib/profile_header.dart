import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String university;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.university,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset('assets/images/profile.jpg', width: 140, height: 140),
        const SizedBox(height: 16),
        Text(
          name,
          style: TextStyle(
            fontFamily: 'MyFont',
            fontSize: 24,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          university,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
