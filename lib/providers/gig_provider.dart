import 'package:flutter/foundation.dart';
import '../models/gig_model.dart';
import '../models/category_model.dart';
import '../services/gig_service.dart';

class GigProvider extends ChangeNotifier {
  final GigService _gigService = GigService();

  // State
  List<GigModel> _gigs = [];
  List<GigModel> _hotGigs = [];
  List<GigModel> _myGigs = [];
  GigModel? _selectedGig;
  List<CategoryModel> _categories = [];
  
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _isCreatingGig = false;
  bool _isUpdatingGig = false;
  bool _isDeletingGig = false;
  String? _errorMessage;

  // Pagination
  int _currentPage = 1;
  int _totalPages = 1;
  bool _hasMore = true;

  // Filters
  String? _selectedCategory;
  String? _searchQuery;
  double? _minPrice;
  double? _maxPrice;
  bool? _isRemote;
  String? _location;
  GigStatus? _statusFilter;
  String? _sortBy;

  // Getters
  List<GigModel> get gigs => _gigs;
  List<GigModel> get hotGigs => _hotGigs;
  List<GigModel> get myGigs => _myGigs;
  GigModel? get selectedGig => _selectedGig;
  List<CategoryModel> get categories => _categories;
  
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get isCreatingGig => _isCreatingGig;
  bool get isUpdatingGig => _isUpdatingGig;
  bool get isDeletingGig => _isDeletingGig;
  String? get errorMessage => _errorMessage;
  
  bool get hasMore => _hasMore;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;

  // Filter getters
  String? get selectedCategory => _selectedCategory;
  String? get searchQuery => _searchQuery;
  double? get minPrice => _minPrice;
  double? get maxPrice => _maxPrice;
  bool? get isRemote => _isRemote;
  String? get location => _location;
  GigStatus? get statusFilter => _statusFilter;
  String? get sortBy => _sortBy;

  // Fetch gigs with filters
  Future<void> fetchGigs({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _hasMore = true;
      _gigs.clear();
    }

    if (!_hasMore && !refresh) return;

    if (_currentPage == 1) {
      _setLoading(true);
    } else {
      _setLoadingMore(true);
    }
    _clearError();

    try {
      final gigs = await _gigService.getGigs(
        category: _selectedCategory,
        search: _searchQuery,
        minPrice: _minPrice,
        maxPrice: _maxPrice,
        isRemote: _isRemote,
        location: _location,
        status: _statusFilter,
        sortBy: _sortBy,
        page: _currentPage,
        limit: 20,
      );

      if (refresh) {
        _gigs = gigs;
      } else {
        _gigs.addAll(gigs);
      }

      _currentPage++;
      _hasMore = gigs.length == 20;
      _totalPages = (_gigs.length / 20).ceil();

      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
      _setLoadingMore(false);
    }
  }

