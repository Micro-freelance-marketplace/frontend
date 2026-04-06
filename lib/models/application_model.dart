import 'package:equatable/equatable.dart';

enum ApplicationStatus {
  pending,
  reviewed,
  accepted,
  rejected,
  withdrawn,
}

class ApplicationModel extends Equatable {
  final String applicationId;
  final String gigId;
  final String gigTitle;
  final String freelancerId;
  final String freelancerName;
  final String? freelancerEmail;
  final String? freelancerImageUrl;
  final String clientId;
  final String clientName;
  final String? clientEmail;
  final String? clientImageUrl;
  final double? proposedPrice;
  final String? proposal;
  final DateTime? appliedAt;
  final DateTime? reviewedAt;
  final DateTime? respondedAt;
  final ApplicationStatus status;
  final String? rejectionReason;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ApplicationModel({
    required this.applicationId,
    required this.gigId,
    required this.gigTitle,
    required this.freelancerId,
    required this.freelancerName,
    this.freelancerEmail,
    this.freelancerImageUrl,
    required this.clientId,
    required this.clientName,
    this.clientEmail,
    this.clientImageUrl,
    this.proposedPrice,
    this.proposal,
    this.appliedAt,
    this.reviewedAt,
    this.respondedAt,
    required this.status,
    this.rejectionReason,
    this.createdAt,
    this.updatedAt,
  });

  factory ApplicationModel.fromJson(Map<String, dynamic> json) {
    return ApplicationModel(
      applicationId: json['application_id'] ?? json['id'] ?? '',
      gigId: json['gig_id'] ?? '',
      gigTitle: json['gig_title'] ?? '',
      freelancerId: json['freelancer_id'] ?? '',
      freelancerName: json['freelancer_name'] ?? '',
      freelancerEmail: json['freelancer_email'],
      freelancerImageUrl: json['freelancer_image_url'],
      clientId: json['client_id'] ?? '',
      clientName: json['client_name'] ?? '',
      clientEmail: json['client_email'],
      clientImageUrl: json['client_image_url'],
      proposedPrice: json['proposed_price']?.toDouble(),
      proposal: json['proposal'],
      appliedAt: json['applied_at'] != null 
          ? DateTime.parse(json['applied_at']) 
          : null,
      reviewedAt: json['reviewed_at'] != null 
          ? DateTime.parse(json['reviewed_at']) 
          : null,
      respondedAt: json['responded_at'] != null 
          ? DateTime.parse(json['responded_at']) 
          : null,
      status: _parseApplicationStatus(json['status']),
      rejectionReason: json['rejection_reason'],
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
    );
  }

  static ApplicationStatus _parseApplicationStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return ApplicationStatus.pending;
      case 'reviewed':
        return ApplicationStatus.reviewed;
      case 'accepted':
        return ApplicationStatus.accepted;
      case 'rejected':
        return ApplicationStatus.rejected;
      case 'withdrawn':
        return ApplicationStatus.withdrawn;
      default:
        return ApplicationStatus.pending;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'application_id': applicationId,
      'id': applicationId,
      'gig_id': gigId,
      'gig_title': gigTitle,
      'freelancer_id': freelancerId,
      'freelancer_name': freelancerName,
      'freelancer_email': freelancerEmail,
      'freelancer_image_url': freelancerImageUrl,
      'client_id': clientId,
      'client_name': clientName,
      'client_email': clientEmail,
      'client_image_url': clientImageUrl,
      'proposed_price': proposedPrice,
      'proposal': proposal,
      'applied_at': appliedAt?.toIso8601String(),
      'reviewed_at': reviewedAt?.toIso8601String(),
      'responded_at': respondedAt?.toIso8601String(),
      'status': status.name,
      'rejection_reason': rejectionReason,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  ApplicationModel copyWith({
    String? applicationId,
    String? gigId,
    String? gigTitle,
    String? freelancerId,
    String? freelancerName,
    String? freelancerEmail,
    String? freelancerImageUrl,
    String? clientId,
    String? clientName,
    String? clientEmail,
    String? clientImageUrl,
    double? proposedPrice,
    String? proposal,
    DateTime? appliedAt,
    DateTime? reviewedAt,
    DateTime? respondedAt,
    ApplicationStatus? status,
    String? rejectionReason,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ApplicationModel(
      applicationId: applicationId ?? this.applicationId,
      gigId: gigId ?? this.gigId,
      gigTitle: gigTitle ?? this.gigTitle,
      freelancerId: freelancerId ?? this.freelancerId,
      freelancerName: freelancerName ?? this.freelancerName,
      freelancerEmail: freelancerEmail ?? this.freelancerEmail,
      freelancerImageUrl: freelancerImageUrl ?? this.freelancerImageUrl,
      clientId: clientId ?? this.clientId,
      clientName: clientName ?? this.clientName,
      clientEmail: clientEmail ?? this.clientEmail,
      clientImageUrl: clientImageUrl ?? this.clientImageUrl,
      proposedPrice: proposedPrice ?? this.proposedPrice,
      proposal: proposal ?? this.proposal,
      appliedAt: appliedAt ?? this.appliedAt,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      respondedAt: respondedAt ?? this.respondedAt,
      status: status ?? this.status,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        applicationId,
        gigId,
        gigTitle,
        freelancerId,
        freelancerName,
        freelancerEmail,
        freelancerImageUrl,
        clientId,
        clientName,
        clientEmail,
        clientImageUrl,
        proposedPrice,
        proposal,
        appliedAt,
        reviewedAt,
        respondedAt,
        status,
        rejectionReason,
        createdAt,
        updatedAt,
      ];

  @override
  String toString() {
    return 'ApplicationModel(applicationId: $applicationId, status: $status)';
  }
}
