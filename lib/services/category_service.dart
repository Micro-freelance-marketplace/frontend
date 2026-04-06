import 'package:dio/dio.dart';
import 'api_client.dart';
import '../models/category_model.dart';
import '../models/skill_model.dart';

class CategoryService {
  final ApiClient _apiClient = ApiClient();

  /// Get all categories
  Future<List<CategoryModel>> getCategories({
    bool? isActive,
    int page = 1,
    int limit = 50,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };

      if (isActive != null) queryParams['is_active'] = isActive;

      final response = await _apiClient.dio.get('/categories', queryParameters: queryParams);

      if (response.statusCode == 200) {
        final categoriesData = response.data['data'] as List;
        return categoriesData.map((category) => CategoryModel.fromJson(category)).toList();
      } else {
        throw Exception('Failed to fetch categories');
      }
    } on DioException catch (e) {
      throw _handleCategoryError(e);
    }
  }

  /// Get category by ID
  Future<CategoryModel> getCategoryById(String categoryId) async {
    try {
      final response = await _apiClient.dio.get('/categories/$categoryId');

      if (response.statusCode == 200) {
        return CategoryModel.fromJson(response.data);
      } else {
        throw Exception('Category not found');
      }
    } on DioException catch (e) {
      throw _handleCategoryError(e);
    }
  }

  /// Get categories with gig counts
  Future<List<CategoryModel>> getCategoriesWithGigCounts() async {
    try {
      final response = await _apiClient.dio.get('/categories/with-gig-counts');

      if (response.statusCode == 200) {
        final categoriesData = response.data['data'] as List;
        return categoriesData.map((category) => CategoryModel.fromJson(category)).toList();
      } else {
        throw Exception('Failed to fetch categories with gig counts');
      }
    } on DioException catch (e) {
      throw _handleCategoryError(e);
    }
  }

  /// Get popular categories
  Future<List<CategoryModel>> getPopularCategories({int limit = 10}) async {
    try {
      final response = await _apiClient.dio.get('/categories/popular', queryParameters: {
        'limit': limit,
      });

      if (response.statusCode == 200) {
        final categoriesData = response.data['data'] as List;
        return categoriesData.map((category) => CategoryModel.fromJson(category)).toList();
      } else {
        throw Exception('Failed to fetch popular categories');
      }
    } on DioException catch (e) {
      throw _handleCategoryError(e);
    }
  }

  /// Get subcategories of a parent category
  Future<List<CategoryModel>> getSubcategories(String parentCategoryId) async {
    try {
      final response = await _apiClient.dio.get('/categories/$parentCategoryId/subcategories');

      if (response.statusCode == 200) {
        final categoriesData = response.data['data'] as List;
        return categoriesData.map((category) => CategoryModel.fromJson(category)).toList();
      } else {
        throw Exception('Failed to fetch subcategories');
      }
    } on DioException catch (e) {
      throw _handleCategoryError(e);
    }
  }

  /// Create new category (admin only)
  Future<CategoryModel> createCategory({
    required String name,
    String? description,
    required String icon,
    required String color,
    String? imageUrl,
    String? parentCategoryId,
    int sortOrder = 0,
  }) async {
    try {
      final data = <String, dynamic>{
        'name': name,
        'icon': icon,
        'color': color,
        'sort_order': sortOrder,
      };

      if (description != null) data['description'] = description;
      if (imageUrl != null) data['image_url'] = imageUrl;
      if (parentCategoryId != null) data['parent_category_id'] = parentCategoryId;

      final response = await _apiClient.dio.post('/categories', data: data);

      if (response.statusCode == 201) {
        return CategoryModel.fromJson(response.data);
      } else {
        throw Exception('Failed to create category');
      }
    } on DioException catch (e) {
      throw _handleCategoryError(e);
    }
  }

  /// Update category (admin only)
  Future<CategoryModel> updateCategory(String categoryId, {
    String? name,
    String? description,
    String? icon,
    String? color,
    String? imageUrl,
    bool? isActive,
    int? sortOrder,
  }) async {
    try {
      final data = <String, dynamic>{};
      
      if (name != null) data['name'] = name;
      if (description != null) data['description'] = description;
      if (icon != null) data['icon'] = icon;
      if (color != null) data['color'] = color;
      if (imageUrl != null) data['image_url'] = imageUrl;
      if (isActive != null) data['is_active'] = isActive;
      if (sortOrder != null) data['sort_order'] = sortOrder;

      final response = await _apiClient.dio.put('/categories/$categoryId', data: data);

      if (response.statusCode == 200) {
        return CategoryModel.fromJson(response.data);
      } else {
        throw Exception('Failed to update category');
      }
    } on DioException catch (e) {
      throw _handleCategoryError(e);
    }
  }

  /// Delete category (admin only)
  Future<void> deleteCategory(String categoryId) async {
    try {
      final response = await _apiClient.dio.delete('/categories/$categoryId');

      if (response.statusCode != 200) {
        throw Exception('Failed to delete category');
      }
    } on DioException catch (e) {
      throw _handleCategoryError(e);
    }
  }

  /// Get skills by category
  Future<List<SkillModel>> getSkillsByCategory(String categoryId) async {
    try {
      final response = await _apiClient.dio.get('/categories/$categoryId/skills');

      if (response.statusCode == 200) {
        final skillsData = response.data['data'] as List;
        return skillsData.map((skill) => SkillModel.fromJson(skill)).toList();
      } else {
        throw Exception('Failed to fetch skills by category');
      }
    } on DioException catch (e) {
      throw _handleCategoryError(e);
    }
  }

  /// Search categories
  Future<List<CategoryModel>> searchCategories(String query, {int limit = 20}) async {
    try {
      final response = await _apiClient.dio.get('/categories/search', queryParameters: {
        'q': query,
        'limit': limit,
      });

      if (response.statusCode == 200) {
        final categoriesData = response.data['data'] as List;
        return categoriesData.map((category) => CategoryModel.fromJson(category)).toList();
      } else {
        throw Exception('Failed to search categories');
      }
    } on DioException catch (e) {
      throw _handleCategoryError(e);
    }
  }

  /// Get category statistics
  Future<Map<String, dynamic>> getCategoryStats(String categoryId) async {
    try {
      final response = await _apiClient.dio.get('/categories/$categoryId/stats');

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Failed to fetch category statistics');
      }
    } on DioException catch (e) {
      throw _handleCategoryError(e);
    }
  }

  /// Get all skills
  Future<List<SkillModel>> getSkills({
    String? category,
    SkillLevel? level,
    int page = 1,
    int limit = 100,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };

      if (category != null) queryParams['category'] = category;
      if (level != null) queryParams['level'] = level.name;

      final response = await _apiClient.dio.get('/skills', queryParameters: queryParams);

      if (response.statusCode == 200) {
        final skillsData = response.data['data'] as List;
        return skillsData.map((skill) => SkillModel.fromJson(skill)).toList();
      } else {
        throw Exception('Failed to fetch skills');
      }
    } on DioException catch (e) {
      throw _handleCategoryError(e);
    }
  }

  /// Get skill by ID
  Future<SkillModel> getSkillById(String skillId) async {
    try {
      final response = await _apiClient.dio.get('/skills/$skillId');

      if (response.statusCode == 200) {
        return SkillModel.fromJson(response.data);
      } else {
        throw Exception('Skill not found');
      }
    } on DioException catch (e) {
      throw _handleCategoryError(e);
    }
  }

  /// Get popular skills
  Future<List<SkillModel>> getPopularSkills({int limit = 20}) async {
    try {
      final response = await _apiClient.dio.get('/skills/popular', queryParameters: {
        'limit': limit,
      });

      if (response.statusCode == 200) {
        final skillsData = response.data['data'] as List;
        return skillsData.map((skill) => SkillModel.fromJson(skill)).toList();
      } else {
        throw Exception('Failed to fetch popular skills');
      }
    } on DioException catch (e) {
      throw _handleCategoryError(e);
    }
  }

  /// Search skills
  Future<List<SkillModel>> searchSkills(String query, {int limit = 20}) async {
    try {
      final response = await _apiClient.dio.get('/skills/search', queryParameters: {
        'q': query,
        'limit': limit,
      });

      if (response.statusCode == 200) {
        final skillsData = response.data['data'] as List;
        return skillsData.map((skill) => SkillModel.fromJson(skill)).toList();
      } else {
        throw Exception('Failed to search skills');
      }
    } on DioException catch (e) {
      throw _handleCategoryError(e);
    }
  }

  /// Create new skill (admin only)
  Future<SkillModel> createSkill({
    required String name,
    required String category,
    required SkillLevel level,
    String? description,
    String? icon,
    String? color,
  }) async {
    try {
      final data = <String, dynamic>{
        'name': name,
        'category': category,
        'level': level.name,
      };

      if (description != null) data['description'] = description;
      if (icon != null) data['icon'] = icon;
      if (color != null) data['color'] = color;

      final response = await _apiClient.dio.post('/skills', data: data);

      if (response.statusCode == 201) {
        return SkillModel.fromJson(response.data);
      } else {
        throw Exception('Failed to create skill');
      }
    } on DioException catch (e) {
      throw _handleCategoryError(e);
    }
  }

  /// Update skill (admin only)
  Future<SkillModel> updateSkill(String skillId, {
    String? name,
    String? category,
    SkillLevel? level,
    String? description,
    String? icon,
    String? color,
  }) async {
    try {
      final data = <String, dynamic>{};
      
      if (name != null) data['name'] = name;
      if (category != null) data['category'] = category;
      if (level != null) data['level'] = level.name;
      if (description != null) data['description'] = description;
      if (icon != null) data['icon'] = icon;
      if (color != null) data['color'] = color;

      final response = await _apiClient.dio.put('/skills/$skillId', data: data);

      if (response.statusCode == 200) {
        return SkillModel.fromJson(response.data);
      } else {
        throw Exception('Failed to update skill');
      }
    } on DioException catch (e) {
      throw _handleCategoryError(e);
    }
  }

  /// Delete skill (admin only)
  Future<void> deleteSkill(String skillId) async {
    try {
      final response = await _apiClient.dio.delete('/skills/$skillId');

      if (response.statusCode != 200) {
        throw Exception('Failed to delete skill');
      }
    } on DioException catch (e) {
      throw _handleCategoryError(e);
    }
  }

  DioException _handleCategoryError(DioException error) {
    if (error.response?.statusCode == 404) {
      return DioException(
        requestOptions: error.requestOptions,
        response: error.response,
        error: 'Category or skill not found',
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
