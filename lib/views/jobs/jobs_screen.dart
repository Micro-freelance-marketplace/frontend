import 'package:flutter/material.dart';

import '../../models/job.dart';
import '../../widgets/job_card.dart';

class JobsScreen extends StatelessWidget {
  const JobsScreen({super.key});

  static const List<Job> _jobs = [
    Job(
      title: 'Campus Magazine Designer',
      company: 'Campus Media Club',
      location: 'Remote',
      payment: 'USD 60',
    ),
    Job(
      title: 'Math Tutor for Freshers',
      company: 'Student Hub',
      location: 'On-site',
      payment: 'USD 30',
    ),
    Job(
      title: 'Short Promo Video Editing',
      company: 'Startup Cell',
      location: 'Remote',
      payment: 'USD 50',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jobs')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: _jobs.map((job) => JobCard(job: job)).toList(),
      ),
    );
  }
}
