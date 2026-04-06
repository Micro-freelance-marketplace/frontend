import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final StorageService _storage = StorageService();

  // State
  UserModel? _user;
  bool _isLoading = false;
  bool _isInitialized = false;
  String? _errorMessage;

  // Getters
  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;
  bool get isAuthenticated => _user != null && _isInitialized;
  String? get errorMessage => _errorMessage;

  // Convenience getters
  bool isFreelancer() => _user?.isFreelancer ?? false;
  bool isVerified() => _user?.isVerified ?? false;
  String get displayName => _user?.name ?? 'Guest';
  String get userEmail => _user?.email ?? '';

  // Private methods
  void _setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      notifyListeners();
    }
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _setUser(UserModel? user) {
    _user = user;
    _isInitialized = true;
    _clearError();
    notifyListeners();
    
    if (kDebugMode) {
      print('Auth: User state updated - ${user?.email ?? "null"}');
    }
  }

  // Initialize provider - check if user is already logged in
  Future<void> initialize() async {
    if (_isInitialized) return; // Don't re-initialize
    
    _setLoading(true);
    try {
      if (kDebugMode) {
        print('Auth: Initializing auth provider...');
      }
      
      // Check if we have a stored token
      final token = _storage.getToken();
      final userData = _storage.getUser();
      
      if (token != null && userData != null) {
        if (kDebugMode) {
          print('Auth: Found stored auth data, validating...');
        }
        
        // Try to get current user to validate token
        try {
          final currentUser = await _authService.getCurrentUser();
          _setUser(currentUser);
        } catch (e) {
          if (kDebugMode) {
            print('Auth: Token validation failed - $e');
          }
          // Token is invalid, clear stored data
          await _clearStoredAuth();
          _setUser(null);
        }
      } else {
        if (kDebugMode) {
          print('Auth: No stored auth data found');
        }
        _setUser(null);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Auth: Error during initialization - $e');
      }
      _setUser(null);
    } finally {
      _setLoading(false);
    }
  }

  // Clear stored authentication data
  Future<void> _clearStoredAuth() async {
    await Future.wait([
      _storage.clearToken(),
      _storage.clearUser(),
    ]);
  }

  // Login user
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      if (kDebugMode) {
        print('Auth: Attempting login for $email');
      }
      
      final user = await _authService.login(email: email, password: password);
      _setUser(user);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Auth: Login failed - $e');
      }
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Register new user
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String department,
    String? aboutMe,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      if (kDebugMode) {
        print('Auth: Attempting registration for $email');
      }
      
      final user = await _authService.register(
        name: name,
        email: email,
        password: password,
        role: 'freelancer',
        campus: department,
      );
      _setUser(user);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Auth: Registration failed - $e');
      }
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Logout user
  Future<void> logout() async {
    _setLoading(true);
    try {
      if (kDebugMode) {
        print('Auth: Logging out user...');
      }
      await _authService.logout();
      await _clearStoredAuth();
    } catch (e) {
      if (kDebugMode) {
        print('Auth: Logout error - $e');
      }
      // Even if logout fails on server, clear local data
      await _clearStoredAuth();
    } finally {
      _setUser(null);
      _setLoading(false);
    }
  }

  // Refresh user data
  Future<void> refreshUser() async {
    if (!_isInitialized || _user == null) return;

    try {
      if (kDebugMode) {
        print('Auth: Refreshing user data...');
      }
      
      final updatedUser = await _authService.getCurrentUser();
      _setUser(updatedUser);
    } catch (e) {
      if (kDebugMode) {
        print('Auth: Refresh failed - $e');
      }
      // If refresh fails, user might need to re-login
      await logout();
    }
  }

  // Update user profile
  Future<bool> updateProfile({
    String? name,
    String? department,
    String? aboutMe,
    bool? isFreelancer,
  }) async {
    if (!_isInitialized || _user == null) return false;

    _setLoading(true);
    _clearError();

    try {
      if (kDebugMode) {
        print('Auth: Updating user profile...');
      }
      
      final updatedUser = await _authService.updateProfile(
        name: name,
        bio: aboutMe,
        skills: isFreelancer != null ? ['freelancing'] : null,
      );
      _setUser(updatedUser);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Auth: Profile update failed - $e');
      }
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Upload profile image
  Future<String?> uploadProfileImage(String imagePath) async {
    if (!_isInitialized || _user == null) return null;

    _setLoading(true);
    _clearError();

    try {
      if (kDebugMode) {
        print('Auth: Uploading profile image...');
      }
      
      final imageUrl = await _authService.uploadProfileImage(imagePath);
      
      // Update user with new image URL
      final updatedUser = _user!.copyWith(avatar: imageUrl);
      _setUser(updatedUser);
      
      return imageUrl;
    } catch (e) {
      if (kDebugMode) {
        print('Auth: Image upload failed - $e');
      }
      _setError(e.toString());
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Clear error manually
  void clearError() {
    _clearError();
  }

  // Verify email - removed as not in new backend
  Future<bool> verifyEmail(String token) async {
    _setLoading(true);
    _clearError();

    try {
      // Email verification not implemented in new backend
      // Return true for now
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Reset password
  Future<bool> resetPassword(String token, String newPassword) async {
    _setLoading(true);
    _clearError();

    try {
      await _authService.resetPassword(token: token, newPassword: newPassword);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Change password
  Future<bool> changePassword(String currentPassword, String newPassword) async {
    if (!_isInitialized || _user == null) return false;

    _setLoading(true);
    _clearError();

    try {
      await _authService.changePassword(currentPassword: currentPassword, newPassword: newPassword);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }
}
