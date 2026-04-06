import 'package:flutter/material.dart';
import '../models/gig_model.dart';
import '../models/application_model.dart';
import '../core/theme/app_theme.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  final StatusType type;
  final bool compact;
  final VoidCallback? onTap;

  const StatusBadge({
    super.key,
    required this.status,
    this.type = StatusType.default_,
    this.compact = false,
    this.onTap,
  });

  factory StatusBadge.gigStatus(GigStatus status, {bool compact = false}) {
    return StatusBadge(
      status: status.name,
      type: StatusType.gig,
      compact: compact,
    );
  }

  factory StatusBadge.applicationStatus(ApplicationStatus status, {bool compact = false}) {
    return StatusBadge(
      status: status.name,
      type: StatusType.application,
      compact: compact,
    );
  }

  @override
  Widget build(BuildContext context) {
    final badgeStyle = _getBadgeStyle();
    
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 8 : 12,
          vertical: compact ? 4 : 6,
        ),
        decoration: BoxDecoration(
          color: badgeStyle.backgroundColor,
          borderRadius: BorderRadius.circular(compact ? 8 : 12),
          border: badgeStyle.borderColor != null 
              ? Border.all(color: badgeStyle.borderColor!)
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (badgeStyle.icon != null) ...[
              Icon(
                badgeStyle.icon,
                size: compact ? 12 : 14,
                color: badgeStyle.textColor,
              ),
              if (!compact) const SizedBox(width: 4),
            ],
            Text(
              _formatStatusText(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: badgeStyle.textColor,
                fontWeight: FontWeight.w600,
                fontSize: compact ? 11 : 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatStatusText() {
    switch (type) {
      case StatusType.gig:
        return _formatGigStatus();
      case StatusType.application:
        return _formatApplicationStatus();
      case StatusType.default_:
        return status;
    }
  }

  String _formatGigStatus() {
    switch (status.toLowerCase()) {
      case 'open':
        return 'Open';
      case 'in_progress':
        return 'In Progress';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }

  String _formatApplicationStatus() {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'reviewed':
        return 'Reviewed';
      case 'accepted':
        return 'Accepted';
      case 'rejected':
        return 'Rejected';
      case 'withdrawn':
        return 'Withdrawn';
      default:
        return status;
    }
  }

  _BadgeStyle _getBadgeStyle() {
    switch (type) {
      case StatusType.gig:
        return _getGigStatusStyle();
      case StatusType.application:
        return _getApplicationStatusStyle();
      case StatusType.default_:
        return _getDefaultStatusStyle();
    }
  }

  _BadgeStyle _getGigStatusStyle() {
    switch (status.toLowerCase()) {
      case 'open':
        return _BadgeStyle(
          backgroundColor: Colors.green.withValues(alpha: 0.1),
          textColor: Colors.green,
          borderColor: Colors.green.withValues(alpha: 0.3),
          icon: Icons.work_outline,
        );
      case 'in_progress':
        return _BadgeStyle(
          backgroundColor: Colors.blue.withValues(alpha: 0.1),
          textColor: Colors.blue,
          borderColor: Colors.blue.withValues(alpha: 0.3),
          icon: Icons.pending,
        );
      case 'completed':
        return _BadgeStyle(
          backgroundColor: Colors.purple.withValues(alpha: 0.1),
          textColor: Colors.purple,
          borderColor: Colors.purple.withValues(alpha: 0.3),
          icon: Icons.check_circle_outline,
        );
      case 'cancelled':
        return _BadgeStyle(
          backgroundColor: Colors.red.withValues(alpha: 0.1),
          textColor: Colors.red,
          borderColor: Colors.red.withValues(alpha: 0.3),
          icon: Icons.cancel_outlined,
        );
      default:
        return _BadgeStyle(
          backgroundColor: AppTheme.surfaceColor,
          textColor: AppTheme.textSecondary,
        );
    }
  }

  _BadgeStyle _getApplicationStatusStyle() {
    switch (status.toLowerCase()) {
      case 'pending':
        return _BadgeStyle(
          backgroundColor: Colors.orange.withValues(alpha: 0.1),
          textColor: Colors.orange,
          borderColor: Colors.orange.withValues(alpha: 0.3),
          icon: Icons.hourglass_empty,
        );
      case 'reviewed':
        return _BadgeStyle(
          backgroundColor: Colors.blue.withValues(alpha: 0.1),
          textColor: Colors.blue,
          borderColor: Colors.blue.withValues(alpha: 0.3),
          icon: Icons.visibility,
        );
      case 'accepted':
        return _BadgeStyle(
          backgroundColor: Colors.green.withValues(alpha: 0.1),
          textColor: Colors.green,
          borderColor: Colors.green.withValues(alpha: 0.3),
          icon: Icons.check_circle_outline,
        );
      case 'rejected':
        return _BadgeStyle(
          backgroundColor: Colors.red.withValues(alpha: 0.1),
          textColor: Colors.red,
          borderColor: Colors.red.withValues(alpha: 0.3),
          icon: Icons.close,
        );
      case 'withdrawn':
        return _BadgeStyle(
          backgroundColor: Colors.grey.withValues(alpha: 0.1),
          textColor: Colors.grey,
          borderColor: Colors.grey.withValues(alpha: 0.3),
          icon: Icons.arrow_back,
        );
      default:
        return _BadgeStyle(
          backgroundColor: AppTheme.surfaceColor,
          textColor: AppTheme.textSecondary,
        );
    }
  }

  _BadgeStyle _getDefaultStatusStyle() {
    return _BadgeStyle(
      backgroundColor: AppTheme.surfaceColor,
      textColor: AppTheme.textSecondary,
    );
  }
}

class _BadgeStyle {
  final Color backgroundColor;
  final Color textColor;
  final Color? borderColor;
  final IconData? icon;

  _BadgeStyle({
    required this.backgroundColor,
    required this.textColor,
    this.borderColor,
    this.icon,
  });
}

enum StatusType {
  gig,
  application,
  default_,
}

class VerificationBadge extends StatelessWidget {
  final bool isVerified;
  final bool compact;
  final String? verificationText;

  const VerificationBadge({
    super.key,
    required this.isVerified,
    this.compact = false,
    this.verificationText,
  });

  @override
  Widget build(BuildContext context) {
    if (!isVerified) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 8,
        vertical: compact ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(compact ? 6 : 8),
        border: Border.all(
          color: Colors.blue.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.verified,
            size: compact ? 12 : 14,
            color: Colors.blue,
          ),
          if (!compact && verificationText != null) ...[
            const SizedBox(width: 4),
            Text(
              verificationText!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.blue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class UrgentBadge extends StatelessWidget {
  final bool isUrgent;
  final bool compact;

  const UrgentBadge({
    super.key,
    required this.isUrgent,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!isUrgent) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 8,
        vertical: compact ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(compact ? 6 : 8),
        border: Border.all(
          color: Colors.red.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.priority_high,
            size: compact ? 12 : 14,
            color: Colors.red,
          ),
          if (!compact) ...[
            const SizedBox(width: 4),
            Text(
              'Urgent',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class FeaturedBadge extends StatelessWidget {
  final bool isFeatured;
  final bool compact;

  const FeaturedBadge({
    super.key,
    required this.isFeatured,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!isFeatured) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 8,
        vertical: compact ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(compact ? 6 : 8),
        border: Border.all(
          color: AppTheme.primaryColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star,
            size: compact ? 12 : 14,
            color: AppTheme.primaryColor,
          ),
          if (!compact) ...[
            const SizedBox(width: 4),
            Text(
              'Featured',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
