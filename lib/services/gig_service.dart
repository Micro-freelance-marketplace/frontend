import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'api_client.dart';
import 'api_service.dart';
import '../models/gig_model.dart';
import '../models/category_model.dart';

class GigService {
  final ApiService _apiService = ApiService();

  /// Get all gigs with optional filters
  Future<List<GigModel>> getGigs({
    String? category,
    String? search,
    double? minPrice,
    double? maxPrice,
    bool? isRemote,
    String? location,
    GigStatus? status,
    String? sortBy,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      return await _apiService.getGigs(
        category: category,
        search: search,
        page: page,
        limit: limit,
        sortBy: sortBy,
      );
    } catch (e) {
      throw _handleGigError(e);
    }
  }

  /// Get gig by ID
  Future<GigModel> getGigById(String gigId) async {
    try {
      return await _apiService.getGigById(gigId);
    } catch (e) {
      throw _handleGigError(e);
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
      return await _apiService.createGig(
        title: title,
        description: description,
        category: category,
        price: price,
        deliveryTime: deliveryTime,
        requirements: requirements,
        tags: tags,
      );
    } catch (e) {
      throw _handleGigError(e);
    }
  }

  /// Update existing gig
  Future<GigModel> updateGig(String gigId, {
    String? title,
    String? description,
    String? category,
    int? price,
    String? deliveryTime,
    List<String>? requirements,
    List<String>? tags,
  }) async {
    try {
      return await _apiService.updateGig(
        gigId: gigId,
        title: title,
        description: description,
        category: category,
        price: price,
        deliveryTime: deliveryTime,
        requirements: requirements,
        tags: tags,
      );
    } catch (e) {
      throw _handleGigError(e);
    }
  }

  /// Delete gig (close gig)
  Future<void> deleteGig(String gigId) async {
    try {
      await _apiService.deleteGig(gigId);
    } catch (e) {
      throw _handleGigError(e);
    }
  }

  /// Get gigs posted by current user
  Future<List<GigModel>> getMyGigs({
    GigStatus? status,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      return await _apiService.getUserGigs();
    } catch (e) {
      throw _handleGigError(e);
    }
  }

  /// Get hot/featured gigs
  Future<List<GigModel>> getHotGigs({int limit = 10}) async {
    try {
      return await _apiService.getHotGigs();
    } catch (e) {
      throw _handleGigError(e);
    }
  }

  /// Get gigs by category
  Future<List<GigModel>> getGigsByCategory(String categoryId, {int limit = 20}) async {
    try {
      return await _apiService.getGigs(category: categoryId, limit: limit);
    } catch (e) {
      throw _handleGigError(e);
    }
  }

  /// Search gigs
  Future<List<GigModel>> searchGigs(String query, {int page = 1, int limit = 20}) async {
    try {
      return await _apiService.searchGigs(query);
    } catch (e) {
      throw _handleGigError(e);
    }
  }

  /// Handle gig-related errors
  Exception _handleGigError(dynamic error) {
    if (error is DioException) {
      if (error.response?.statusCode == 401) {
        return Exception('Unauthorized. Please login to access gigs.');
      } else if (error.response?.statusCode == 403) {
        return Exception('You don\'t have permission to perform this action.');
      } else if (error.response?.statusCode == 404) {
        return Exception('Gig not found.');
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
    
    return Exception('Failed to load gigs. Please try again.');
  }
}
