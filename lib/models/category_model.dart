import 'package:equatable/equatable.dart';

class CategoryModel extends Equatable {
  final String categoryId;
  final String name;
  final String? description;
  final String? icon;
  final String? color;
  final bool isActive;
  final int? sortOrder;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const CategoryModel({
    required this.categoryId,
    required this.name,
    this.description,
    this.icon,
    this.color,
    this.isActive = true,
    this.sortOrder,
    this.createdAt,
    this.updatedAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      categoryId: json['category_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      icon: json['icon'],
      color: json['color'],
      isActive: json['is_active'] ?? true,
      sortOrder: json['sort_order'],
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category_id': categoryId,
      'id': categoryId,
      'name': name,
      'description': description,
      'icon': icon,
      'color': color,
      'is_active': isActive,
      'sort_order': sortOrder,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  CategoryModel copyWith({
    String? categoryId,
    String? name,
    String? description,
    String? icon,
    String? color,
    bool? isActive,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CategoryModel(
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      isActive: isActive ?? this.isActive,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        categoryId,
        name,
        description,
        icon,
        color,
        isActive,
        sortOrder,
        createdAt,
        updatedAt,
      ];

  @override
  String toString() {
    return 'CategoryModel(categoryId: $categoryId, name: $name)';
  }
}
