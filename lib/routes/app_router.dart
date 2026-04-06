import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';
import '../views/auth/login_screen.dart';
import '../views/auth/signup_screen.dart';
import '../views/main_screen.dart';

// Route names
class AppRoutes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String browse = '/browse';
  static const String post = '/post';
  static const String jobs = '/jobs';
  static const String profile = '/profile';
  static const String gigDetails = '/gig/:gigId';
  static const String userProfile = '/user/:userId';
  static const String editProfile = '/profile/edit';
  static const String applications = '/applications';
  static const String gigApplications = '/gig/:gigId/applications';
  static const String createGig = '/gig/create';
  static const String editGig = '/gig/:gigId/edit';
}

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.home,
    redirect: (context, state) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      // If auth provider is still loading, don't redirect
      if (authProvider.isLoading) {
        return null;
      }
      
      final currentPath = state.uri.toString();
      
      // Only redirect from login/signup if authenticated
      if ((currentPath == AppRoutes.login || currentPath == AppRoutes.signup) && 
          authProvider.isAuthenticated) {
        return AppRoutes.home;
      }
      
      // Only redirect to login for protected routes if not authenticated
      final protectedRoutes = [
        AppRoutes.home,
        AppRoutes.browse,
        AppRoutes.post,
        AppRoutes.jobs,
        AppRoutes.profile,
        AppRoutes.userProfile,
        AppRoutes.editProfile,
        AppRoutes.applications,
        AppRoutes.gigApplications,
        AppRoutes.createGig,
        AppRoutes.editGig,
      ];
      
      if (!authProvider.isAuthenticated && protectedRoutes.contains(currentPath)) {
        return AppRoutes.login;
      }
      
      return null;
    },
    routes: [
      // Authentication routes
      GoRoute(
        path: AppRoutes.login,
        name: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.signup,
        name: AppRoutes.signup,
        builder: (context, state) => const SignupScreen(),
      ),
      
      // Main app routes (wrapped in MainScreen for bottom navigation)
      GoRoute(
        path: AppRoutes.home,
        name: AppRoutes.home,
        builder: (context, state) => const MainScreen(
          initialIndex: 0,
        ),
      ),
      GoRoute(
        path: AppRoutes.browse,
        name: AppRoutes.browse,
        builder: (context, state) => const MainScreen(
          initialIndex: 1,
        ),
      ),
      GoRoute(
        path: AppRoutes.post,
        name: AppRoutes.post,
        builder: (context, state) => const MainScreen(
          initialIndex: 2,
        ),
      ),
      GoRoute(
        path: AppRoutes.jobs,
        name: AppRoutes.jobs,
        builder: (context, state) => const MainScreen(
          initialIndex: 3,
        ),
      ),
      GoRoute(
        path: AppRoutes.profile,
        name: AppRoutes.profile,
        builder: (context, state) => const MainScreen(
          initialIndex: 4,
        ),
      ),
      
      // Gig details route
      GoRoute(
        path: AppRoutes.gigDetails,
        name: AppRoutes.gigDetails,
        builder: (context, state) {
          final gigId = state.pathParameters['gigId']!;
          return MainScreen(
            initialIndex: 1, // Browse tab
            child: GigDetailsScreen(gigId: gigId),
          );
        },
      ),
      
      // User profile route
      GoRoute(
        path: AppRoutes.userProfile,
        name: AppRoutes.userProfile,
        builder: (context, state) {
          final userId = state.pathParameters['userId']!;
          return MainScreen(
            initialIndex: 4, // Profile tab
            child: UserProfileScreen(userId: userId),
          );
        },
      ),
      
      // Edit profile route
      GoRoute(
        path: AppRoutes.editProfile,
        name: AppRoutes.editProfile,
        builder: (context, state) {
          return MainScreen(
            initialIndex: 4, // Profile tab
            child: EditProfileScreen(),
          );
        },
      ),
      
      // Applications route
      GoRoute(
        path: AppRoutes.applications,
        name: AppRoutes.applications,
        builder: (context, state) {
          return MainScreen(
            initialIndex: 3, // Jobs tab
            child: ApplicationsScreen(),
          );
        },
      ),
      
      // Gig applications route (for gig owners)
      GoRoute(
        path: AppRoutes.gigApplications,
        name: AppRoutes.gigApplications,
        builder: (context, state) {
          final gigId = state.pathParameters['gigId']!;
          return MainScreen(
            initialIndex: 3, // Jobs tab
            child: GigApplicationsScreen(gigId: gigId),
          );
        },
      ),
      
      // Create gig route
      GoRoute(
        path: AppRoutes.createGig,
        name: AppRoutes.createGig,
        builder: (context, state) {
          return MainScreen(
            initialIndex: 2, // Post tab
            child: CreateGigScreen(),
          );
        },
      ),
      
      // Edit gig route
      GoRoute(
        path: AppRoutes.editGig,
        name: AppRoutes.editGig,
        builder: (context, state) {
          final gigId = state.pathParameters['gigId']!;
          return MainScreen(
            initialIndex: 2, // Post tab
            child: EditGigScreen(gigId: gigId),
          );
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'The page you\'re looking for doesn\'t exist.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
}

// Placeholder screens for routes that don't exist yet
class GigDetailsScreen extends StatelessWidget {
  final String gigId;
  
  const GigDetailsScreen({super.key, required this.gigId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gig Details'),
      ),
      body: Center(
        child: Text('Gig Details: $gigId'),
      ),
    );
  }
}

class UserProfileScreen extends StatelessWidget {
  final String userId;
  
  const UserProfileScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: Center(
        child: Text('User Profile: $userId'),
      ),
    );
  }
}

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: const Center(
        child: Text('Edit Profile Screen'),
      ),
    );
  }
}

class ApplicationsScreen extends StatelessWidget {
  const ApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Applications'),
      ),
      body: const Center(
        child: Text('Applications Screen'),
      ),
    );
  }
}

class GigApplicationsScreen extends StatelessWidget {
  final String gigId;
  
  const GigApplicationsScreen({super.key, required this.gigId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gig Applications'),
      ),
      body: Center(
        child: Text('Applications for Gig: $gigId'),
      ),
    );
  }
}

class CreateGigScreen extends StatelessWidget {
  const CreateGigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Gig'),
      ),
      body: const Center(
        child: Text('Create Gig Screen'),
      ),
    );
  }
}

class EditGigScreen extends StatelessWidget {
  final String gigId;
  
  const EditGigScreen({super.key, required this.gigId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Gig'),
      ),
      body: Center(
        child: Text('Edit Gig: $gigId'),
      ),
    );
  }
}
