import 'package:equatable/equatable.dart';
import 'application_model.dart';
import 'category_model.dart';
import 'review_model.dart';
import 'skill_model.dart';

enum GigStatus {
  open,
  in_progress,
  completed,
  cancelled,
}

class GigModel extends Equatable {
  final String gigId;
  final String title;
  final String description;
  final String categoryId;
  final CategoryModel category;
  final String clientId;
  final String clientName;
  final String clientEmail;
  final String? clientImageUrl;
  final double minPrice;
  final double maxPrice;
  final double? fixedPrice;
  final String? location;
  final bool isRemote;
  final DateTime? deadline;
  final int? estimatedHours;
  final List<String> skillIds;
  final List<SkillModel> skillsRequired;
  final List<String> attachments;
  final GigStatus status;
  final int viewsCount;
  final int applicationCount;
  final DateTime postedDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const GigModel({
    required this.gigId,
    required this.title,
    required this.description,
    required this.categoryId,
    required this.category,
    required this.clientId,
    required this.clientName,
    required this.clientEmail,
    this.clientImageUrl,
    required this.minPrice,
    required this.maxPrice,
    this.fixedPrice,
    this.location,
    this.isRemote = false,
    this.deadline,
    this.estimatedHours,
    this.skillIds = const [],
    this.skillsRequired = const [],
    this.attachments = const [],
    this.status = GigStatus.open,
    this.viewsCount = 0,
    this.applicationCount = 0,
    required this.postedDate,
    this.createdAt,
    this.updatedAt,
  });

  factory GigModel.fromJson(Map<String, dynamic> json) {
    return GigModel(
      gigId: json['gig_id'] ?? json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      categoryId: json['category_id'] ?? '',
      category: json['category'] != null 
          ? CategoryModel.fromJson(json['category']) 
          : CategoryModel(categoryId: '', name: ''),
      clientId: json['client_id'] ?? '',
      clientName: json['client_name'] ?? '',
      clientEmail: json['client_email'],
      clientImageUrl: json['client_image_url'],
      minPrice: (json['min_price'] ?? 0.0).toDouble(),
      maxPrice: (json['max_price'] ?? 0.0).toDouble(),
      fixedPrice: json['fixed_price']?.toDouble(),
      location: json['location'],
      isRemote: json['is_remote'] ?? false,
      deadline: json['deadline'] != null 
          ? DateTime.parse(json['deadline']) 
          : null,
      estimatedHours: json['estimated_hours'],
      skillIds: json['skill_ids'] != null 
          ? List<String>.from(json['skill_ids']) 
          : [],
      skillsRequired: json['skills_required'] != null 
          ? (json['skills_required'] as List).map((skill) => SkillModel.fromJson(skill)).toList()
          : [],
      attachments: json['attachments'] != null 
          ? List<String>.from(json['attachments']) 
          : [],
      status: _parseGigStatus(json['status']),
      viewsCount: json['views_count'] ?? 0,
      applicationCount: json['application_count'] ?? 0,
      postedDate: json['posted_date'] != null 
          ? DateTime.parse(json['posted_date']) 
          : DateTime.now(),
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
    );
  }

  static GigStatus _parseGigStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'open':
        return GigStatus.open;
      case 'in_progress':
        return GigStatus.in_progress;
      case 'completed':
        return GigStatus.completed;
      case 'cancelled':
        return GigStatus.cancelled;
      default:
        return GigStatus.open;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'gig_id': gigId,
      'id': gigId,
      'title': title,
      'description': description,
      'category_id': categoryId,
      'category': category.toJson(),
      'client_id': clientId,
      'client_name': clientName,
      'client_email': clientEmail,
      'client_image_url': clientImageUrl,
      'min_price': minPrice,
      'max_price': maxPrice,
      'fixed_price': fixedPrice,
      'location': location,
      'is_remote': isRemote,
      'deadline': deadline?.toIso8601String(),
      'estimated_hours': estimatedHours,
      'skill_ids': skillIds,
      'skills_required': skillsRequired.map((skill) => skill.toJson()).toList(),
      'attachments': attachments,
      'status': status.name,
      'views_count': viewsCount,
      'application_count': applicationCount,
      'posted_date': postedDate.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  GigModel copyWith({
    String? gigId,
    String? title,
    String? description,
    String? categoryId,
    CategoryModel? category,
    String? clientId,
    String? clientName,
    String? clientEmail,
    String? clientImageUrl,
    double? minPrice,
    double? maxPrice,
    double? fixedPrice,
    String? location,
    bool? isRemote,
    DateTime? deadline,
    int? estimatedHours,
    List<String>? skillIds,
    List<SkillModel>? skillsRequired,
    List<String>? attachments,
    GigStatus? status,
    int? viewsCount,
    int? applicationCount,
    DateTime? postedDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return GigModel(
      gigId: gigId ?? this.gigId,
      title: title ?? this.title,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      category: category ?? this.category,
      clientId: clientId ?? this.clientId,
      clientName: clientName ?? this.clientName,
      clientEmail: clientEmail ?? this.clientEmail,
      clientImageUrl: clientImageUrl ?? this.clientImageUrl,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      fixedPrice: fixedPrice ?? this.fixedPrice,
      location: location ?? this.location,
      isRemote: isRemote ?? this.isRemote,
      deadline: deadline ?? this.deadline,
      estimatedHours: estimatedHours ?? this.estimatedHours,
      skillIds: skillIds ?? this.skillIds,
      skillsRequired: skillsRequired ?? this.skillsRequired,
      attachments: attachments ?? this.attachments,
      status: status ?? this.status,
      viewsCount: viewsCount ?? this.viewsCount,
      applicationCount: applicationCount ?? this.applicationCount,
      postedDate: postedDate ?? this.postedDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        gigId,
        title,
        description,
        categoryId,
        category,
        clientId,
        clientName,
        clientEmail,
        clientImageUrl,
        minPrice,
        maxPrice,
        fixedPrice,
        location,
        isRemote,
        deadline,
        estimatedHours,
        skillIds,
        skillsRequired,
        attachments,
        status,
        viewsCount,
        applicationCount,
        postedDate,
        createdAt,
        updatedAt,
      ];

  String get priceRange {
    if (fixedPrice != null) {
      return '\$${fixedPrice?.toStringAsFixed(2)}';
    } else {
      return '\$${minPrice.toStringAsFixed(2)} - \$${maxPrice.toStringAsFixed(2)}';
    }
  }

  @override
  String toString() {
    return 'GigModel(gigId: $gigId, title: $title, status: $status)';
  }
}
