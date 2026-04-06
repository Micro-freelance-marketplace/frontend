class AppConstants {
  // App Info
  static const String appName = 'EduGig';
  static const String appTagline = 'Student Freelance Marketplace';
  
  // API
  static const String baseUrl = 'http://localhost:5000';
  static const String apiVersion = '/api';
  static const String apiUrl = '$baseUrl$apiVersion';
  
  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String themeKey = 'theme_mode';
  
  // Validation
  static const int minPasswordLength = 8;
  static const String emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  static const String eduEmailRegex = r'^[\w-\.]+@([\w-]+\.)+edu$';
  
  // UI
  static const double defaultPadding = 16.0;
  static const double cardRadius = 16.0;
  static const double buttonRadius = 12.0;
  
  // Categories
  static const List<String> categories = [
    'Design',
    'Programming',
    'Writing',
    'Marketing',
    'Video Editing',
    'Tutoring',
  ];
}
