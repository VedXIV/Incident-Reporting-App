import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../providers/incident_provider.dart';
import '../widgets/common_widgets.dart';
import 'incident_detail_screen.dart';

class SearchFilterScreen extends StatefulWidget {
  const SearchFilterScreen({super.key});

  @override
  State<SearchFilterScreen> createState() => _SearchFilterScreenState();
}

class _SearchFilterScreenState extends State<SearchFilterScreen> {
  final _searchController = TextEditingController();

  final List<String> _statuses = ['All', 'Reported', 'In Progress', 'Resolved'];
  final List<String> _priorities = [
    'All',
    'Critical',
    'High',
    'Medium',
    'Low'
  ];
  final List<String> _categories = [
    'All',
    'Medical',
    'Fire',
    'Security',
    'Natural Disaster',
    'Infrastructure',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    final provider = context.read<IncidentProvider>();
    _searchController.text = provider.searchQuery;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          'Search & Filter',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Consumer<IncidentProvider>(
            builder: (_, p, __) {
              final hasFilters = p.filterStatus != 'All' ||
                  p.filterPriority != 'All' ||
                  p.filterCategory != 'All' ||
                  p.searchQuery.isNotEmpty;
              return hasFilters
                  ? TextButton(
                      onPressed: () {
                        p.clearFilters();
                        _searchController.clear();
                      },
                      child: const Text(
                        'Clear All',
                        style:
                            TextStyle(color: AppColors.accent, fontSize: 13),
                      ),
                    )
                  : const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Consumer<IncidentProvider>(
        builder: (_, provider, __) {
          final results = provider.filteredIncidents;

          return Column(
            children: [
              // Search bar
              Container(
                color: AppColors.primary,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: TextFormField(
                  controller: _searchController,
                  style: const TextStyle(color: AppColors.textPrimary),
                  onChanged: provider.setSearchQuery,
                  decoration: InputDecoration(
                    hintText: 'Search by ID, title, keyword...',
                    prefixIcon: const Icon(Icons.search,
                        color: AppColors.textMuted),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close,
                                color: AppColors.textMuted, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              provider.setSearchQuery('');
                            },
                          )
                        : null,
                    fillColor: AppColors.surfaceLight,
                  ),
                ),
              ),

              // Filters
              Container(
                color: AppColors.surface,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FilterSection(
                      title: 'Status',
                      options: _statuses,
                      selected: provider.filterStatus,
                      onSelect: provider.setFilterStatus,
                      colorOf: _statusColor,
                    ),
                    const SizedBox(height: 12),
                    _FilterSection(
                      title: 'Priority',
                      options: _priorities,
                      selected: provider.filterPriority,
                      onSelect: provider.setFilterPriority,
                      colorOf: _priorityColor,
                    ),
                    const SizedBox(height: 12),
                    _FilterSection(
                      title: 'Category',
                      options: _categories,
                      selected: provider.filterCategory,
                      onSelect: provider.setFilterCategory,
                    ),
                  ],
                ),
              ),

              // Results count
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Text(
                      '${results.length} result${results.length == 1 ? '' : 's'}',
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // Results
              Expanded(
                child: results.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off,
                                color: AppColors.textMuted, size: 48),
                            SizedBox(height: 12),
                            Text(
                              'No results found',
                              style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Try adjusting your search or filters',
                              style: TextStyle(
                                  color: AppColors.textMuted, fontSize: 13),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding:
                            const EdgeInsets.only(top: 4, bottom: 24),
                        itemCount: results.length,
                        itemBuilder: (ctx, i) {
                          final incident = results[i];
                          return IncidentCard(
                            incident: incident,
                            onTap: () => Navigator.push(
                              ctx,
                              MaterialPageRoute(
                                builder: (_) => IncidentDetailScreen(
                                    incidentId: incident.id),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
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
        return AppColors.accent;
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
        return AppColors.accent;
    }
  }
}

class _FilterSection extends StatelessWidget {
  final String title;
  final List<String> options;
  final String selected;
  final ValueChanged<String> onSelect;
  final Color Function(String)? colorOf;

  const _FilterSection({
    required this.title,
    required this.options,
    required this.selected,
    required this.onSelect,
    this.colorOf,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: options.map<Widget>((opt) {
            final c = colorOf != null && opt != 'All'
                ? colorOf!(opt)
                : AppColors.accent;
            return AppFilterChip(
              label: opt,
              selected: selected == opt,
              onTap: () => onSelect(opt),
              color: c,
            );
          }).toList(),
        ),
      ],
    );
  }
}
