import 'package:dio/dio.dart';
import 'api_client.dart';
import 'api_service.dart';
import '../models/user_model.dart';
import 'storage_service.dart';
import 'package:flutter/material.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient();
  final ApiService _apiService = ApiService();
  final StorageService _storage = StorageService();

  /// Login user with email and password
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiService.login(email: email, password: password);
      
      final token = response['token'];
      
      // Save token
      await _storage.saveToken(token);
      
      // Get user profile after login
      final userProfile = await _apiService.getCurrentUserProfile();
      await _storage.saveUser(userProfile);
      
      return UserModel.fromJson(userProfile);
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  /// Register new user
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    String? role,
    required String campus,
  }) async {
    try {
      final response = await _apiService.register(
        name: name,
        email: email,
        password: password,
        role: role ?? 'freelancer',
        campus: campus,
      );
      
      // Registration only creates user, doesn't return token
      // User needs to login separately
      throw Exception('Registration successful. Please login with your credentials.');
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      await _apiService.logout();
    } catch (e) {
      // Even if logout fails on server, clear local data
    } finally {
      await _storage.logout();
    }
  }

  /// Get current user
  Future<UserModel> getCurrentUser() async {
    try {
      final profileData = await _apiService.getCurrentUserProfile();
      return UserModel.fromJson(profileData);
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  /// Create user profile (separate from registration)
  Future<UserModel> createProfile({
    required String name,
    String? bio,
    List<String>? skills,
  }) async {
    try {
      final profileData = await _apiService.createProfile(
        name: name,
        bio: bio,
        skills: skills,
      );
      
      await _storage.saveUser(profileData);
      return UserModel.fromJson(profileData);
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  /// Update user profile
  Future<UserModel> updateProfile({
    String? name,
    String? bio,
    List<String>? skills,
  }) async {
    try {
      final updatedProfile = await _apiService.updateProfile(
        name: name,
        bio: bio,
        skills: skills,
      );
      
      await _storage.saveUser(updatedProfile);
      return UserModel.fromJson(updatedProfile);
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  /// Upload profile avatar
  Future<String> uploadProfileImage(String imagePath) async {
    try {
      final response = await _apiService.uploadProfileAvatar(imagePath);
      final avatarUrl = response['avatar'];
      
      // Update stored user data with new avatar
      final currentUser = await getCurrentUser();
      final updatedUser = currentUser.copyWith(avatar: avatarUrl);
      await _storage.saveUser(updatedUser.toJson());
      
      return avatarUrl;
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  /// Delete profile avatar
  Future<void> deleteProfileImage() async {
    try {
      await _apiService.deleteProfileAvatar();
      
      // Update stored user data with empty avatar
      final currentUser = await getCurrentUser();
      final updatedUser = currentUser.copyWith(avatar: '');
      await _storage.saveUser(updatedUser.toJson());
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  /// Request password reset
  Future<void> requestPasswordReset(String email) async {
    try {
      await _apiClient.post('/auth/forgot-password', data: {'email': email});
    } on DioException catch (e) {
      throw _handleAuthError(e);
    }
  }

  /// Reset password with token
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      await _apiClient.post('/auth/reset-password', data: {
        'token': token,
        'new_password': newPassword,
      });
    } on DioException catch (e) {
      throw _handleAuthError(e);
    }
  }

  /// Change user password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _apiClient.post('/auth/change-password', data: {
        'current_password': currentPassword,
        'new_password': newPassword,
      });
    } on DioException catch (e) {
      throw _handleAuthError(e);
    }
  }

  /// Handle authentication errors
  DioException _handleAuthError(dynamic error) {
    if (error is DioException) {
      if (error.response?.statusCode == 401) {
        return DioException(
          requestOptions: error.requestOptions,
          response: error.response,
          error: 'Invalid credentials. Please check your email and password.',
          type: DioExceptionType.badResponse,
        );
      } else if (error.response?.statusCode == 422) {
        final errors = error.response?.data['errors'] ?? {};
        String errorMessage = 'Validation error: ';
        
        if (errors is Map) {
          errors.forEach((key, value) {
            errorMessage += '$key: ${value.toString()}, ';
          });
        }
        
        return DioException(
          requestOptions: error.requestOptions,
          response: error.response,
          error: errorMessage,
          type: DioExceptionType.badResponse,
        );
      }
    }
    
    return DioException(
      requestOptions: RequestOptions(path: ''),
      error: error.toString(),
      type: DioExceptionType.unknown,
    );
  }
}
