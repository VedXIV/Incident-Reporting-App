import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../providers/incident_provider.dart';
import '../widgets/common_widgets.dart';
import 'incident_detail_screen.dart';
import 'incident_report_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<IncidentProvider>(
        builder: (_, provider, __) {
          final criticals = provider.filteredIncidents
              .where((i) => i.priority == 'Critical' && i.status != 'Resolved')
              .toList();

          return CustomScrollView(
            slivers: [
              // SliverAppBar
              SliverAppBar(
                expandedHeight: 140,
                pinned: true,
                backgroundColor: AppColors.primary,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF1A1F3A), Color(0xFF0F1220)],
                      ),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: AppColors.accent.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.shield_rounded,
                                    color: AppColors.accent,
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Admin Dashboard',
                                      style: TextStyle(
                                        color: AppColors.textPrimary,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text(
                                      'Emergency Response Center',
                                      style: TextStyle(
                                        color: AppColors.textMuted,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                // Online/offline toggle
                                Consumer<IncidentProvider>(
                                  builder: (_, p, __) => GestureDetector(
                                    onTap: () => p.setOnlineStatus(!p.isOnline),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: p.isOnline
                                            ? AppColors.low.withOpacity(0.15)
                                            : AppColors.high.withOpacity(0.15),
                                        borderRadius:
                                            BorderRadius.circular(20),
                                        border: Border.all(
                                          color: p.isOnline
                                              ? AppColors.low.withOpacity(0.5)
                                              : AppColors.high.withOpacity(0.5),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            p.isOnline
                                                ? Icons.wifi
                                                : Icons.wifi_off,
                                            size: 13,
                                            color: p.isOnline
                                                ? AppColors.low
                                                : AppColors.high,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            p.isOnline
                                                ? 'Online'
                                                : 'Offline',
                                            style: TextStyle(
                                              color: p.isOnline
                                                  ? AppColors.low
                                                  : AppColors.high,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Stats
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Unsynced alert
                      if (provider.unsyncedCount > 0) ...[
                        _UnsyncedBanner(count: provider.unsyncedCount),
                        const SizedBox(height: 12),
                      ],

                      // Main stats row
                      Row(
                        children: [
                          Expanded(
                            child: StatCard(
                              label: 'Total',
                              value: provider.totalIncidents.toString(),
                              color: AppColors.accent,
                              icon: Icons.inventory_2_outlined,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: StatCard(
                              label: 'Active',
                              value: provider.activeIncidents.toString(),
                              color: AppColors.inProgress,
                              icon: Icons.bolt_rounded,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: StatCard(
                              label: 'Resolved',
                              value: provider.resolvedIncidents.toString(),
                              color: AppColors.low,
                              icon: Icons.check_circle_outline,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Priority distribution
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: AppColors.cardGradient,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Priority Distribution',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _PriorityBar(
                              label: 'Critical',
                              count: provider.criticalIncidents,
                              total: provider.totalIncidents,
                              color: AppColors.critical,
                            ),
                            const SizedBox(height: 8),
                            _PriorityBar(
                              label: 'High',
                              count: provider.highIncidents,
                              total: provider.totalIncidents,
                              color: AppColors.high,
                            ),
                            const SizedBox(height: 8),
                            _PriorityBar(
                              label: 'Medium',
                              count: provider.mediumIncidents,
                              total: provider.totalIncidents,
                              color: AppColors.medium,
                            ),
                            const SizedBox(height: 8),
                            _PriorityBar(
                              label: 'Low',
                              count: provider.lowIncidents,
                              total: provider.totalIncidents,
                              color: AppColors.low,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Critical alerts
              if (criticals.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: SectionHeader(
                    title: '🚨 Critical Incidents',
                    action: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.critical.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${criticals.length}',
                        style: const TextStyle(
                          color: AppColors.critical,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (ctx, i) => IncidentCard(
                      incident: criticals[i],
                      onTap: () => Navigator.push(
                        ctx,
                        MaterialPageRoute(
                          builder: (_) => IncidentDetailScreen(
                              incidentId: criticals[i].id),
                        ),
                      ),
                    ),
                    childCount: criticals.length,
                  ),
                ),
              ],

              // All incidents
              SliverToBoxAdapter(
                child: SectionHeader(
                  title: 'All Incidents',
                  action: GestureDetector(
                    onTap: () {},
                    child: const Text(
                      'View All',
                      style: TextStyle(
                        color: AppColors.accent,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),

              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) {
                    final incidents = provider.filteredIncidents;
                    if (incidents.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(32),
                        child: Center(
                          child: Text(
                            'No incidents reported yet',
                            style: TextStyle(color: AppColors.textMuted),
                          ),
                        ),
                      );
                    }
                    final incident = incidents[i];
                    return IncidentCard(
                      incident: incident,
                      onTap: () => Navigator.push(
                        ctx,
                        MaterialPageRoute(
                          builder: (_) =>
                              IncidentDetailScreen(incidentId: incident.id),
                        ),
                      ),
                    );
                  },
                  childCount: provider.filteredIncidents.isEmpty
                      ? 1
                      : provider.filteredIncidents.length,
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: null,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const IncidentReportScreen()),
        ),
        backgroundColor: AppColors.accent,
        icon: const Icon(Icons.add_alert, color: Colors.white),
        label: const Text(
          'New Report',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class _PriorityBar extends StatelessWidget {
  final String label;
  final int count;
  final int total;
  final Color color;

  const _PriorityBar({
    required this.label,
    required this.count,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final pct = total == 0 ? 0.0 : count / total;
    return Row(
      children: [
        SizedBox(
          width: 60,
          child: Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct,
              backgroundColor: color.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 24,
          child: Text(
            '$count',
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _UnsyncedBanner extends StatelessWidget {
  final int count;

  const _UnsyncedBanner({required this.count});

  @override
  Widget build(BuildContext context) {
    return Consumer<IncidentProvider>(
      builder: (_, provider, __) => GestureDetector(
        onTap: () => provider.setOnlineStatus(true),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.medium.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.medium.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              const Icon(Icons.cloud_off, color: AppColors.medium, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '$count incident(s) pending sync — Tap to sync now',
                  style: const TextStyle(
                    color: AppColors.medium,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Icon(Icons.sync, color: AppColors.medium, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
