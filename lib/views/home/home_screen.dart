import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/gig_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/gig_provider.dart';
import '../../widgets/enhanced_gig_card.dart';
import '../../widgets/category_chip.dart';
import '../../widgets/section_title.dart';
import '../../widgets/stat_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize data when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });
  }

  Future<void> _initializeData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final gigProvider = Provider.of<GigProvider>(context, listen: false);
    
    // Only fetch data if user is authenticated
    if (authProvider.isAuthenticated) {
      // Fetch hot gigs
      await gigProvider.fetchHotGigs();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Consumer2<AuthProvider, GigProvider>(
        builder: (context, authProvider, gigProvider, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Welcome message
              _buildWelcomeSection(authProvider),
              
              // Stats cards
              _buildStatsSection(),
              
              // Categories
              _buildCategoriesSection(),
              
              // Hot gigs
              _buildHotGigsSection(gigProvider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildWelcomeSection(AuthProvider authProvider) {
    final userName = authProvider.user?.name ?? 'Student';
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hi, $userName 👋',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 4),
        Text(
          'Ready to find your next freelance task?',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildStatsSection() {
    return Column(
      children: [
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
      ],
    );
  }

  Widget _buildCategoriesSection() {
    final categories = [
      {'name': 'Design', 'icon': '🎨', 'color': '#FF6B6B'},
      {'name': 'Writing', 'icon': '✍️', 'color': '#4ECDC4'},
      {'name': 'Tutoring', 'icon': '📚', 'color': '#45B7D1'},
      {'name': 'Video', 'icon': '🎬', 'color': '#96CEB4'},
      {'name': 'Coding', 'icon': '💻', 'color': '#FFEAA7'},
      {'name': 'Marketing', 'icon': '📱', 'color': '#DDA0DD'},
    ];

    return Column(
      children: [
        const SectionTitle(title: 'Categories'),
        CategoryGrid(categories: categories),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildHotGigsSection(GigProvider gigProvider) {
    if (gigProvider.isLoading && gigProvider.hotGigs.isEmpty) {
      return const Column(
        children: [
          SectionTitle(title: 'Hot Gigs'),
          SizedBox(height: 20),
          Center(child: CircularProgressIndicator()),
        ],
      );
    }

    if (gigProvider.hotGigs.isEmpty) {
      return const Column(
        children: [
          SectionTitle(title: 'Hot Gigs'),
          SizedBox(height: 20),
          Center(child: Text('No hot gigs available')),
        ],
      );
    }

    return Column(
      children: [
        const SectionTitle(title: 'Hot Gigs'),
        ...gigProvider.hotGigs.map((gig) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: EnhancedGigCard(gig: gig),
        )),
      ],
    );
  }
}
