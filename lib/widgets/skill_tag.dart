import 'package:flutter/material.dart';
import '../models/skill_model.dart';
import '../core/theme/app_theme.dart';

class SkillTag extends StatelessWidget {
  final String name;
  final SkillLevel? level;
  final double? yearsOfExperience;
  final bool showLevel;
  final bool showExperience;
  final bool isVerified;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;
  final bool removable;
  final bool compact;

  const SkillTag({
    super.key,
    required this.name,
    this.level,
    this.yearsOfExperience,
    this.showLevel = false,
    this.showExperience = false,
    this.isVerified = false,
    this.onTap,
    this.onRemove,
    this.removable = false,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 8 : 12,
          vertical: compact ? 4 : 6,
        ),
        decoration: BoxDecoration(
          color: _getSkillColor().withOpacity(0.1),
          borderRadius: BorderRadius.circular(compact ? 8 : 12),
          border: Border.all(
            color: _getSkillColor().withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isVerified) ...[
              Icon(
                Icons.verified,
                size: compact ? 12 : 14,
                color: Colors.blue,
              ),
              if (!compact) const SizedBox(width: 4),
            ],
            Text(
              name,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: _getSkillColor(),
                fontWeight: FontWeight.w500,
                fontSize: compact ? 12 : 14,
              ),
            ),
            if (showLevel && level != null) ...[
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: _getSkillColor().withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  _getLevelDisplay(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: _getSkillColor(),
                    fontSize: compact ? 10 : 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
            if (showExperience && yearsOfExperience != null) ...[
              const SizedBox(width: 4),
              Text(
                _getExperienceDisplay(),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                  fontSize: compact ? 10 : 11,
                ),
              ),
            ],
            if (removable && onRemove != null) ...[
              const SizedBox(width: 4),
              GestureDetector(
                onTap: onRemove,
                child: Icon(
                  Icons.close,
                  size: compact ? 14 : 16,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getSkillColor() {
    if (level != null) {
      switch (level!) {
        case SkillLevel.beginner:
          return Colors.green;
        case SkillLevel.intermediate:
          return Colors.blue;
        case SkillLevel.advanced:
          return Colors.purple;
        case SkillLevel.expert:
          return Colors.orange;
      }
    }
    return AppTheme.primaryColor;
  }

  String _getLevelDisplay() {
    if (level == null) return '';
    switch (level!) {
      case SkillLevel.beginner:
        return 'BEG';
      case SkillLevel.intermediate:
        return 'INT';
      case SkillLevel.advanced:
        return 'ADV';
      case SkillLevel.expert:
        return 'EXP';
    }
  }

  String _getExperienceDisplay() {
    if (yearsOfExperience == null) return '';
    
    final years = yearsOfExperience!;
    if (years < 1) {
      return '<1y';
    } else if (years == 1) {
      return '1y';
    } else {
      return '${years.toStringAsFixed(1)}y';
    }
  }
}

class SkillTagList extends StatelessWidget {
  final List<SkillModel> skills;
  final bool showLevel;
  final bool showExperience;
  final bool showVerification;
  final Function(String)? onSkillTap;
  final Function(String)? onSkillRemove;
  final bool removable;
  final bool compact;
  final int maxSkills;

  const SkillTagList({
    super.key,
    required this.skills,
    this.showLevel = false,
    this.showExperience = false,
    this.showVerification = true,
    this.onSkillTap,
    this.onSkillRemove,
    this.removable = false,
    this.compact = false,
    this.maxSkills,
  });

  @override
  Widget build(BuildContext context) {
    final displaySkills = maxSkills != null 
        ? skills.take(maxSkills!).toList()
        : skills;

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: displaySkills.map((skill) {
        return SkillTag(
          name: skill.name,
          level: skill.level,
          yearsOfExperience: skill.yearsOfExperience,
          showLevel: showLevel,
          showExperience: showExperience,
          isVerified: showVerification ? skill.isVerified : false,
          onTap: () => onSkillTap?.call(skill.skillId),
          onRemove: removable ? () => onSkillRemove?.call(skill.skillId) : null,
          removable: removable,
          compact: compact,
        );
      }).toList(),
    );
  }
}

class SkillTagGrid extends StatelessWidget {
  final List<SkillModel> skills;
  final bool showLevel;
  final bool showExperience;
  final bool showVerification;
  final Function(String)? onSkillTap;
  final Function(String)? onSkillRemove;
  final bool removable;
  final int crossAxisCount;

  const SkillTagGrid({
    super.key,
    required this.skills,
    this.showLevel = false,
    this.showExperience = false,
    this.showVerification = true,
    this.onSkillTap,
    this.onSkillRemove,
    this.removable = false,
    this.crossAxisCount = 3,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 3,
      ),
      itemCount: skills.length,
      itemBuilder: (context, index) {
        final skill = skills[index];
        return SkillTag(
          name: skill.name,
          level: skill.level,
          yearsOfExperience: skill.yearsOfExperience,
          showLevel: showLevel,
          showExperience: showExperience,
          isVerified: showVerification ? skill.isVerified : false,
          onTap: () => onSkillTap?.call(skill.skillId),
          onRemove: removable ? () => onSkillRemove?.call(skill.skillId) : null,
          removable: removable,
          compact: true,
        );
      },
    );
  }
}

class AddSkillTag extends StatelessWidget {
  final VoidCallback? onTap;
  final bool compact;

  const AddSkillTag({
    super.key,
    this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 8 : 12,
          vertical: compact ? 4 : 6,
        ),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(compact ? 8 : 12),
          border: Border.all(
            color: AppTheme.textSecondary.withOpacity(0.5),
            width: 1,
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.add,
              size: compact ? 14 : 16,
              color: AppTheme.textSecondary,
            ),
            const SizedBox(width: 4),
            Text(
              'Add Skill',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
                fontSize: compact ? 12 : 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
