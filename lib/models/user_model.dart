import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String? id; // UserProfile _id
  final String? user; // Reference to User
  final String name;
  final String? email; // From User model
  final String? bio;
  final List<String> skills;
  final String? avatar; // Cloudinary URL
  final double averageRating;
  final int reviewCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? campus; // From User model
  final String? role; // From User model (freelancer/poster)

  const UserModel({
    this.id,
    this.user,
    required this.name,
    this.email,
    this.bio,
    this.skills = const [],
    this.avatar,
    this.averageRating = 0.0,
    this.reviewCount = 0,
    this.createdAt,
    this.updatedAt,
    this.campus,
    this.role,
  });

  /// Create UserModel from JSON (UserProfile format)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id']?.toString(),
      user: json['user']?.toString(),
      name: json['name'] ?? '',
      email: json['email'],
      bio: json['bio'],
      skills: List<String>.from(json['skills'] ?? []),
      avatar: json['avatar'],
      averageRating: (json['averageRating'] ?? 0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      createdAt: json['createdAt'] != null 
          ? DateTime.tryParse(json['createdAt']) 
          : null,
      updatedAt: json['updatedAt'] != null 
          ? DateTime.tryParse(json['updatedAt']) 
          : null,
      campus: json['campus'],
      role: json['role'],
    );
  }

  /// Create UserModel from JSON (User format)
  factory UserModel.fromUserJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] ?? '',
      email: json['email'],
      campus: json['campus'],
      role: json['role'],
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': user,
      'name': name,
      'email': email,
      'bio': bio,
      'skills': skills,
      'avatar': avatar,
      'averageRating': averageRating,
      'reviewCount': reviewCount,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'campus': campus,
      'role': role,
    };
  }

  /// Copy with updated values
  UserModel copyWith({
    String? id,
    String? user,
    String? name,
    String? email,
    String? bio,
    List<String>? skills,
    String? avatar,
    double? averageRating,
    int? reviewCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? campus,
    String? role,
  }) {
    return UserModel(
      id: id ?? this.id,
      user: user ?? this.user,
      name: name ?? this.name,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      skills: skills ?? this.skills,
      avatar: avatar ?? this.avatar,
      averageRating: averageRating ?? this.averageRating,
      reviewCount: reviewCount ?? this.reviewCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      campus: campus ?? this.campus,
      role: role ?? this.role,
    );
  }

  /// Check if user is a freelancer
  bool get isFreelancer => role == 'freelancer';

  /// Check if user is a poster
  bool get isPoster => role == 'poster';

  /// Check if user has a profile
  bool get hasProfile => id != null && user != null;

  /// Get display name
  String get displayName => name.isEmpty ? 'Anonymous User' : name;

  /// Get initials for avatar
  String get initials {
    final nameParts = name.trim().split(' ');
    if (nameParts.length >= 2) {
      return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    } else if (nameParts.isNotEmpty) {
      return nameParts[0][0].toUpperCase();
    }
    return 'U';
  }

  /// Check if user is verified (has profile)
  bool get isVerified => hasProfile;

  @override
  List<Object?> get props => [
        id,
        user,
        name,
        email,
        bio,
        skills,
        avatar,
        averageRating,
        reviewCount,
        createdAt,
        updatedAt,
        campus,
        role,
      ];

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, role: $role, averageRating: $averageRating)';
  }
}
