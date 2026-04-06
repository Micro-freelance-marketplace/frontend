import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'routes/app_router.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthProvider()..initialize(),
      child: const CampusFreelanceMarketplaceApp(),
    ),
  );
}

class CampusFreelanceMarketplaceApp extends StatelessWidget {
  const CampusFreelanceMarketplaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Campus Freelance Marketplace',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
        useMaterial3: true,
        cardTheme: CardThemeData(
          color: const Color(0xFF1E1E1E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      routerConfig: AppRouter.router,
    );
  }
}
