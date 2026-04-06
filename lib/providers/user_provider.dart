import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../models/review_model.dart';
import '../models/skill_model.dart';
import '../services/user_service.dart';

class UserProvider extends ChangeNotifier {
  final UserService _userService = UserService();

  // State
  UserModel? _currentUser;
  List<UserModel> _searchedUsers = [];
  List<ReviewModel> _reviews = [];
  List<SkillModel> _skills = [];
  List<Map<String, dynamic>> _portfolio = [];
  Map<String, dynamic>? _userStats;
  
  bool _isLoading = false;
  bool _isUpdatingProfile = false;
  bool _isUploadingImage = false;
  bool _isAddingSkill = false;
  bool _isRemovingSkill = false;
  bool _isAddingReview = false;
  bool _isLoadingPortfolio = false;
  String? _errorMessage;

  // Pagination for reviews
  int _reviewsCurrentPage = 1;
  bool _hasMoreReviews = true;

  // Getters
  UserModel? get currentUser => _currentUser;
  List<UserModel> get searchedUsers => _searchedUsers;
  List<ReviewModel> get reviews => _reviews;
  List<SkillModel> get skills => _skills;
  List<Map<String, dynamic>> get portfolio => _portfolio;
  Map<String, dynamic>? get userStats => _userStats;
  
  bool get isLoading => _isLoading;
  bool get isUpdatingProfile => _isUpdatingProfile;
  bool get isUploadingImage => _isUploadingImage;
  bool get isAddingSkill => _isAddingSkill;
  bool get isRemovingSkill => _isRemovingSkill;
  bool get isAddingReview => _isAddingReview;
  bool get isLoadingPortfolio => _isLoadingPortfolio;
  String? get errorMessage => _errorMessage;
  
  bool get hasMoreReviews => _hasMoreReviews;
  int get reviewsCurrentPage => _reviewsCurrentPage;

