import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class CategoryChip extends StatelessWidget {
  final String name;
  final String? icon;
  final String? color;
  final VoidCallback? onTap;
  final bool isSelected;
  final bool compact;
  final bool showIcon;
  final Axis scrollDirection;

  const CategoryChip({
    super.key,
    required this.name,
    this.icon,
    this.color,
    this.onTap,
    this.isSelected = false,
    this.compact = false,
    this.showIcon = true,
    this.scrollDirection = Axis.horizontal,
  });

  @override
  Widget build(BuildContext context) {
    final chipColor = _parseColor(color) ?? AppTheme.primaryColor;
    
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 8 : 12,
          vertical: compact ? 4 : 6,
        ),
        decoration: BoxDecoration(
          color: isSelected 
              ? chipColor.withOpacity(0.2)
              : chipColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(compact ? 8 : 12),
          border: Border.all(
            color: isSelected 
                ? chipColor
                : chipColor.withOpacity(0.3),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showIcon && icon != null) ...[
              Text(
                icon!,
                style: TextStyle(
                  fontSize: compact ? 14 : 16,
                ),
              ),
              if (!compact) const SizedBox(width: 6),
            ],
            Text(
              name,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isSelected 
                    ? chipColor
                    : chipColor.withOpacity(0.8),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: compact ? 12 : 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color? _parseColor(String? colorString) {
    if (colorString == null) return null;
    
    try {
      // Handle hex colors
      if (colorString.startsWith('#')) {
        return Color(int.parse(colorString.substring(1), radix: 16) + 0xFF000000);
      }
      
      // Handle named colors (basic ones)
      switch (colorString.toLowerCase()) {
        case 'red':
          return Colors.red;
        case 'blue':
          return Colors.blue;
        case 'green':
          return Colors.green;
        case 'yellow':
          return Colors.yellow;
        case 'orange':
          return Colors.orange;
        case 'purple':
          return Colors.purple;
        case 'pink':
          return Colors.pink;
        case 'teal':
          return Colors.teal;
        case 'cyan':
          return Colors.cyan;
        case 'lime':
          return Colors.lime;
        case 'indigo':
          return Colors.indigo;
        default:
          return null;
      }
    } catch (e) {
      return null;
    }
  }
}

class CategoryGrid extends StatelessWidget {
  final List<Map<String, String>> categories;
  final Function(String)? onCategorySelected;
  final String? selectedCategory;
  final int crossAxisCount;
  final double childAspectRatio;

  const CategoryGrid({
    super.key,
    required this.categories,
    this.onCategorySelected,
    this.selectedCategory,
    this.crossAxisCount = 3,
    this.childAspectRatio = 2.6,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final name = category['name'] ?? '';
        final icon = category['icon'];
        final color = category['color'];
        
        return CategoryChip(
          name: name,
          icon: icon,
          color: color,
          onTap: () => onCategorySelected?.call(name),
          isSelected: selectedCategory == name,
          compact: true,
        );
      },
    );
  }
}

class CategoryList extends StatelessWidget {
  final List<Map<String, String>> categories;
  final Function(String)? onCategorySelected;
  final String? selectedCategory;
  final Axis scrollDirection;
  final bool showIcon;

  const CategoryList({
    super.key,
    required this.categories,
    this.onCategorySelected,
    this.selectedCategory,
    this.scrollDirection = Axis.horizontal,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    if (scrollDirection == Axis.horizontal) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: categories.map((category) {
            final name = category['name'] ?? '';
            final icon = category['icon'];
            final color = category['color'];
            
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: CategoryChip(
                name: name,
                icon: icon,
                color: color,
                onTap: () => onCategorySelected?.call(name),
                isSelected: selectedCategory == name,
                showIcon: showIcon,
              ),
            );
          }).toList(),
        ),
      );
    } else {
      return Column(
        children: categories.map((category) {
          final name = category['name'] ?? '';
          final icon = category['icon'];
          final color = category['color'];
          
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: CategoryChip(
              name: name,
              icon: icon,
              color: color,
              onTap: () => onCategorySelected?.call(name),
              isSelected: selectedCategory == name,
              showIcon: showIcon,
            ),
          );
        }).toList(),
      );
    }
  }
}
