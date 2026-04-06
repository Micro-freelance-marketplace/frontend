import 'package:dio/dio.dart';
import 'api_client.dart';
import '../models/user_model.dart';
import '../models/review_model.dart';
import '../models/skill_model.dart';

class UserService {
  final ApiClient _apiClient = ApiClient();

  /// Get user profile by ID
  Future<UserModel> getUserProfile(String userId) async {
    try {
      final response = await _apiClient.dio.get('/users/$userId');

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      } else {
        throw Exception('User not found');
      }
    } on DioException catch (e) {
      throw _handleUserError(e);
    }
  }

  /// Update current user profile
  Future<UserModel> updateProfile({
    String? name,
    String? department,
    String? aboutMe,
    bool? isFreelancer,
  }) async {
    try {
      final data = <String, dynamic>{};
      
      if (name != null) data['name'] = name;
      if (department != null) data['department'] = department;
      if (aboutMe != null) data['about_me'] = aboutMe;
      if (isFreelancer != null) data['is_freelancer'] = isFreelancer;

      final response = await _apiClient.dio.put('/users/profile', data: data);

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      } else {
        throw Exception('Failed to update profile');
      }
    } on DioException catch (e) {
      throw _handleUserError(e);
    }
  }

  /// Upload profile image
  Future<String> uploadProfileImage(String imagePath) async {
    try {
      final formData = FormData.fromMap({
        'profile_image': await MultipartFile.fromFile(imagePath),
      });

      final response = await _apiClient.dio.post('/users/profile-image', data: formData);

      if (response.statusCode == 200) {
        return response.data['profile_image_url'];
      } else {
        throw Exception('Failed to upload profile image');
      }
    } on DioException catch (e) {
      throw _handleUserError(e);
    }
  }

  /// Get user skills
  Future<List<SkillModel>> getUserSkills(String userId) async {
    try {
      final response = await _apiClient.dio.get('/users/$userId/skills');

      if (response.statusCode == 200) {
        final skillsData = response.data['data'] as List;
        return skillsData.map((skill) => SkillModel.fromJson(skill)).toList();
      } else {
        throw Exception('Failed to fetch user skills');
      }
    } on DioException catch (e) {
      throw _handleUserError(e);
    }
  }

  /// Add skill to user profile
  Future<SkillModel> addSkill({
    required String skillId,
    required SkillLevel level,
    double? yearsOfExperience,
  }) async {
    try {
      final response = await _apiClient.dio.post('/users/skills', data: {
        'skill_id': skillId,
        'level': level.name,
        if (yearsOfExperience != null) 'years_of_experience': yearsOfExperience,
      });

      if (response.statusCode == 201) {
        return SkillModel.fromJson(response.data);
      } else {
        throw Exception('Failed to add skill');
      }
    } on DioException catch (e) {
      throw _handleUserError(e);
    }
  }

  /// Update user skill
  Future<SkillModel> updateSkill(String skillId, {
    SkillLevel? level,
    double? yearsOfExperience,
  }) async {
    try {
      final data = <String, dynamic>{};
      
      if (level != null) data['level'] = level.name;
      if (yearsOfExperience != null) data['years_of_experience'] = yearsOfExperience;

      final response = await _apiClient.dio.put('/users/skills/$skillId', data: data);

      if (response.statusCode == 200) {
        return SkillModel.fromJson(response.data);
      } else {
        throw Exception('Failed to update skill');
      }
    } on DioException catch (e) {
      throw _handleUserError(e);
    }
  }

  /// Remove skill from user profile
  Future<void> removeSkill(String skillId) async {
    try {
      final response = await _apiClient.dio.delete('/users/skills/$skillId');

      if (response.statusCode != 200) {
        throw Exception('Failed to remove skill');
      }
    } on DioException catch (e) {
      throw _handleUserError(e);
    }
  }

  /// Get user reviews
  Future<List<ReviewModel>> getUserReviews(String userId, {
    ReviewType? type,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };

      if (type != null) queryParams['type'] = type.name;

      final response = await _apiClient.dio.get('/users/$userId/reviews', queryParameters: queryParams);

      if (response.statusCode == 200) {
        final reviewsData = response.data['data'] as List;
        return reviewsData.map((review) => ReviewModel.fromJson(review)).toList();
      } else {
        throw Exception('Failed to fetch user reviews');
      }
    } on DioException catch (e) {
      throw _handleUserError(e);
    }
  }

  /// Add review for user
  Future<ReviewModel> addReview({
    required String userId,
    required String gigId,
    required double rating,
    required String comment,
    required ReviewType reviewType,
    double? communicationRating,
    double? qualityRating,
    double? timelinessRating,
    double? professionalismRating,
  }) async {
    try {
      final data = <String, dynamic>{
        'gig_id': gigId,
        'rating': rating,
        'comment': comment,
        'review_type': reviewType.name,
      };

      if (communicationRating != null) data['communication_rating'] = communicationRating;
      if (qualityRating != null) data['quality_rating'] = qualityRating;
      if (timelinessRating != null) data['timeliness_rating'] = timelinessRating;
      if (professionalismRating != null) data['professionalism_rating'] = professionalismRating;

      final response = await _apiClient.dio.post('/users/$userId/reviews', data: data);

      if (response.statusCode == 201) {
        return ReviewModel.fromJson(response.data);
      } else {
        throw Exception('Failed to add review');
      }
    } on DioException catch (e) {
      throw _handleUserError(e);
    }
  }

  /// Respond to review
  Future<ReviewModel> respondToReview(String reviewId, String response) async {
    try {
      final apiResponse = await _apiClient.dio.post('/reviews/$reviewId/respond', data: {
        'response': response,
      });

      if (apiResponse.statusCode == 200) {
        return ReviewModel.fromJson(apiResponse.data);
      } else {
        throw Exception('Failed to respond to review');
      }
    } on DioException catch (e) {
      throw _handleUserError(e);
    }
  }

  /// Get user statistics
  Future<Map<String, dynamic>> getUserStats(String userId) async {
    try {
      final response = await _apiClient.dio.get('/users/$userId/stats');

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Failed to fetch user statistics');
      }
    } on DioException catch (e) {
      throw _handleUserError(e);
    }
  }

  /// Get user portfolio
  Future<List<Map<String, dynamic>>> getUserPortfolio(String userId) async {
    try {
      final response = await _apiClient.dio.get('/users/$userId/portfolio');

      if (response.statusCode == 200) {
        final portfolioData = response.data['data'] as List;
        return portfolioData.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to fetch user portfolio');
      }
    } on DioException catch (e) {
      throw _handleUserError(e);
    }
  }

  /// Add portfolio item
  Future<Map<String, dynamic>> addPortfolioItem({
    required String title,
    required String description,
    required List<String> images,
    required List<String> tags,
    String? projectUrl,
  }) async {
    try {
      final data = <String, dynamic>{
        'title': title,
        'description': description,
        'images': images,
        'tags': tags,
      };

      if (projectUrl != null) data['project_url'] = projectUrl;

      final response = await _apiClient.dio.post('/users/portfolio', data: data);

      if (response.statusCode == 201) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Failed to add portfolio item');
      }
    } on DioException catch (e) {
      throw _handleUserError(e);
    }
  }

  /// Delete portfolio item
  Future<void> deletePortfolioItem(String portfolioId) async {
    try {
      final response = await _apiClient.dio.delete('/users/portfolio/$portfolioId');

      if (response.statusCode != 200) {
        throw Exception('Failed to delete portfolio item');
      }
    } on DioException catch (e) {
      throw _handleUserError(e);
    }
  }

  /// Endorse user skill
  Future<void> endorseSkill(String userId, String skillId) async {
    try {
      final response = await _apiClient.dio.post('/users/$userId/skills/$skillId/endorse');

      if (response.statusCode != 200) {
        throw Exception('Failed to endorse skill');
      }
    } on DioException catch (e) {
      throw _handleUserError(e);
    }
  }

  /// Report user
  Future<void> reportUser(String userId, String reason) async {
    try {
      await _apiClient.dio.post('/users/$userId/report', data: {
        'reason': reason,
      });
    } on DioException catch (e) {
      throw _handleUserError(e);
    }
  }

  DioException _handleUserError(DioException error) {
    if (error.response?.statusCode == 404) {
      return DioException(
        requestOptions: error.requestOptions,
        response: error.response,
        error: 'User not found',
        type: DioExceptionType.badResponse,
      );
    } else if (error.response?.statusCode == 403) {
      return DioException(
        requestOptions: error.requestOptions,
        response: error.response,
        error: 'You don\'t have permission to perform this action',
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
    
    return error;
  }
}
