import 'package:dio/dio.dart';
import 'api_client.dart';
import '../models/gig_model.dart';
import '../models/application_model.dart';
import '../models/user_model.dart';
import 'storage_service.dart';

class ApiService {
  final ApiClient _apiClient = ApiClient();
  final StorageService _storage = StorageService();

  // ==================== AUTHENTICATION ====================

  /// Login user with email and password
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Login failed');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Register new user
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    String? role,
    required String campus,
  }) async {
    try {
      final response = await _apiClient.post('/auth/register', data: {
        'name': name,
        'email': email,
        'password': password,
        'role': role ?? 'freelancer',
        'campus': campus,
      });

      if (response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception('Registration failed');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      await _apiClient.post('/auth/logout');
    } catch (e) {
      // Even if logout fails on server, clear local data
      await _storage.logout();
    }
  }

  /// Get current user profile
  Future<Map<String, dynamic>> getCurrentUserProfile() async {
    try {
      final response = await _apiClient.get('/api/profile');

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to get user profile');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Create user profile
  Future<Map<String, dynamic>> createProfile({
    required String name,
    String? bio,
    List<String>? skills,
  }) async {
    try {
      final data = <String, dynamic>{
        'name': name,
      };
      if (bio != null) data['bio'] = bio;
      if (skills != null) data['skills'] = skills;

      final response = await _apiClient.post('/api/profile', data: data);

      if (response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception('Failed to create profile');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Update user profile
  Future<Map<String, dynamic>> updateProfile({
    String? name,
    String? bio,
    List<String>? skills,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (name != null) data['name'] = name;
      if (bio != null) data['bio'] = bio;
      if (skills != null) data['skills'] = skills;

      final response = await _apiClient.put('/api/profile', data: data);

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to update profile');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Delete user profile
  Future<Map<String, dynamic>> deleteProfile() async {
    try {
      final response = await _apiClient.delete('/api/profile');

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to delete profile');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Upload profile avatar
  Future<Map<String, dynamic>> uploadProfileAvatar(String imagePath) async {
    try {
      final formData = FormData.fromMap({
        'avatar': await MultipartFile.fromFile(imagePath),
      });

      final response = await _apiClient.post('/api/profile/avatar', data: formData);

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to upload profile avatar');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Delete profile avatar
  Future<Map<String, dynamic>> deleteProfileAvatar() async {
    try {
      final response = await _apiClient.delete('/api/profile/avatar');

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to delete profile avatar');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get current user (for compatibility with existing AuthProvider)
  Future<UserModel> getCurrentUser() async {
    try {
      final profileData = await getCurrentUserProfile();
      return UserModel.fromJson(profileData);
    } catch (e) {
      throw _handleError(e as DioException);
    }
  }

  // ==================== REVIEW MANAGEMENT ====================

  /// Create a review
  Future<Map<String, dynamic>> createReview({
    required String reviewee,
    required String gig,
    required int rating,
    String? comment,
  }) async {
    try {
      final data = <String, dynamic>{
        'reviewee': reviewee,
        'gig': gig,
        'rating': rating,
      };
      if (comment != null) data['comment'] = comment;

      final response = await _apiClient.post('/api/reviews', data: data);

      if (response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception('Failed to create review');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get reviews for a user
  Future<List<Map<String, dynamic>>> getUserReviews(String userId) async {
    try {
      final response = await _apiClient.get('/api/users/$userId/reviews');

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data);
      } else {
        throw Exception('Failed to get user reviews');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Update a review
  Future<Map<String, dynamic>> updateReview({
    required String reviewId,
    int? rating,
    String? comment,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (rating != null) data['rating'] = rating;
      if (comment != null) data['comment'] = comment;

      final response = await _apiClient.put('/api/reviews/$reviewId', data: data);

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to update review');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Delete a review
  Future<Map<String, dynamic>> deleteReview(String reviewId) async {
    try {
      final response = await _apiClient.delete('/api/reviews/$reviewId');

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to delete review');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ==================== GIG MANAGEMENT ====================

  /// Get all gigs with optional filters
  Future<List<GigModel>> getGigs({
    String? category,
    String? search,
    int? page,
    int? limit,
    String? sortBy,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (category != null) queryParams['category'] = category;
      if (search != null) queryParams['search'] = search;
      if (page != null) queryParams['page'] = page;
      if (limit != null) queryParams['limit'] = limit;
      if (sortBy != null) queryParams['sort_by'] = sortBy;

      final response = await _apiClient.get('/gigs', queryParameters: queryParams);

      if (response.statusCode == 200) {
        final gigsData = response.data['gigs'] as List;
        return gigsData.map((gig) => GigModel.fromJson(gig)).toList();
      } else {
        throw Exception('Failed to get gigs');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get gig details by ID
  Future<GigModel> getGigById(String gigId) async {
    try {
      final response = await _apiClient.get('/gigs/$gigId');

      if (response.statusCode == 200) {
        return GigModel.fromJson(response.data);
      } else {
        throw Exception('Failed to get gig details');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Create new gig
  Future<GigModel> createGig({
    required String title,
    required String description,
    required String category,
    required int price,
    required String deliveryTime,
    List<String>? requirements,
    List<String>? tags,
  }) async {
    try {
      final data = {
        'title': title,
        'description': description,
        'category': category,
        'price': price,
        'delivery_time': deliveryTime,
        'requirements': requirements ?? [],
        'tags': tags ?? [],
      };

      final response = await _apiClient.post('/gigs', data: data);

      if (response.statusCode == 201) {
        return GigModel.fromJson(response.data);
      } else {
        throw Exception('Failed to create gig');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Update gig
  Future<GigModel> updateGig({
    required String gigId,
    String? title,
    String? description,
    String? category,
    int? price,
    String? deliveryTime,
    List<String>? requirements,
    List<String>? tags,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (title != null) data['title'] = title;
      if (description != null) data['description'] = description;
      if (category != null) data['category'] = category;
      if (price != null) data['price'] = price;
      if (deliveryTime != null) data['delivery_time'] = deliveryTime;
      if (requirements != null) data['requirements'] = requirements;
      if (tags != null) data['tags'] = tags;

      final response = await _apiClient.put('/gigs/$gigId', data: data);

      if (response.statusCode == 200) {
        return GigModel.fromJson(response.data);
      } else {
        throw Exception('Failed to update gig');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Delete gig
  Future<void> deleteGig(String gigId) async {
    try {
      final response = await _apiClient.delete('/gigs/$gigId');

      if (response.statusCode != 200) {
        throw Exception('Failed to delete gig');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get user's gigs
  Future<List<GigModel>> getUserGigs() async {
    try {
      final response = await _apiClient.get('/gigs/my-gigs');

      if (response.statusCode == 200) {
        final gigsData = response.data['gigs'] as List;
        return gigsData.map((gig) => GigModel.fromJson(gig)).toList();
      } else {
        throw Exception('Failed to get user gigs');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ==================== APPLICATION MANAGEMENT ====================

  /// Get all applications for a gig
  Future<List<ApplicationModel>> getGigApplications(String gigId) async {
    try {
      final response = await _apiClient.get('/gigs/$gigId/applications');

      if (response.statusCode == 200) {
        final applicationsData = response.data['applications'] as List;
        return applicationsData.map((app) => ApplicationModel.fromJson(app)).toList();
      } else {
        throw Exception('Failed to get gig applications');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Apply for a gig
  Future<ApplicationModel> applyForGig({
    required String gigId,
    required String proposal,
    String? portfolioUrl,
    int? proposedPrice,
    String? deliveryTime,
  }) async {
    try {
      final data = {
        'gig_id': gigId,
        'proposal': proposal,
        'portfolio_url': portfolioUrl,
        'proposed_price': proposedPrice,
        'delivery_time': deliveryTime,
      };

      final response = await _apiClient.post('/applications', data: data);

      if (response.statusCode == 201) {
        return ApplicationModel.fromJson(response.data);
      } else {
        throw Exception('Failed to apply for gig');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get user's applications
  Future<List<ApplicationModel>> getUserApplications() async {
    try {
      final response = await _apiClient.get('/applications/my-applications');

      if (response.statusCode == 200) {
        final applicationsData = response.data['applications'] as List;
        return applicationsData.map((app) => ApplicationModel.fromJson(app)).toList();
      } else {
        throw Exception('Failed to get user applications');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Update application status
  Future<ApplicationModel> updateApplicationStatus({
    required String applicationId,
    required String status,
    String? feedback,
  }) async {
    try {
      final data = {
        'status': status,
        if (feedback != null) 'feedback': feedback,
      };

      final response = await _apiClient.put('/applications/$applicationId', data: data);

      if (response.statusCode == 200) {
        return ApplicationModel.fromJson(response.data);
      } else {
        throw Exception('Failed to update application status');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Delete application
  Future<void> deleteApplication(String applicationId) async {
    try {
      final response = await _apiClient.delete('/applications/$applicationId');

      if (response.statusCode != 200) {
        throw Exception('Failed to delete application');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ==================== USER MANAGEMENT ====================

  /// Get user profile by ID
  Future<UserModel> getUserProfile(String userId) async {
    try {
      final response = await _apiClient.get('/users/$userId');

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      } else {
        throw Exception('Failed to get user profile');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get user's gigs by ID
  Future<List<GigModel>> getUserGigsById(String userId) async {
    try {
      final response = await _apiClient.get('/users/$userId/gigs');

      if (response.statusCode == 200) {
        final gigsData = response.data['gigs'] as List;
        return gigsData.map((gig) => GigModel.fromJson(gig)).toList();
      } else {
        throw Exception('Failed to get user gigs');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ==================== UTILITY METHODS ====================

  /// Handle API errors
  Exception _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return Exception('Connection timeout. Please check your internet connection.');
      case DioExceptionType.sendTimeout:
        return Exception('Request timeout. Please try again.');
      case DioExceptionType.receiveTimeout:
        return Exception('Server timeout. Please try again.');
      case DioExceptionType.badResponse:
        if (error.response?.statusCode == 401) {
          return Exception('Unauthorized. Please login again.');
        } else if (error.response?.statusCode == 403) {
          return Exception('Forbidden. You don\'t have permission to access this resource.');
        } else if (error.response?.statusCode == 404) {
          return Exception('Resource not found.');
        } else if (error.response?.statusCode == 422) {
          final errors = error.response?.data['errors'] ?? {};
          String errorMessage = 'Validation error: ';
          
          if (errors is Map) {
            errors.forEach((key, value) {
              errorMessage += '$key: ${value.toString()}, ';
            });
          }
          
          return Exception(errorMessage);
        } else if (error.response?.statusCode == 500) {
          return Exception('Server error. Please try again later.');
        } else {
          return Exception('Request failed with status: ${error.response?.statusCode}');
        }
      case DioExceptionType.cancel:
        return Exception('Request was cancelled.');
      case DioExceptionType.unknown:
        return Exception('Network error. Please check your connection and try again.');
      default:
        return Exception('An unexpected error occurred.');
    }
  }

  /// Search gigs
  Future<List<GigModel>> searchGigs(String query) async {
    return getGigs(search: query);
  }

  /// Get hot/popular gigs
  Future<List<GigModel>> getHotGigs() async {
    return getGigs(sortBy: 'popular', limit: 10);
  }

  /// Get recent gigs
  Future<List<GigModel>> getRecentGigs() async {
    return getGigs(sortBy: 'recent', limit: 10);
  }
}
