import 'package:flutter/material.dart';

import '../../widgets/app_text_field.dart';

class PostScreen extends StatelessWidget {
  const PostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post a Gig')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const AppTextField(label: 'Gig Title'),
          const SizedBox(height: 12),
          const AppTextField(label: 'Category'),
          const SizedBox(height: 12),
          const AppTextField(label: 'Budget'),
          const SizedBox(height: 12),
          const AppTextField(label: 'Description', maxLines: 4),
          const SizedBox(height: 20),
          FilledButton(onPressed: () {}, child: const Text('Submit Gig')),
        ],
      ),
    );
  }
}
