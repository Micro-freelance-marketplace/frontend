import 'package:equatable/equatable.dart';

enum ReviewType {
  gig,
  freelancer,
}

class ReviewModel extends Equatable {
  final String reviewId;
  final String? gigId;
  final String? reviewerId;
  final String? reviewerName;
  final String? reviewerImageUrl;
  final double rating;
  final String? comment;
  final ReviewType type;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ReviewModel({
    required this.reviewId,
    this.gigId,
    this.reviewerId,
    this.reviewerName,
    this.reviewerImageUrl,
    required this.rating,
    this.comment,
    this.type = ReviewType.gig,
    this.createdAt,
    this.updatedAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      reviewId: json['review_id'] ?? json['id'] ?? '',
      gigId: json['gig_id'],
      reviewerId: json['reviewer_id'],
      reviewerName: json['reviewer_name'],
      reviewerImageUrl: json['reviewer_image_url'],
      rating: (json['rating'] ?? 0.0).toDouble(),
      comment: json['comment'],
      type: _parseReviewType(json['type']),
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
    );
  }

  static ReviewType _parseReviewType(String? type) {
    switch (type?.toLowerCase()) {
      case 'gig':
        return ReviewType.gig;
      case 'freelancer':
        return ReviewType.freelancer;
      default:
        return ReviewType.gig;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'review_id': reviewId,
      'id': reviewId,
      'gig_id': gigId,
      'reviewer_id': reviewerId,
      'reviewer_name': reviewerName,
      'reviewer_image_url': reviewerImageUrl,
      'rating': rating,
      'comment': comment,
      'type': type.name,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  ReviewModel copyWith({
    String? reviewId,
    String? gigId,
    String? reviewerId,
    String? reviewerName,
    String? reviewerImageUrl,
    double? rating,
    String? comment,
    ReviewType? type,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ReviewModel(
      reviewId: reviewId ?? this.reviewId,
      gigId: gigId ?? this.gigId,
      reviewerId: reviewerId ?? this.reviewerId,
      reviewerName: reviewerName ?? this.reviewerName,
      reviewerImageUrl: reviewerImageUrl ?? this.reviewerImageUrl,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        reviewId,
        gigId,
        reviewerId,
        reviewerName,
        reviewerImageUrl,
        rating,
        comment,
        type,
        createdAt,
        updatedAt,
      ];

  @override
  String toString() {
    return 'ReviewModel(reviewId: $reviewId, rating: $rating)';
  }
}
