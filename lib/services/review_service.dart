import 'package:dio/dio.dart';
import 'api_service.dart';

class ReviewService {
  final ApiService _apiService = ApiService();

  /// Create a review
  Future<Map<String, dynamic>> createReview({
    required String reviewee,
    required String gig,
    required int rating,
    String? comment,
  }) async {
    try {
      return await _apiService.createReview(
        reviewee: reviewee,
        gig: gig,
        rating: rating,
        comment: comment,
      );
    } catch (e) {
      throw _handleReviewError(e);
    }
  }

  /// Get reviews for a user
  Future<List<Map<String, dynamic>>> getUserReviews(String userId) async {
    try {
      return await _apiService.getUserReviews(userId);
    } catch (e) {
      throw _handleReviewError(e);
    }
  }

  /// Update a review
  Future<Map<String, dynamic>> updateReview({
    required String reviewId,
    int? rating,
    String? comment,
  }) async {
    try {
      return await _apiService.updateReview(
        reviewId: reviewId,
        rating: rating,
        comment: comment,
      );
    } catch (e) {
      throw _handleReviewError(e);
    }
  }

  /// Delete a review
  Future<Map<String, dynamic>> deleteReview(String reviewId) async {
    try {
      return await _apiService.deleteReview(reviewId);
    } catch (e) {
      throw _handleReviewError(e);
    }
  }

  /// Check if current user has reviewed a gig
  Future<bool> hasReviewedGig(String gigId, String revieweeId) async {
    try {
      final reviews = await getUserReviews(revieweeId);
      return reviews.any((review) => 
        review['gig']['_id'] == gigId && 
        review['reviewer']['_id'] == getCurrentUserId()
      );
    } catch (e) {
      throw _handleReviewError(e);
    }
  }

  /// Get user's average rating
  Future<double> getUserAverageRating(String userId) async {
    try {
      final reviews = await getUserReviews(userId);
      if (reviews.isEmpty) return 0.0;
      
      final totalRating = reviews.fold<double>(
        0.0, 
        (sum, review) => sum + (review['rating'] as num).toDouble()
      );
      
      return totalRating / reviews.length;
    } catch (e) {
      throw _handleReviewError(e);
    }
  }

  /// Get review by ID
  Future<Map<String, dynamic>> getReviewById(String reviewId) async {
    try {
      // This would require a new endpoint in the backend
      // For now, we'll get all reviews and find the one we need
      throw Exception('Get review by ID not implemented yet');
    } catch (e) {
      throw _handleReviewError(e);
    }
  }

  /// Handle review-related errors
  Exception _handleReviewError(dynamic error) {
    if (error is DioException) {
      if (error.response?.statusCode == 401) {
        return Exception('Unauthorized. Please login to access reviews.');
      } else if (error.response?.statusCode == 403) {
        return Exception('You don\'t have permission to perform this action.');
      } else if (error.response?.statusCode == 404) {
        return Exception('Review not found.');
      } else if (error.response?.statusCode == 400) {
        final message = error.response?.data['message'] ?? 'Bad request';
        if (message.toString().contains('already reviewed')) {
          return Exception('You have already reviewed this gig.');
        }
        return Exception('Validation error: $message');
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
      }
    }
    
    return Exception('Failed to load reviews. Please try again.');
  }

  /// Helper method to get current user ID (would need to be implemented based on auth state)
  String getCurrentUserId() {
    // This should get the current user ID from the auth provider
    // For now, returning a placeholder
    return '';
  }
}
