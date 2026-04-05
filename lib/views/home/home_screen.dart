import 'package:flutter/material.dart';

import '../../models/gig.dart';
import '../../widgets/gig_card.dart';
import '../../widgets/section_title.dart';
import '../../widgets/stat_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const List<String> _categories = [
    'Design',
    'Writing',
    'Tutoring',
    'Video',
    'Coding',
    'Marketing',
  ];

  static const List<Gig> _hotGigs = [
    Gig(
      title: 'Design an event poster',
      category: 'Design',
      budget: 'USD 24',
      sellerName: 'Aisha',
    ),
    Gig(
      title: 'Proofread assignment report',
      category: 'Writing',
      budget: 'USD 18',
      sellerName: 'Hassan',
    ),
    Gig(
      title: 'Flutter UI landing page',
      category: 'Coding',
      budget: 'USD 40',
      sellerName: 'Nadia',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Hi, Mr. X 👋',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 4),
          Text(
            'Ready to find your next freelance task?',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          const Row(
            children: [
              Expanded(
                child: StatCard(title: 'Active Gigs', value: '12'),
              ),
              SizedBox(width: 10),
              Expanded(
                child: StatCard(title: 'Orders', value: '34'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Row(
            children: [
              Expanded(
                child: StatCard(title: 'Earnings', value: 'USD 246'),
              ),
              SizedBox(width: 10),
              Expanded(
                child: StatCard(title: 'Rating', value: '4.8'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const SectionTitle(title: 'Categories'),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _categories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 2.6,
            ),
            itemBuilder: (context, index) {
              return Card(child: Center(child: Text(_categories[index])));
            },
          ),
          const SizedBox(height: 20),
          const SectionTitle(title: 'Hot Gigs'),
          ..._hotGigs.map((gig) => GigCard(gig: gig)),
        ],
      ),
    );
  }
}
