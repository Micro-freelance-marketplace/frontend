import 'package:flutter/material.dart';

import '../../models/user.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const User _user = User(
    name: 'ABC DEF',
    email: 'abc@student.edu',
    department: 'Computer Science',
    completedProjects: 21,
  );

  static const List<String> _skills = [
    'Flutter',
    'UI Design',
    'Writing',
    'Video Editing',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const CircleAvatar(radius: 30, child: Icon(Icons.person)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _user.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 2),
                        Text(_user.email),
                        const SizedBox(height: 2),
                        Text(_user.department),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _ProfileStat(
                  title: 'Projects',
                  value: '${_user.completedProjects}',
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: _ProfileStat(title: 'Rating', value: '4.9'),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: _ProfileStat(title: 'Reviews', value: '58'),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text('Skills', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _skills
                .map(
                  (skill) => Chip(
                    label: Text(skill),
                    backgroundColor: const Color(0xFF2A2A2A),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 20),
          FilledButton(onPressed: () {}, child: const Text('Edit Profile')),
          const SizedBox(height: 10),
          OutlinedButton(onPressed: () {}, child: const Text('Settings')),
        ],
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String title;
  final String value;

  const _ProfileStat({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.tealAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(title),
          ],
        ),
      ),
    );
  }
}
