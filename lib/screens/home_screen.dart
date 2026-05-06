import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../providers/incident_provider.dart';
import '../widgets/common_widgets.dart';
import 'incident_detail_screen.dart';
import 'incident_report_screen.dart';
import 'incident_list_screen.dart';
import 'admin_dashboard_screen.dart';
import 'search_filter_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const _DashboardTab(),
    const IncidentListScreen(),
    const AdminDashboardScreen(),
    const SearchFilterScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 8,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Badge(
              label: Text(
                '${context.watch<IncidentProvider>().criticalIncidents}',
              ),
              isLabelVisible:
                  context.watch<IncidentProvider>().criticalIncidents > 0,
              child: const Icon(Icons.list_alt),
            ),
            label: 'Incidents',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.admin_panel_settings),
            label: 'Admin',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
        ],
      ),
    );
  }
}

// ─── Dashboard Tab ────────────────────────────────────────────────────────────

class _DashboardTab extends StatelessWidget {
  const _DashboardTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RespondX'),
        actions: [
          Consumer<IncidentProvider>(
            builder: (_, p, __) => Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Chip(
                avatar: Icon(
                  Icons.circle,
                  size: 10,
                  color: p.isOnline ? Colors.green : Colors.orange,
                ),
                label: Text(
                  p.isOnline ? 'Online' : 'Offline',
                  style: const TextStyle(fontSize: 12),
                ),
                padding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
      body: Consumer<IncidentProvider>(
        builder: (_, provider, __) {
          final recentCriticals = provider.filteredIncidents
              .where((i) => i.priority == 'Critical' && i.status != 'Resolved')
              .take(3)
              .toList();
          final recentAll = provider.filteredIncidents.take(5).toList();

          return ListView(
            children: [
              // Report Button
              Padding(
                padding: const EdgeInsets.all(12),
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const IncidentReportScreen()),
                  ),
                  icon: const Icon(Icons.add_alert),
                  label: const Text('Report Emergency'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    backgroundColor: AppColors.accent,
                  ),
                ),
              ),

              // Stats Row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    _StatTile(
                      label: 'Total',
                      value: provider.totalIncidents.toString(),
                      color: AppColors.primary,
                    ),
                    _StatTile(
                      label: 'Active',
                      value: provider.activeIncidents.toString(),
                      color: Colors.orange,
                    ),
                    _StatTile(
                      label: 'Critical',
                      value: provider.criticalIncidents.toString(),
                      color: AppColors.critical,
                    ),
                    _StatTile(
                      label: 'Resolved',
                      value: provider.resolvedIncidents.toString(),
                      color: Colors.green,
                    ),
                  ],
                ),
              ),

              const Divider(height: 24),

              // Critical Alerts
              if (recentCriticals.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: Text(
                    '🚨 Critical Alerts',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: AppColors.critical),
                  ),
                ),
                ...recentCriticals.map((incident) => IncidentCard(
                      incident: incident,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              IncidentDetailScreen(incidentId: incident.id),
                        ),
                      ),
                    )),
                const Divider(height: 24),
              ],

              // Recent Incidents
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: Text(
                  'Recent Incidents',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
              if (recentAll.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(
                    child: Text(
                      'No incidents reported yet.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                )
              else
                ...recentAll.map((incident) => IncidentCard(
                      incident: incident,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              IncidentDetailScreen(incidentId: incident.id),
                        ),
                      ),
                    )),

              const SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatTile({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          child: Column(
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
