import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/app_theme.dart';
import '../routes/app_router.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final bool showLabels;
  final double iconSize;
  final double? elevation;

  const BottomNavigationBarWidget({
    super.key,
    required this.currentIndex,
    this.onTap,
    this.showLabels = true,
    this.iconSize = 24,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: elevation ?? 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _buildNavItems(context),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildNavItems(BuildContext context) {
    final items = [
      _NavItem(
        icon: Icons.home_outlined,
        activeIcon: Icons.home,
        label: 'Home',
        route: AppRoutes.home,
        index: 0,
      ),
      _NavItem(
        icon: Icons.search_outlined,
        activeIcon: Icons.search,
        label: 'Browse',
        route: AppRoutes.browse,
        index: 1,
      ),
      _NavItem(
        icon: Icons.add_box_outlined,
        activeIcon: Icons.add_box,
        label: 'Post',
        route: AppRoutes.post,
        index: 2,
        isCenterButton: true,
      ),
      _NavItem(
        icon: Icons.work_outline,
        activeIcon: Icons.work,
        label: 'Jobs',
        route: AppRoutes.jobs,
        index: 3,
      ),
      _NavItem(
        icon: Icons.person_outline,
        activeIcon: Icons.person,
        label: 'Profile',
        route: AppRoutes.profile,
        index: 4,
      ),
    ];

    return items.map((item) {
      if (item.isCenterButton) {
        return _buildCenterButton(context, item);
      } else {
        return _buildNavItem(context, item);
      }
    }).toList();
  }

  Widget _buildNavItem(BuildContext context, _NavItem item) {
    final isActive = currentIndex == item.index;
    
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (onTap != null) {
            onTap!(item.index);
          }
          context.go(item.route);
        },
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isActive ? item.activeIcon : item.icon,
                size: iconSize,
                color: isActive 
                    ? AppTheme.primaryColor
                    : AppTheme.textSecondary,
              ),
              if (showLabels) ...[
                const SizedBox(height: 2),
                Text(
                  item.label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isActive 
                        ? AppTheme.primaryColor
                        : AppTheme.textSecondary,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                    fontSize: 11,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCenterButton(BuildContext context, _NavItem item) {
    final isActive = currentIndex == item.index;
    
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap!(item.index);
        }
        context.go(item.route);
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: isActive 
              ? AppTheme.primaryColor
              : AppTheme.primaryColor.withOpacity(0.8),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryColor.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          isActive ? item.activeIcon : item.icon,
          size: iconSize * 1.1,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String route;
  final int index;
  final bool isCenterButton;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.route,
    required this.index,
    this.isCenterButton = false,
  });
}

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final List<CustomNavItem> items;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final double? elevation;
  final bool showLabels;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    this.onTap,
    required this.items,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.elevation,
    this.showLabels = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? AppTheme.surfaceColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: elevation ?? 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isActive = currentIndex == index;
              
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (onTap != null) {
                      onTap!(index);
                    }
                    if (item.route != null) {
                      context.go(item.route!);
                    }
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (item.customIcon != null)
                          item.customIcon!(isActive)
                        else
                          Icon(
                            isActive ? item.activeIcon : item.icon,
                            size: item.iconSize,
                            color: isActive 
                                ? selectedItemColor ?? AppTheme.primaryColor
                                : unselectedItemColor ?? AppTheme.textSecondary,
                          ),
                        if (showLabels) ...[
                          const SizedBox(height: 2),
                          Text(
                            item.label,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: isActive 
                                  ? selectedItemColor ?? AppTheme.primaryColor
                                  : unselectedItemColor ?? AppTheme.textSecondary,
                              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class CustomNavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String? route;
  final double iconSize;
  final Widget Function(bool isActive)? customIcon;

  const CustomNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    this.route,
    this.iconSize = 24,
    this.customIcon,
  });
}

class FloatingBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final Widget child;
  final double? height;

  const FloatingBottomNavigationBar({
    super.key,
    required this.currentIndex,
    this.onTap,
    required this.child,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 80,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: child,
      ),
    );
  }
}

class BottomNavigationBadge extends StatelessWidget {
  final Widget child;
  final int count;
  final bool showBadge;
  final Color? badgeColor;
  final Color? textColor;

  const BottomNavigationBadge({
    super.key,
    required this.child,
    required this.count,
    this.showBadge = true,
    this.badgeColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (showBadge && count > 0)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: badgeColor ?? Colors.red,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppTheme.surfaceColor,
                  width: 1.5,
                ),
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                count > 99 ? '99+' : count.toString(),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: textColor ?? Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
