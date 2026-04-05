import 'package:flutter/material.dart';

import '../../models/gig.dart';
import '../../widgets/gig_card.dart';

class BrowseScreen extends StatelessWidget {
  const BrowseScreen({super.key});

  static const List<String> _categories = [
    'All',
    'Design',
    'Writing',
    'Tech',
    'Video',
    'Tutoring',
  ];

  static const List<Gig> _gigs = [
    Gig(
      title: 'Instagram post design pack',
      category: 'Design',
      budget: 'USD 20',
      sellerName: 'Rafi',
    ),
    Gig(
      title: 'Quick CV review and edit',
      category: 'Writing',
      budget: 'USD 15',
      sellerName: 'Mina',
    ),
    Gig(
      title: 'Build simple Flutter UI',
      category: 'Tech',
      budget: 'USD 45',
      sellerName: 'Sami',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Browse')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Search gigs...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: const Color(0xFF232323),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _categories
                .map(
                  (category) => Chip(
                    label: Text(category),
                    backgroundColor: const Color(0xFF2A2A2A),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 18),
          ..._gigs.map((gig) => GigCard(gig: gig)),
        ],
      ),
    );
  }
}
