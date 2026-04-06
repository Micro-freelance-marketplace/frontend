import 'package:flutter/foundation.dart';
import '../models/application_model.dart';
import '../services/application_service.dart';

class ApplicationProvider extends ChangeNotifier {
  final ApplicationService _applicationService;
  
  List<ApplicationModel> _myApplications = [];
  List<ApplicationModel> _receivedApplications = [];
  List<ApplicationModel> _gigApplications = [];
  List<ApplicationModel> _shortlistedApplications = [];
  
  bool _isLoading = false;
  bool _isSubmittingApplication = false;
  bool _isUpdatingApplication = false;
  bool _isWithdrawingApplication = false;
  bool _isAcceptingApplication = false;
  bool _isRejectingApplication = false;
  bool _isShortlistingApplication = false;
  bool _isAddingNotes = false;
  bool _isBulkAccepting = false;
  bool _isBulkRejecting = false;
  
  String? _errorMessage;
  ApplicationStatus? _myApplicationsFilter;
  ApplicationStatus? _receivedApplicationsFilter;
  
  int _myApplicationsPage = 1;
  int _receivedApplicationsPage = 1;
  bool _hasMoreMyApplications = true;
  bool _hasMoreReceivedApplications = true;
  
  Map<String, dynamic> _applicationStats = {};

  ApplicationProvider({required ApplicationService applicationService})
      : _applicationService = applicationService;

  // Getters
  List<ApplicationModel> get myApplications => List.unmodifiable(_myApplications);
  List<ApplicationModel> get receivedApplications => List.unmodifiable(_receivedApplications);
  List<ApplicationModel> get gigApplications => List.unmodifiable(_gigApplications);
  List<ApplicationModel> get shortlistedApplications => List.unmodifiable(_shortlistedApplications);
  
  bool get isLoading => _isLoading;
  bool get isSubmittingApplication => _isSubmittingApplication;
  bool get isUpdatingApplication => _isUpdatingApplication;
  bool get isWithdrawingApplication => _isWithdrawingApplication;
  bool get isAcceptingApplication => _isAcceptingApplication;
  bool get isRejectingApplication => _isRejectingApplication;
  bool get isShortlistingApplication => _isShortlistingApplication;
  bool get isAddingNotes => _isAddingNotes;
  bool get isBulkAccepting => _isBulkAccepting;
  bool get isBulkRejecting => _isBulkRejecting;
  
  String? get errorMessage => _errorMessage;
  ApplicationStatus? get myApplicationsFilter => _myApplicationsFilter;
  ApplicationStatus? get receivedApplicationsFilter => _receivedApplicationsFilter;
  
  bool get hasMoreMyApplications => _hasMoreMyApplications;
  bool get hasMoreReceivedApplications => _hasMoreReceivedApplications;
  int get myApplicationsPage => _myApplicationsPage;
  int get receivedApplicationsPage => _receivedApplicationsPage;
  Map<String, dynamic> get applicationStats => _applicationStats;

  // Setters
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setSubmittingApplication(bool submitting) {
    _isSubmittingApplication = submitting;
    notifyListeners();
  }

  void _setUpdatingApplication(bool updating) {
    _isUpdatingApplication = updating;
    notifyListeners();
  }

  void _setWithdrawingApplication(bool withdrawing) {
    _isWithdrawingApplication = withdrawing;
    notifyListeners();
  }

  void _setAcceptingApplication(bool accepting) {
    _isAcceptingApplication = accepting;
    notifyListeners();
  }

  void _setRejectingApplication(bool rejecting) {
    _isRejectingApplication = rejecting;
    notifyListeners();
  }

  void _setShortlistingApplication(bool shortlisting) {
    _isShortlistingApplication = shortlisting;
    notifyListeners();
  }

  void _setAddingNotes(bool adding) {
    _isAddingNotes = adding;
    notifyListeners();
  }

  void _setBulkAccepting(bool accepting) {
    _isBulkAccepting = accepting;
    notifyListeners();
  }

