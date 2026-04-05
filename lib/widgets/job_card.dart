import 'package:flutter/material.dart';

import '../models/job.dart';

class JobCard extends StatelessWidget {
  final Job job;

  const JobCard({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        title: Text(job.title),
        subtitle: Text('${job.company} • ${job.location}'),
        trailing: Text(
          job.payment,
          style: const TextStyle(
            color: Colors.tealAccent,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
