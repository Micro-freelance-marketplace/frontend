import 'package:dio/dio.dart';
import 'api_client.dart';
import 'api_service.dart';
import '../models/application_model.dart';
import '../models/gig_model.dart';

class ApplicationService {
  final ApiService _apiService = ApiService();

  /// Apply for a gig
  Future<ApplicationModel> applyForGig({
    required String gigId,
    required String proposal,
    String? portfolioUrl,
    int? proposedPrice,
    String? deliveryTime,
  }) async {
    try {
      return await _apiService.applyForGig(
        gigId: gigId,
        proposal: proposal,
        portfolioUrl: portfolioUrl,
        proposedPrice: proposedPrice,
        deliveryTime: deliveryTime,
      );
    } catch (e) {
      throw _handleApplicationError(e);
    }
  }

  /// Get application by ID
  Future<ApplicationModel> getApplicationById(String applicationId) async {
    try {
      final applications = await getUserApplications();
      final application = applications.firstWhere(
        (app) => app.applicationId == applicationId,
        orElse: () => throw Exception('Application not found'),
      );
      return application;
    } catch (e) {
      throw _handleApplicationError(e);
    }
  }

  /// Update application status
  Future<ApplicationModel> updateApplicationStatus({
    required String applicationId,
    required String status,
    String? feedback,
  }) async {
    try {
      return await _apiService.updateApplicationStatus(
        applicationId: applicationId,
        status: status,
        feedback: feedback,
      );
    } catch (e) {
      throw _handleApplicationError(e);
    }
  }

  /// Get user's applications
  Future<List<ApplicationModel>> getUserApplications() async {
    try {
      return await _apiService.getUserApplications();
    } catch (e) {
      throw _handleApplicationError(e);
    }
  }

  /// Get all applications for a gig
  Future<List<ApplicationModel>> getGigApplications(String gigId) async {
    try {
      return await _apiService.getGigApplications(gigId);
    } catch (e) {
      throw _handleApplicationError(e);
    }
  }

  /// Delete application
  Future<void> deleteApplication(String applicationId) async {
    try {
      await _apiService.deleteApplication(applicationId);
    } catch (e) {
      throw _handleApplicationError(e);
    }
  }

  /// Handle application-related errors
  Exception _handleApplicationError(dynamic error) {
    if (error is DioException) {
      if (error.response?.statusCode == 401) {
        return Exception('Unauthorized. Please login to access applications.');
      } else if (error.response?.statusCode == 403) {
        return Exception('You don\'t have permission to perform this action.');
      } else if (error.response?.statusCode == 404) {
        return Exception('Application not found.');
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
    
    return Exception('Failed to load applications. Please try again.');
  }
}