  void _setBulkRejecting(bool rejecting) {
    _isBulkRejecting = rejecting;
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

  // Apply for gig
  Future<bool> applyForGig({
    required String gigId,
    required String proposal,
    double? proposedPrice,
    DateTime? estimatedCompletion,
    List<String> attachments = const [],
  }) async {
    _setSubmittingApplication(true);
    _clearError();

    try {
      final application = await _applicationService.applyForGig(
        gigId: gigId,
        proposal: proposal,
        proposedPrice: proposedPrice?.toInt(),
        deliveryTime: estimatedCompletion?.toIso8601String() ?? '7 days',
      );

      _myApplications.insert(0, application);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setSubmittingApplication(false);
    }
  }

  // Get application by ID
  Future<ApplicationModel?> getApplicationById(String applicationId) async {
    _setLoading(true);
    _clearError();

    try {
      final application = await _applicationService.getApplicationById(applicationId);
      return application;
    } catch (e) {
      _setError(e.toString());
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Update application - removed as not in new backend
  Future<bool> updateApplication(String applicationId, {
    String? proposal,
    double? proposedPrice,
    DateTime? estimatedCompletion,
    List<String>? attachments,
  }) async {
    _setUpdatingApplication(true);
    _clearError();

    try {
      // Application update not implemented in new backend
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setUpdatingApplication(false);
    }
  }

  // Withdraw application - removed as not in new backend
  Future<bool> withdrawApplication(String applicationId) async {
    _setWithdrawingApplication(true);
    _clearError();

    try {
      // Application withdrawal not implemented in new backend
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setWithdrawingApplication(false);
    }
  }

  // Get my applications (as freelancer) - updated for new backend
  Future<void> getMyApplications({
    ApplicationStatus? status,
    bool refresh = false,
  }) async {
    if (refresh) {
      _myApplicationsPage = 1;
      _hasMoreMyApplications = true;
      _myApplications.clear();
    }

    if (!_hasMoreMyApplications && !refresh) return;

    if (_myApplicationsPage == 1) {
      _setLoading(true);
    }

    _clearError();

    try {
      final applications = await _applicationService.getUserApplications();
      
      if (refresh) {
        _myApplications = applications;
      } else {
        _myApplications.addAll(applications);
      }

      _myApplicationsPage++;
      _hasMoreMyApplications = applications.length == 20;

      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Get applications for my gigs (as client) - updated for new backend
  Future<void> getReceivedApplications({
    ApplicationStatus? status,
    bool refresh = false,
  }) async {
    if (refresh) {
      _receivedApplicationsPage = 1;
      _hasMoreReceivedApplications = true;
      _receivedApplications.clear();
    }

    if (!_hasMoreReceivedApplications && !refresh) return;

    if (_receivedApplicationsPage == 1) {
      _setLoading(true);
    }

    _clearError();

    try {
      // Get applications for user's gigs - not implemented in new backend
      // Return empty list for now
      final applications = <ApplicationModel>[];
      
      if (refresh) {
        _receivedApplications = applications;
      } else {
        _receivedApplications.addAll(applications);
      }

      _receivedApplicationsPage++;
      _hasMoreReceivedApplications = applications.length == 20;

      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Get applications for a specific gig - updated for new backend
  Future<void> getGigApplications(String gigId, {
    ApplicationStatus? status,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final applications = await _applicationService.getGigApplications(gigId);
      _gigApplications = applications;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Accept application - removed as not in new backend
  Future<bool> acceptApplication(String applicationId, {
    String? acceptanceMessage,
  }) async {
    _setAcceptingApplication(true);
    _clearError();

    try {
      // Application acceptance not implemented in new backend
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setAcceptingApplication(false);
    }
  }

  // Reject application - removed as not in new backend
  Future<bool> rejectApplication(String applicationId, {
    String? rejectionReason,
  }) async {
    _setRejectingApplication(true);
    _clearError();

    try {
      // Application rejection not implemented in new backend
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setRejectingApplication(false);
    }
  }

  // Shortlist application - removed as not in new backend
  Future<bool> shortlistApplication(String applicationId) async {
    _setShortlistingApplication(true);
    _clearError();

    try {
      // Application shortlisting not implemented in new backend
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setShortlistingApplication(false);
    }
  }

  // Remove from shortlist - removed as not in new backend
  Future<bool> removeFromShortlist(String applicationId) async {
    _setShortlistingApplication(true);
    _clearError();

    try {
      // Application shortlist removal not implemented in new backend
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setShortlistingApplication(false);
    }
  }

  // Add client notes - removed as not in new backend
  Future<bool> addClientNotes(String applicationId, String notes) async {
    _setAddingNotes(true);
    _clearError();

    try {
      // Client notes not implemented in new backend
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setAddingNotes(false);
    }
  }

  // Get shortlisted applications - removed as not in new backend
  Future<void> getShortlistedApplications() async {
    _setLoading(true);
    _clearError();

    try {
      // Shortlisted applications not implemented in new backend
      final applications = <ApplicationModel>[];
      _shortlistedApplications = applications;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Bulk accept applications - removed as not in new backend
  Future<void> bulkAcceptApplications(List<String> applicationIds, {
    String? acceptanceMessage,
  }) async {
    _setBulkAccepting(true);
    _clearError();

    try {
      // Bulk accept not implemented in new backend
      final applications = <ApplicationModel>[];
      _myApplications.addAll(applications);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setBulkAccepting(false);
    }
  }

  // Bulk reject applications - removed as not in new backend
  Future<void> bulkRejectApplications(List<String> applicationIds, {
    String? rejectionReason,
  }) async {
    _setBulkRejecting(true);
    _clearError();

    try {
      // Bulk reject not implemented in new backend
      final applications = <ApplicationModel>[];
      _myApplications.addAll(applications);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setBulkRejecting(false);
    }
  }

  // Get application statistics - removed as not in new backend
  Future<Map<String, dynamic>> getApplicationStats() async {
    _setLoading(true);
    _clearError();

    try {
      // Application stats not implemented in new backend
      final stats = <String, dynamic>{};
      _applicationStats = stats;
      notifyListeners();
      return stats;
    } catch (e) {
      _setError(e.toString());
      return {};
    } finally {
      _setLoading(false);
    }
  }

  // Filter my applications
  void filterMyApplications(ApplicationStatus? status) {
    _myApplicationsFilter = status;
    getMyApplications(refresh: true);
  }

  // Filter received applications
  void filterReceivedApplications(ApplicationStatus? status) {
    _receivedApplicationsFilter = status;
    getReceivedApplications(refresh: true);
  }

  // Filter gig applications
  void filterGigApplications(ApplicationStatus? status) {
    // Implementation for filtering gig applications
    // This would require updating the getGigApplications method
  }

  // Clear error manually
  void clearError() {
    _clearError();
  }

  // Refresh all data
  Future<void> refreshAll() async {
    await getMyApplications(refresh: true);
    await getReceivedApplications(refresh: true);
  }

  // Reset filters
  void resetFilters() {
    _myApplicationsFilter = null;
    _receivedApplicationsFilter = null;
    getMyApplications(refresh: true);
    getReceivedApplications(refresh: true);
  }
}
