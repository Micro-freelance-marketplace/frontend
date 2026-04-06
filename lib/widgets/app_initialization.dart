import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class AppInitialization extends StatefulWidget {
  final Widget child;

  const AppInitialization({
    super.key,
    required this.child,
  });

  @override
  State<AppInitialization> createState() => _AppInitializationState();
}

class _AppInitializationState extends State<AppInitialization> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    // Only initialize if not already initialized
    if (!authProvider.isInitialized) {
      await authProvider.initialize();
    }
    
    if (mounted) {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // Show loading screen only during initial initialization
        if (!_isInitialized && authProvider.isLoading) {
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

        // Once initialized, show the app content
        return widget.child;
      },
    );
  }
}
