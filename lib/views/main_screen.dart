import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../routes/app_router.dart';
import '../providers/auth_provider.dart';
import 'browse/browse_screen.dart';
import 'home/home_screen.dart';
import 'jobs/jobs_screen.dart';
import 'post/post_screen.dart';
import 'profile/profile_screen.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex;
  final Widget? child;

  const MainScreen({
    super.key,
    this.initialIndex = 0,
    this.child,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _selectedIndex;
  late PageController _pageController;

  final List<Widget> _tabs = const [
    HomeScreen(),
    BrowseScreen(),
    PostScreen(),
    JobsScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return; // Don't do anything if tapping the same tab
    
    setState(() {
      _selectedIndex = index;
    });
    
    // Animate to the selected page
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    
    // Update the URL to match the selected tab
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;
      
      switch (index) {
        case 0:
          context.go(AppRoutes.home);
          break;
        case 1:
          context.go(AppRoutes.browse);
          break;
        case 2:
          context.go(AppRoutes.post);
          break;
        case 3:
          context.go(AppRoutes.jobs);
          break;
        case 4:
          context.go(AppRoutes.profile);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // If a child widget is provided, show it instead of tab content
    // This is used for nested navigation within tabs
    final body = widget.child;

    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // Check authentication state
        if (!authProvider.isAuthenticated && !authProvider.isLoading) {
          // If not authenticated, redirect to login
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.go(AppRoutes.login);
          });
          return const Scaffold(
            backgroundColor: Color(0xFF1A1A2E),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4A90E2)),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Loading...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Show loading indicator while initializing
        if (authProvider.isLoading && !authProvider.isInitialized) {
          return const Scaffold(
            backgroundColor: Color(0xFF1A1A2E),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4A90E2)),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Initializing...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: const Color(0xFF1A1A2E),
          body: body ?? PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(), // Prevent swiping
            children: _tabs,
          ),
          bottomNavigationBar: widget.child == null
              ? Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF1A1A2E),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: _buildNavItems(context),
                      ),
                    ),
                  ),
                )
              : null, // Hide bottom navigation when showing nested content
        );
      },
    );
  }

  List<Widget> _buildNavItems(BuildContext context) {
    return [
      _buildNavItem(context, 0, Icons.home_outlined, Icons.home, 'Home'),
      _buildNavItem(context, 1, Icons.search_outlined, Icons.search, 'Browse'),
      _buildCenterButton(context, 2, Icons.add_box_outlined, Icons.add_box, 'Post'),
      _buildNavItem(context, 3, Icons.work_outline, Icons.work, 'Jobs'),
      _buildNavItem(context, 4, Icons.person_outline, Icons.person, 'Profile'),
    ];
  }

  Widget _buildNavItem(BuildContext context, int index, IconData icon, IconData activeIcon, String label) {
    final isActive = _selectedIndex == index;
    
    return Expanded(
      child: GestureDetector(
        onTap: () => _onItemTapped(index),
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isActive ? activeIcon : icon,
                size: 24,
                color: isActive 
                    ? const Color(0xFF00D084)
                    : Colors.grey[600],
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isActive 
                      ? const Color(0xFF00D084)
                      : Colors.grey[600],
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCenterButton(BuildContext context, int index, IconData icon, IconData activeIcon, String label) {
    final isActive = _selectedIndex == index;
    
    return Expanded(
      child: GestureDetector(
        onTap: () => _onItemTapped(index),
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isActive ? const Color(0xFF00D084) : const Color(0xFF2A2A3E),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: const Color(0xFF00D084).withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Icon(
                  isActive ? activeIcon : icon,
                  size: 28,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isActive 
                      ? const Color(0xFF00D084)
                      : Colors.grey[600],
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
