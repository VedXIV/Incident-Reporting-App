import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../core/theme.dart';
import '../providers/incident_provider.dart';
import '../widgets/common_widgets.dart';

class IncidentDetailScreen extends StatefulWidget {
  final String incidentId;

  const IncidentDetailScreen({super.key, required this.incidentId});

  @override
  State<IncidentDetailScreen> createState() => _IncidentDetailScreenState();
}

class _IncidentDetailScreenState extends State<IncidentDetailScreen> {
  bool _isAdmin = false; // Toggle to simulate admin view

  @override
  Widget build(BuildContext context) {
    return Consumer<IncidentProvider>(
      builder: (_, provider, __) {
        final incident = provider.getIncidentById(widget.incidentId);
        if (incident == null) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(backgroundColor: AppColors.primary),
            body: const Center(
              child: Text('Incident not found',
                  style: TextStyle(color: AppColors.textSecondary)),
            ),
          );
        }

        final isCritical = incident.priority == 'Critical';

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.primary,
            title: Text(
              incident.id,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 14,
                fontFamily: 'monospace',
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios,
                  color: AppColors.textPrimary),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: GestureDetector(
                  onTap: () => setState(() => _isAdmin = !_isAdmin),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _isAdmin
                          ? AppColors.accent.withOpacity(0.2)
                          : AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color:
                            _isAdmin ? AppColors.accent : AppColors.border,
                      ),
                    ),
                    child: Text(
                      _isAdmin ? 'Admin' : 'User',
                      style: TextStyle(
                        color: _isAdmin
                            ? AppColors.accent
                            : AppColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Critical alert banner
                if (isCritical) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.critical.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppColors.critical.withOpacity(0.5)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.warning_rounded,
                            color: AppColors.critical, size: 20),
                        const SizedBox(width: 8),
                        const Text(
                          'CRITICAL EMERGENCY — Immediate response required',
                          style: TextStyle(
                            color: AppColors.critical,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Main info card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: AppColors.cardGradient,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: isCritical
                            ? AppColors.critical.withOpacity(0.4)
                            : AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Center(
                              child: CategoryIcon(
                                  category: incident.category, size: 24),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  incident.title,
                                  style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  incident.category,
                                  style: const TextStyle(
                                    color: AppColors.textMuted,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          PriorityBadge(
                              priority: incident.priority, large: true),
                          const SizedBox(width: 8),
                          StatusBadge(status: incident.status),
                          const Spacer(),
                          if (!incident.isSynced)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.medium.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color:
                                        AppColors.medium.withOpacity(0.4)),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.cloud_off,
                                      size: 12, color: AppColors.medium),
                                  SizedBox(width: 4),
                                  Text('Offline',
                                      style: TextStyle(
                                          color: AppColors.medium,
                                          fontSize: 11)),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Details
                _DetailSection(
                  title: 'Description',
                  child: Text(
                    incident.description,
                    style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                        height: 1.5),
                  ),
                ),
                const SizedBox(height: 12),

                _DetailSection(
                  title: 'Incident Details',
                  child: Column(
                    children: [
                      _DetailRow(
                        icon: Icons.location_on,
                        label: 'Location',
                        value: incident.location,
                      ),
                      const Divider(color: AppColors.border, height: 16),
                      _DetailRow(
                        icon: Icons.access_time,
                        label: 'Reported At',
                        value: DateFormat('dd MMM yyyy, HH:mm')
                            .format(incident.timeReported),
                      ),
                      const Divider(color: AppColors.border, height: 16),
                      _DetailRow(
                        icon: Icons.person_outline,
                        label: 'Assigned To',
                        value: incident.assignedResponder ??
                            'Not yet assigned',
                        valueColor: incident.assignedResponder != null
                            ? AppColors.textPrimary
                            : AppColors.textMuted,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Admin Controls
                if (_isAdmin) ...[
                  _AdminControlsSection(
                    incident: incident,
                    provider: provider,
                  ),
                ] else ...[
                  // User tracking section
                  _DetailSection(
                    title: 'Response Timeline',
                    child: _Timeline(status: incident.status),
                  ),
                ],
                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DetailSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _DetailSection({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textMuted),
        const SizedBox(width: 8),
        Text(
          '$label:',
          style: const TextStyle(
              color: AppColors.textMuted, fontSize: 13),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: valueColor ?? AppColors.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}

class _Timeline extends StatelessWidget {
  final String status;

  const _Timeline({required this.status});

  @override
  Widget build(BuildContext context) {
    final steps = ['Reported', 'In Progress', 'Resolved'];
    final currentIndex = steps.indexOf(status);

    return Column(
      children: steps.asMap().entries.map((e) {
        final idx = e.key;
        final step = e.value;
        final isDone = idx <= currentIndex;
        final isCurrent = idx == currentIndex;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: isDone
                        ? AppColors.accent.withOpacity(0.2)
                        : AppColors.surfaceLight,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDone ? AppColors.accent : AppColors.border,
                      width: isCurrent ? 2 : 1,
                    ),
                  ),
                  child: Icon(
                    isDone ? Icons.check : Icons.radio_button_unchecked,
                    size: 14,
                    color: isDone ? AppColors.accent : AppColors.textMuted,
                  ),
                ),
                if (idx < steps.length - 1)
                  Container(
                    width: 2,
                    height: 28,
                    color: isDone && idx < currentIndex
                        ? AppColors.accent.withOpacity(0.3)
                        : AppColors.border,
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step,
                    style: TextStyle(
                      color: isDone
                          ? AppColors.textPrimary
                          : AppColors.textMuted,
                      fontWeight: isCurrent
                          ? FontWeight.w700
                          : FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                  if (isCurrent)
                    const Text(
                      'Current status',
                      style: TextStyle(
                          color: AppColors.accent,
                          fontSize: 11),
                    ),
                ],
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}

class _AdminControlsSection extends StatefulWidget {
  final dynamic incident;
  final IncidentProvider provider;

  const _AdminControlsSection(
      {required this.incident, required this.provider});

  @override
  State<_AdminControlsSection> createState() =>
      _AdminControlsSectionState();
}

class _AdminControlsSectionState extends State<_AdminControlsSection> {
  final _responderController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _responderController.text =
        widget.incident.assignedResponder ?? '';
  }

  @override
  void dispose() {
    _responderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.accent.withOpacity(0.05),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.accent.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.admin_panel_settings,
                      color: AppColors.accent, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Admin Controls',
                    style: TextStyle(
                      color: AppColors.accent,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Update Status
              const Text('Update Status',
                  style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Row(
                children: ['Reported', 'In Progress', 'Resolved']
                    .map((s) => Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 3),
                            child: GestureDetector(
                              onTap: () => widget.provider
                                  .updateIncidentStatus(
                                      widget.incident.id, s),
                              child: AnimatedContainer(
                                duration:
                                    const Duration(milliseconds: 150),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10),
                                decoration: BoxDecoration(
                                  color: widget.incident.status == s
                                      ? _statusColor(s).withOpacity(0.15)
                                      : AppColors.surfaceLight,
                                  borderRadius:
                                      BorderRadius.circular(10),
                                  border: Border.all(
                                    color: widget.incident.status == s
                                        ? _statusColor(s)
                                        : AppColors.border,
                                  ),
                                ),
                                child: Text(
                                  s,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: widget.incident.status == s
                                        ? _statusColor(s)
                                        : AppColors.textMuted,
                                    fontSize: 11,
                                    fontWeight:
                                        widget.incident.status == s
                                            ? FontWeight.w700
                                            : FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 16),

              // Update Priority
              const Text('Update Priority',
                  style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Row(
                children: ['Low', 'Medium', 'High', 'Critical']
                    .map((p) => Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 3),
                            child: GestureDetector(
                              onTap: () => widget.provider
                                  .updateIncidentPriority(
                                      widget.incident.id, p),
                              child: AnimatedContainer(
                                duration:
                                    const Duration(milliseconds: 150),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10),
                                decoration: BoxDecoration(
                                  color: widget.incident.priority == p
                                      ? _priorityColor(p).withOpacity(0.15)
                                      : AppColors.surfaceLight,
                                  borderRadius:
                                      BorderRadius.circular(10),
                                  border: Border.all(
                                    color: widget.incident.priority == p
                                        ? _priorityColor(p)
                                        : AppColors.border,
                                  ),
                                ),
                                child: Text(
                                  p,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: widget.incident.priority == p
                                        ? _priorityColor(p)
                                        : AppColors.textMuted,
                                    fontSize: 10,
                                    fontWeight:
                                        widget.incident.priority == p
                                            ? FontWeight.w700
                                            : FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 16),

              // Assign Responder
              const Text('Assign Responder',
                  style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _responderController,
                      style: const TextStyle(
                          color: AppColors.textPrimary, fontSize: 13),
                      decoration: const InputDecoration(
                        hintText: 'Responder name or ID',
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        prefixIcon: Icon(Icons.person_add,
                            color: AppColors.textMuted, size: 18),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      final name = _responderController.text.trim();
                      if (name.isNotEmpty) {
                        widget.provider.assignResponder(
                            widget.incident.id, name);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Assigned to $name'),
                            backgroundColor: AppColors.surface,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                    child: const Text('Assign'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _statusColor(String s) {
    switch (s) {
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

  Color _priorityColor(String p) {
    switch (p) {
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
}
