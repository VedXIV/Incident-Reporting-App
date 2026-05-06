import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../providers/incident_provider.dart';
import '../widgets/common_widgets.dart';
import 'incident_detail_screen.dart';
import 'incident_report_screen.dart';
import 'search_filter_screen.dart';

class IncidentListScreen extends StatefulWidget {
  const IncidentListScreen({super.key});

  @override
  State<IncidentListScreen> createState() => _IncidentListScreenState();
}

class _IncidentListScreenState extends State<IncidentListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          'Incident Reports',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.textPrimary),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const SearchFilterScreen()),
            ),
          ),
          Consumer<IncidentProvider>(
            builder: (_, p, __) {
              final hasFilters = p.filterStatus != 'All' ||
                  p.filterPriority != 'All' ||
                  p.filterCategory != 'All';
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.filter_list,
                        color: AppColors.textPrimary),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const SearchFilterScreen()),
                    ),
                  ),
                  if (hasFilters)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.accent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.accent,
          labelColor: AppColors.accent,
          unselectedLabelColor: AppColors.textMuted,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Active'),
            Tab(text: 'Resolved'),
          ],
        ),
      ),
      body: Consumer<IncidentProvider>(
        builder: (_, provider, __) {
          final all = provider.filteredIncidents;
          final active = all.where((i) => i.status != 'Resolved').toList();
          final resolved =
              all.where((i) => i.status == 'Resolved').toList();

          return TabBarView(
            controller: _tabController,
            children: [
              _IncidentListView(incidents: all),
              _IncidentListView(incidents: active),
              _IncidentListView(incidents: resolved),
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
          'Report',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class _IncidentListView extends StatelessWidget {
  final List incidents;

  const _IncidentListView({required this.incidents});

  @override
  Widget build(BuildContext context) {
    if (incidents.isEmpty) {
      return _EmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 100),
      itemCount: incidents.length,
      itemBuilder: (ctx, i) {
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
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(
              Icons.inbox_rounded,
              color: AppColors.textMuted,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No incidents found',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'No incidents match your current filters',
            style: TextStyle(color: AppColors.textMuted, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
