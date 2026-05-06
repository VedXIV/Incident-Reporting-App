import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../models/incident.dart';

class PriorityBadge extends StatelessWidget {
  final String priority;
  final bool large;

  const PriorityBadge({super.key, required this.priority, this.large = false});

  @override
  Widget build(BuildContext context) {
    final color = _color();
    final bg = _bgColor();
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: large ? 12 : 8,
        vertical: large ? 6 : 4,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (priority == 'Critical')
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Icon(Icons.warning_rounded, size: large ? 14 : 10, color: color),
            ),
          Text(
            priority.toUpperCase(),
            style: TextStyle(
              color: color,
              fontSize: large ? 12 : 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Color _color() {
    switch (priority) {
      case 'Critical':
        return AppColors.critical;
      case 'High':
        return AppColors.high;
      case 'Medium':
        return AppColors.medium;
      case 'Low':
        return AppColors.low;
      default:
        return AppColors.textSecondary;
    }
  }

  Color _bgColor() {
    switch (priority) {
      case 'Critical':
        return AppColors.criticalBg;
      case 'High':
        return AppColors.highBg;
      case 'Medium':
        return AppColors.mediumBg;
      case 'Low':
        return AppColors.lowBg;
      default:
        return AppColors.surfaceLight;
    }
  }
}

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final color = _color();
    final bg = _bgColor();
    final icon = _icon();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 4),
          Text(
            status,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color _color() {
    switch (status) {
      case 'Reported':
        return AppColors.reported;
      case 'In Progress':
        return AppColors.inProgress;
      case 'Resolved':
        return AppColors.resolved;
      default:
        return AppColors.textSecondary;
    }
  }

  Color _bgColor() {
    switch (status) {
      case 'Reported':
        return AppColors.reportedBg;
      case 'In Progress':
        return AppColors.inProgressBg;
      case 'Resolved':
        return AppColors.resolvedBg;
      default:
        return AppColors.surfaceLight;
    }
  }

  IconData _icon() {
    switch (status) {
      case 'Reported':
        return Icons.radio_button_checked;
      case 'In Progress':
        return Icons.sync;
      case 'Resolved':
        return Icons.check_circle;
      default:
        return Icons.help_outline;
    }
  }
}

class CategoryIcon extends StatelessWidget {
  final String category;
  final double size;

  const CategoryIcon({super.key, required this.category, this.size = 20});

  @override
  Widget build(BuildContext context) {
    return Icon(_icon(), color: _color(), size: size);
  }

  IconData _icon() {
    switch (category) {
      case 'Medical':
        return Icons.local_hospital;
      case 'Fire':
        return Icons.local_fire_department;
      case 'Security':
        return Icons.security;
      case 'Natural Disaster':
        return Icons.storm;
      case 'Infrastructure':
        return Icons.construction;
      default:
        return Icons.report_problem;
    }
  }

  Color _color() {
    switch (category) {
      case 'Medical':
        return AppColors.medical;
      case 'Fire':
        return AppColors.fire;
      case 'Security':
        return AppColors.security;
      case 'Natural Disaster':
        return AppColors.natural;
      case 'Infrastructure':
        return AppColors.infrastructure;
      default:
        return AppColors.other;
    }
  }
}

class IncidentCard extends StatelessWidget {
  final Incident incident;
  final VoidCallback? onTap;
  final bool showAnimation;

  const IncidentCard({
    super.key,
    required this.incident,
    this.onTap,
    this.showAnimation = true,
  });

  @override
  Widget build(BuildContext context) {
    final isCritical = incident.priority == 'Critical';

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1E2340), Color(0xFF1A2035)],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isCritical
                ? AppColors.critical.withOpacity(0.6)
                : AppColors.border,
            width: isCritical ? 1.5 : 1,
          ),
          boxShadow: isCritical
              ? [
                  BoxShadow(
                    color: AppColors.critical.withOpacity(0.15),
                    blurRadius: 12,
                    spreadRadius: 2,
                  )
                ]
              : null,
        ),
        child: Column(
          children: [
            if (isCritical)
              Container(
                height: 3,
                decoration: const BoxDecoration(
                  color: AppColors.critical,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(16)),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _categoryBgColor(),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: CategoryIcon(
                              category: incident.category, size: 20),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              incident.title,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              incident.id,
                              style: const TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 11,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ],
                        ),
                      ),
                      PriorityBadge(priority: incident.priority),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    incident.description,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 13, color: AppColors.textMuted),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          incident.location,
                          style: const TextStyle(
                              color: AppColors.textMuted, fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (!incident.isSynced) ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.cloud_off,
                            size: 13, color: AppColors.medium),
                      ],
                      const Spacer(),
                      StatusBadge(status: incident.status),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _categoryBgColor() {
    switch (incident.category) {
      case 'Medical':
        return AppColors.medical.withOpacity(0.15);
      case 'Fire':
        return AppColors.fire.withOpacity(0.15);
      case 'Security':
        return AppColors.security.withOpacity(0.15);
      case 'Natural Disaster':
        return AppColors.natural.withOpacity(0.15);
      case 'Infrastructure':
        return AppColors.infrastructure.withOpacity(0.15);
      default:
        return AppColors.other.withOpacity(0.15);
    }
  }
}

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;
  final double? width;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E2340), Color(0xFF1A2035)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 26,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final Widget? action;

  const SectionHeader({super.key, required this.title, this.action});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          if (action != null) action!,
        ],
      ),
    );
  }
}

class AppFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color? color;

  const AppFilterChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.accent;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? c.withOpacity(0.15) : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? c : AppColors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? c : AppColors.textSecondary,
            fontSize: 13,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
