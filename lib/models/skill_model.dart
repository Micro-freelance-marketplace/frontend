import 'package:equatable/equatable.dart';

enum SkillLevel {
  beginner,
  intermediate,
  advanced,
  expert,
}

class SkillModel extends Equatable {
  final String skillId;
  final String name;
  final String? description;
  final SkillLevel level;
  final double? yearsOfExperience;
  final bool isVerified;
  final String? category;
  final String? icon;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int endorsementsCount;

  const SkillModel({
    required this.skillId,
    required this.name,
    this.description,
    required this.level,
    this.yearsOfExperience,
    this.isVerified = false,
    this.category,
    this.icon,
    this.createdAt,
    this.updatedAt,
    this.endorsementsCount = 0,
  });

  factory SkillModel.fromJson(Map<String, dynamic> json) {
    return SkillModel(
      skillId: json['skill_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      level: _parseSkillLevel(json['level']),
      yearsOfExperience: json['years_of_experience']?.toDouble(),
      isVerified: json['is_verified'] ?? false,
      category: json['category'],
      icon: json['icon'],
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
      endorsementsCount: json['endorsements_count'] ?? 0,
    );
  }

  static SkillLevel _parseSkillLevel(String? level) {
    switch (level?.toLowerCase()) {
      case 'beginner':
        return SkillLevel.beginner;
      case 'intermediate':
        return SkillLevel.intermediate;
      case 'advanced':
        return SkillLevel.advanced;
      case 'expert':
        return SkillLevel.expert;
      default:
        return SkillLevel.beginner;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'skill_id': skillId,
      'id': skillId,
      'name': name,
      'description': description,
      'level': level.name,
      'years_of_experience': yearsOfExperience,
      'is_verified': isVerified,
      'category': category,
      'icon': icon,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'endorsements_count': endorsementsCount,
    };
  }

  SkillModel copyWith({
    String? skillId,
    String? name,
    String? description,
    SkillLevel? level,
    double? yearsOfExperience,
    bool? isVerified,
    String? category,
    String? icon,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? endorsementsCount,
  }) {
    return SkillModel(
      skillId: skillId ?? this.skillId,
      name: name ?? this.name,
      description: description ?? this.description,
      level: level ?? this.level,
      yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
      isVerified: isVerified ?? this.isVerified,
      category: category ?? this.category,
      icon: icon ?? this.icon,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      endorsementsCount: endorsementsCount ?? this.endorsementsCount,
    );
  }

  @override
  List<Object?> get props => [
        skillId,
        name,
        description,
        level,
        yearsOfExperience,
        isVerified,
        category,
        icon,
        createdAt,
        updatedAt,
        endorsementsCount,
      ];

  @override
  String toString() {
    return 'SkillModel(skillId: $skillId, name: $name, level: $level)';
  }
}
