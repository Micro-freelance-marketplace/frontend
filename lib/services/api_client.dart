import 'package:dio/dio.dart';
import '../core/constants/app_constants.dart';
import 'storage_service.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  late final Dio _dio;
  final StorageService _storage = StorageService();

  void initialize() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.apiUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Add interceptors
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Add auth token if available
          final token = _getAuthToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onResponse: (response, handler) {
          handler.next(response);
        },
        onError: (error, handler) {
          handler.next(error);
        },
      ),
    );

    // Add logging interceptor for debug mode
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
      ),
    );
  }

  Dio get dio => _dio;

  String? _getAuthToken() {
    return _storage.getToken();
  }

  DioException _handleApiError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return DioException(
          requestOptions: error.requestOptions,
          error: 'Connection timeout. Please check your internet connection.',
          type: DioExceptionType.connectionTimeout,
        );
      case DioExceptionType.sendTimeout:
        return DioException(
          requestOptions: error.requestOptions,
          error: 'Request timeout. Please try again.',
          type: DioExceptionType.sendTimeout,
        );
      case DioExceptionType.receiveTimeout:
        return DioException(
          requestOptions: error.requestOptions,
          error: 'Server timeout. Please try again later.',
          type: DioExceptionType.receiveTimeout,
        );
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = _getErrorMessage(statusCode);
        
        // Handle authentication errors
        if (statusCode == 401) {
          _handleUnauthorized();
        }
        
        return DioException(
          requestOptions: error.requestOptions,
          response: error.response,
          error: message,
          type: DioExceptionType.badResponse,
        );
      case DioExceptionType.cancel:
        return DioException(
          requestOptions: error.requestOptions,
          error: 'Request was cancelled.',
          type: DioExceptionType.cancel,
        );
      case DioExceptionType.unknown:
        return DioException(
          requestOptions: error.requestOptions,
          error: 'Network error. Please check your connection.',
          type: DioExceptionType.unknown,
        );
      default:
        return error;
    }
  }

  String _getErrorMessage(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request. Please check your input.';
      case 401:
        return 'Unauthorized. Please login again.';
      case 403:
        return 'Forbidden. You don\'t have permission to access this resource.';
      case 404:
        return 'Resource not found.';
      case 422:
        return 'Validation error. Please check your input.';
      case 429:
        return 'Too many requests. Please try again later.';
      case 500:
        return 'Internal server error. Please try again later.';
      case 502:
        return 'Server is temporarily unavailable.';
      case 503:
        return 'Service unavailable. Please try again later.';
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }

  void _handleUnauthorized() {
    // Clear stored authentication data
    _storage.logout();
  }

  // Helper methods for common API operations
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.get<T>(path, queryParameters: queryParameters, options: options);
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.post<T>(path, data: data, queryParameters: queryParameters, options: options);
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.put<T>(path, data: data, queryParameters: queryParameters, options: options);
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.delete<T>(path, data: data, queryParameters: queryParameters, options: options);
  }

  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.patch<T>(path, data: data, queryParameters: queryParameters, options: options);
  }

  // File upload helper
  Future<Response<T>> upload<T>(
    String path,
    FormData formData, {
    ProgressCallback? onSendProgress,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.post<T>(
      path,
      data: formData,
      queryParameters: queryParameters,
      options: options,
      onSendProgress: onSendProgress,
    );
  }

  // Check if the API is available
  Future<bool> checkApiAvailability() async {
    try {
      final response = await _dio.get('/health');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