  // Get user profile by ID
  Future<UserModel?> getUserProfile(String userId) async {
    _setLoading(true);
    _clearError();

    try {
      final user = await _userService.getUserProfile(userId);
      if (userId == _currentUser?.id) {
        _currentUser = user;
      }
      notifyListeners();
      return user;
    } catch (e) {
      _setError(e.toString());
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Update current user profile
  Future<bool> updateProfile({
    String? name,
    String? department,
    String? aboutMe,
    bool? isFreelancer,
  }) async {
    _setUpdatingProfile(true);
    _clearError();

    try {
      final updatedUser = await _userService.updateProfile(
        name: name,
        department: department,
        aboutMe: aboutMe,
        isFreelancer: isFreelancer,
      );

      if (_currentUser != null) {
        _currentUser = updatedUser;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setUpdatingProfile(false);
    }
  }

  // Upload profile image
  Future<bool> uploadProfileImage(String imagePath) async {
    _setUploadingImage(true);
    _clearError();

    try {
      final imageUrl = await _userService.uploadProfileImage(imagePath);
      
      if (_currentUser != null) {
        _currentUser = _currentUser!.copyWith(avatar: imageUrl);
        notifyListeners();
      }
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setUploadingImage(false);
    }
  }

  // Get user skills
  Future<void> getUserSkills(String userId) async {
    _setLoading(true);
    _clearError();

    try {
      final skills = await _userService.getUserSkills(userId);
      _skills = skills;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Add skill to user profile
  Future<bool> addSkill({
    required String skillId,
    required SkillLevel level,
    double? yearsOfExperience,
  }) async {
    _setAddingSkill(true);
    _clearError();

    try {
      final newSkill = await _userService.addSkill(
        skillId: skillId,
        level: level,
        yearsOfExperience: yearsOfExperience,
      );

      _skills.add(newSkill);
      
      // Update current user skills if applicable
      if (_currentUser != null) {
        final updatedSkills = List<String>.from(_currentUser!.skills)..add(newSkill.name);
        _currentUser = _currentUser!.copyWith(skills: updatedSkills);
      }
      
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setAddingSkill(false);
    }
  }

  // Update user skill
  Future<bool> updateSkill(String skillId, {
    SkillLevel? level,
    double? yearsOfExperience,
  }) async {
    _setAddingSkill(true);
    _clearError();

    try {
      final updatedSkill = await _userService.updateSkill(
        skillId,
        level: level,
        yearsOfExperience: yearsOfExperience,
      );

      // Update skill in list
      final skillIndex = _skills.indexWhere((skill) => skill.skillId == skillId);
      if (skillIndex != -1) {
        _skills[skillIndex] = updatedSkill;
      }

      // Update current user skills if applicable
      if (_currentUser != null) {
        final updatedSkills = _currentUser!.skills.map((skill) =>
            skill == skillId ? updatedSkill.name : skill).toList();
        _currentUser = _currentUser!.copyWith(skills: updatedSkills);
      }

      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setAddingSkill(false);
    }
  }

  // Remove skill from user profile
  Future<bool> removeSkill(String skillId) async {
    _setRemovingSkill(true);
    _clearError();

    try {
      await _userService.removeSkill(skillId);

      _skills.removeWhere((skill) => skill == skillId);
      
      // Update current user skills if applicable
      if (_currentUser != null) {
        final updatedSkills = _currentUser!.skills
            .where((skill) => skill != skillId)
            .toList();
        _currentUser = _currentUser!.copyWith(skills: updatedSkills);
      }

      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setRemovingSkill(false);
    }
  }

  // Get user reviews
  Future<void> getUserReviews(String userId, {
    ReviewType? type,
    bool refresh = false,
  }) async {
    if (refresh) {
      _reviewsCurrentPage = 1;
      _hasMoreReviews = true;
      _reviews.clear();
    }

    if (!_hasMoreReviews && !refresh) return;

    if (_reviewsCurrentPage == 1) {
      _setLoading(true);
    }

    _clearError();

    try {
      final reviews = await _userService.getUserReviews(
        userId,
        type: type,
        page: _reviewsCurrentPage,
        limit: 10,
      );

      if (refresh) {
        _reviews = reviews;
      } else {
        _reviews.addAll(reviews);
      }

      _reviewsCurrentPage++;
      _hasMoreReviews = reviews.length == 10;

      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Add review for user
  Future<bool> addReview({
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
    _setAddingReview(true);
    _clearError();

    try {
      final newReview = await _userService.addReview(
        userId: userId,
        gigId: gigId,
        rating: rating,
        comment: comment,
        reviewType: reviewType,
        communicationRating: communicationRating,
        qualityRating: qualityRating,
        timelinessRating: timelinessRating,
        professionalismRating: professionalismRating,
      );
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setAddingReview(false);
    }
  }

  // Respond to review
  Future<bool> respondToReview(String reviewId, String response) async {
    try {
      final updatedReview = await _userService.respondToReview(reviewId, response);

      // Update review in list
      final reviewIndex = _reviews.indexWhere((review) => review.reviewId == reviewId);
      if (reviewIndex != -1) {
        _reviews[reviewIndex] = updatedReview;
      }

      // Update current user reviews if applicable
      if (_currentUser != null) {
        // Reviews not stored in UserModel in new backend
        // Skip updating user object
      }

      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  // Get user statistics
  Future<void> getUserStats(String userId) async {
    _setLoading(true);
    _clearError();

    try {
      final stats = await _userService.getUserStats(userId);
      _userStats = stats;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Get user portfolio
  Future<void> getUserPortfolio(String userId) async {
    _setLoadingPortfolio(true);
    _clearError();

    try {
      final portfolio = await _userService.getUserPortfolio(userId);
      _portfolio = portfolio;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoadingPortfolio(false);
    }
  }

  // Add portfolio item
  Future<bool> addPortfolioItem({
    required String title,
    required String description,
    required List<String> images,
    required List<String> tags,
    String? projectUrl,
  }) async {
    try {
      final newItem = await _userService.addPortfolioItem(
        title: title,
        description: description,
        images: images,
        tags: tags,
        projectUrl: projectUrl,
      );

      _portfolio.insert(0, newItem);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  // Delete portfolio item
  Future<bool> deletePortfolioItem(String portfolioId) async {
    try {
      await _userService.deletePortfolioItem(portfolioId);

      _portfolio.removeWhere((item) => item['portfolio_id'] == portfolioId);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  // Endorse user skill
  Future<bool> endorseSkill(String userId, String skillId) async {
    try {
      await _userService.endorseSkill(userId, skillId);

      // Update skill endorsement count
      final skillIndex = _skills.indexWhere((skill) => skill.skillId == skillId);
      if (skillIndex != -1) {
        _skills[skillIndex] = _skills[skillIndex].copyWith(
          endorsementsCount: _skills[skillIndex].endorsementsCount + 1,
        );
        notifyListeners();
      }

      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  // Report user
  Future<bool> reportUser(String userId, String reason) async {
    try {
      await _userService.reportUser(userId, reason);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  // Search users
  Future<List<UserModel>> searchUsers(String query) async {
    try {
      // This would typically call a search endpoint in UserService
      // For now, return empty list as placeholder
      _searchedUsers = [];
      notifyListeners();
      return _searchedUsers;
    } catch (e) {
      _setError(e.toString());
      return [];
    }
  }

  // Set current user (usually called after login)
  void setCurrentUser(UserModel user) {
    _currentUser = user;
    notifyListeners();
  }

  // Clear current user (usually called after logout)
  void clearCurrentUser() {
    _currentUser = null;
    _reviews.clear();
    _skills.clear();
    _portfolio.clear();
    _userStats = null;
    notifyListeners();
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setUpdatingProfile(bool loading) {
    _isUpdatingProfile = loading;
    notifyListeners();
  }

  void _setUploadingImage(bool loading) {
    _isUploadingImage = loading;
    notifyListeners();
  }

  void _setAddingSkill(bool loading) {
    _isAddingSkill = loading;
    notifyListeners();
  }

  void _setRemovingSkill(bool loading) {
    _isRemovingSkill = loading;
    notifyListeners();
  }

  void _setAddingReview(bool loading) {
    _isAddingReview = loading;
    notifyListeners();
  }

  void _setLoadingPortfolio(bool loading) {
    _isLoadingPortfolio = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