  // Fetch hot gigs
  Future<void> fetchHotGigs() async {
    _setLoading(true);
    _clearError();

    try {
      final gigs = await _gigService.getHotGigs(limit: 10);
      _hotGigs = gigs;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Fetch my gigs
  Future<void> fetchMyGigs({GigStatus? status}) async {
    _setLoading(true);
    _clearError();

    try {
      final gigs = await _gigService.getMyGigs(status: status);
      _myGigs = gigs;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Fetch gig by ID
  Future<GigModel?> getGigById(String gigId) async {
    _setLoading(true);
    _clearError();

    try {
      final gig = await _gigService.getGigById(gigId);
      _selectedGig = gig;
      notifyListeners();
      return gig;
    } catch (e) {
      _setError(e.toString());
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Create new gig
  Future<bool> createGig({
    required String title,
    required String description,
    required String categoryId,
    required double minPrice,
    required double maxPrice,
    double? fixedPrice,
    String? location,
    bool isRemote = true,
    DateTime? deadline,
    int? estimatedHours,
    List<String> skillIds = const [],
    List<String> attachments = const [],
  }) async {
    _setCreatingGig(true);
    _clearError();

    try {
      final gig = await _gigService.createGig(
        title: title,
        description: description,
        category: categoryId,
        price: minPrice?.toInt() ?? 0,
        deliveryTime: '7 days',
        requirements: [],
        tags: skillIds,
      );

      _gigs.insert(0, gig);
      _myGigs.insert(0, gig);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setCreatingGig(false);
    }
  }

  // Update gig
  Future<bool> updateGig(String gigId, {
    String? title,
    String? description,
    String? categoryId,
    double? minPrice,
    double? maxPrice,
    double? fixedPrice,
    String? location,
    bool? isRemote,
    DateTime? deadline,
    int? estimatedHours,
    List<String>? skillIds,
    List<String>? attachments,
  }) async {
    _setUpdatingGig(true);
    _clearError();

    try {
      final updatedGig = await _gigService.updateGig(
        gigId,
        title: title,
        description: description,
        category: categoryId,
        price: minPrice?.toInt() ?? 0,
        deliveryTime: '7 days',
        requirements: [],
        tags: skillIds,
      );

      // Update gig in lists
      _updateGigInList(_gigs, updatedGig);
      _updateGigInList(_myGigs, updatedGig);
      if (_selectedGig?.gigId == gigId) {
        _selectedGig = updatedGig;
      }

      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setUpdatingGig(false);
    }
  }

  // Delete gig
  Future<bool> deleteGig(String gigId) async {
    _setDeletingGig(true);
    _clearError();

    try {
      await _gigService.deleteGig(gigId);

      // Remove from lists
      _gigs.removeWhere((gig) => gig.gigId == gigId);
      _myGigs.removeWhere((gig) => gig.gigId == gigId);
      if (_selectedGig?.gigId == gigId) {
        _selectedGig = null;
      }

      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setDeletingGig(false);
    }
  }

  // Search gigs
  Future<void> searchGigs(String query) async {
    _searchQuery = query;
    await fetchGigs(refresh: true);
  }

  // Apply filters
  void applyFilters({
    String? category,
    double? minPrice,
    double? maxPrice,
    bool? isRemote,
    String? location,
    GigStatus? status,
    String? sortBy,
  }) {
    _selectedCategory = category;
    _minPrice = minPrice;
    _maxPrice = maxPrice;
    _isRemote = isRemote;
    _location = location;
    _statusFilter = status;
    _sortBy = sortBy;
    fetchGigs(refresh: true);
  }

  // Clear filters
  void clearFilters() {
    _selectedCategory = null;
    _searchQuery = null;
    _minPrice = null;
    _maxPrice = null;
    _isRemote = null;
    _location = null;
    _statusFilter = null;
    _sortBy = null;
    fetchGigs(refresh: true);
  }

  // Increment gig views - removed as not in new backend
  Future<void> incrementGigViews(String gigId) async {
    try {
      // Silently fail for view tracking
      final gigIndex = _gigs.indexWhere((gig) => gig.gigId == gigId);
      if (gigIndex != -1) {
        _gigs[gigIndex] = _gigs[gigIndex].copyWith(viewsCount: _gigs[gigIndex].viewsCount + 1);
        notifyListeners();
      }
    } catch (e) {
      // Silently fail for view tracking
    }
  }

  // Report gig - removed as not in new backend
  Future<bool> reportGig(String gigId, String reason) async {
    try {
      // Gig reporting not implemented in new backend
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  // Get gigs by category
  Future<List<GigModel>> getGigsByCategory(String categoryId) async {
    try {
      return await _gigService.getGigsByCategory(categoryId);
    } catch (e) {
      _setError(e.toString());
      return [];
    }
  }

  // Refresh selected gig
  Future<void> refreshSelectedGig() async {
    if (_selectedGig != null) {
      await getGigById(_selectedGig!.gigId);
    }
  }

  // Private helper methods
  void _updateGigInList(List<GigModel> gigList, GigModel updatedGig) {
    final index = gigList.indexWhere((gig) => gig.gigId == updatedGig.gigId);
    if (index != -1) {
      gigList[index] = updatedGig;
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setLoadingMore(bool loading) {
    _isLoadingMore = loading;
    notifyListeners();
  }

  void _setCreatingGig(bool loading) {
    _isCreatingGig = loading;
    notifyListeners();
  }

  void _setUpdatingGig(bool loading) {
    _isUpdatingGig = loading;
    notifyListeners();
  }

  void _setDeletingGig(bool loading) {
    _isDeletingGig = loading;
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
