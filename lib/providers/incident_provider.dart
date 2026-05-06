import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/incident.dart';

class IncidentProvider extends ChangeNotifier {
  static const String _storageKey = 'incidents_data';
  final _uuid = const Uuid();

  List<Incident> _incidents = [];
  bool _isLoading = false;
  String _searchQuery = '';
  String _filterStatus = 'All';
  String _filterPriority = 'All';
  String _filterCategory = 'All';
  bool _isOnline = true;

  List<Incident> get incidents => _incidents;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  String get filterStatus => _filterStatus;
  String get filterPriority => _filterPriority;
  String get filterCategory => _filterCategory;
  bool get isOnline => _isOnline;

  // Filtered & sorted list for display
  List<Incident> get filteredIncidents {
    List<Incident> list = List.from(_incidents);

    // Search
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list
          .where((i) =>
              i.id.toLowerCase().contains(q) ||
              i.title.toLowerCase().contains(q) ||
              i.description.toLowerCase().contains(q) ||
              i.category.toLowerCase().contains(q))
          .toList();
    }

    // Filters
    if (_filterStatus != 'All') {
      list = list.where((i) => i.status == _filterStatus).toList();
    }
    if (_filterPriority != 'All') {
      list = list.where((i) => i.priority == _filterPriority).toList();
    }
    if (_filterCategory != 'All') {
      list = list.where((i) => i.category == _filterCategory).toList();
    }

    // Sort: priority first, then time (newest first)
    list.sort((a, b) {
      final pCmp = a.priorityOrder.compareTo(b.priorityOrder);
      if (pCmp != 0) return pCmp;
      return b.timeReported.compareTo(a.timeReported);
    });

    return list;
  }

  // Dashboard stats
  int get totalIncidents => _incidents.length;
  int get activeIncidents =>
      _incidents.where((i) => i.status != 'Resolved').length;
  int get resolvedIncidents =>
      _incidents.where((i) => i.status == 'Resolved').length;
  int get criticalIncidents =>
      _incidents.where((i) => i.priority == 'Critical').length;
  int get highIncidents =>
      _incidents.where((i) => i.priority == 'High').length;
  int get mediumIncidents =>
      _incidents.where((i) => i.priority == 'Medium').length;
  int get lowIncidents =>
      _incidents.where((i) => i.priority == 'Low').length;
  int get reportedCount =>
      _incidents.where((i) => i.status == 'Reported').length;
  int get inProgressCount =>
      _incidents.where((i) => i.status == 'In Progress').length;
  int get unsyncedCount =>
      _incidents.where((i) => !i.isSynced).length;

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    await _loadFromStorage();
    // Seed sample data if empty
    if (_incidents.isEmpty) {
      await _seedSampleData();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _loadFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = prefs.getStringList(_storageKey) ?? [];
      _incidents = jsonList
          .map((j) => Incident.fromMap(jsonDecode(j)))
          .toList();
    } catch (_) {
      _incidents = [];
    }
  }

  Future<void> _saveToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList =
        _incidents.map((i) => jsonEncode(i.toMap())).toList();
    await prefs.setStringList(_storageKey, jsonList);
  }

  Future<void> _seedSampleData() async {
    final samples = [
      Incident(
        id: 'INC-${_uuid.v4().substring(0, 8).toUpperCase()}',
        title: 'Medical Emergency - Building A',
        description:
            'Student collapsed on the second floor of Building A near the staircase. Appears to be unconscious. Needs immediate medical attention.',
        category: 'Medical',
        priority: 'Critical',
        location: 'Building A, Floor 2, Near Staircase',
        status: 'In Progress',
        timeReported: DateTime.now().subtract(const Duration(minutes: 12)),
        assignedResponder: 'Dr. Sarah Johnson',
        isSynced: true,
      ),
      Incident(
        id: 'INC-${_uuid.v4().substring(0, 8).toUpperCase()}',
        title: 'Fire Alarm Triggered - Lab 3',
        description:
            'Fire alarm has been triggered in Lab 3. Possible electrical short circuit. Students evacuated. Fire brigade notified.',
        category: 'Fire',
        priority: 'High',
        location: 'Science Block, Lab 3, Ground Floor',
        status: 'Reported',
        timeReported: DateTime.now().subtract(const Duration(minutes: 35)),
        isSynced: true,
      ),
      Incident(
        id: 'INC-${_uuid.v4().substring(0, 8).toUpperCase()}',
        title: 'Unauthorized Access - Server Room',
        description:
            'Security breach detected in the server room. Access card was used outside working hours. Investigation required.',
        category: 'Security',
        priority: 'High',
        location: 'IT Block, Server Room, 1st Floor',
        status: 'In Progress',
        timeReported: DateTime.now().subtract(const Duration(hours: 2)),
        assignedResponder: 'Rajesh Kumar (Security)',
        isSynced: true,
      ),
      Incident(
        id: 'INC-${_uuid.v4().substring(0, 8).toUpperCase()}',
        title: 'Water Pipe Burst - Cafeteria',
        description:
            'Water pipe burst in the cafeteria kitchen. Large amount of water on the floor. Slip hazard for students and staff.',
        category: 'Infrastructure',
        priority: 'Medium',
        location: 'Main Cafeteria, Kitchen Area',
        status: 'Reported',
        timeReported: DateTime.now().subtract(const Duration(hours: 4)),
        isSynced: false,
      ),
      Incident(
        id: 'INC-${_uuid.v4().substring(0, 8).toUpperCase()}',
        title: 'Minor Accident - Parking Lot',
        description:
            'Two vehicles involved in a minor collision in Parking Lot B. No injuries reported. Documentation needed for insurance.',
        category: 'Security',
        priority: 'Low',
        location: 'Parking Lot B, Section 3',
        status: 'Resolved',
        timeReported: DateTime.now().subtract(const Duration(hours: 6)),
        assignedResponder: 'Campus Security Team',
        isSynced: true,
      ),
    ];

    _incidents = samples;
    await _saveToStorage();
  }

  Future<Incident> addIncident({
    required String title,
    required String description,
    required String category,
    required String priority,
    required String location,
  }) async {
    final incident = Incident(
      id: 'INC-${_uuid.v4().substring(0, 8).toUpperCase()}',
      title: title,
      description: description,
      category: category,
      priority: priority,
      location: location,
      status: 'Reported',
      timeReported: DateTime.now(),
      isSynced: _isOnline,
    );
    _incidents.insert(0, incident);
    await _saveToStorage();
    notifyListeners();
    return incident;
  }

  Future<void> updateIncidentStatus(String id, String status) async {
    final idx = _incidents.indexWhere((i) => i.id == id);
    if (idx != -1) {
      _incidents[idx].status = status;
      await _saveToStorage();
      notifyListeners();
    }
  }

  Future<void> updateIncidentPriority(String id, String priority) async {
    final idx = _incidents.indexWhere((i) => i.id == id);
    if (idx != -1) {
      _incidents[idx].priority = priority;
      await _saveToStorage();
      notifyListeners();
    }
  }

  Future<void> assignResponder(String id, String responder) async {
    final idx = _incidents.indexWhere((i) => i.id == id);
    if (idx != -1) {
      _incidents[idx].assignedResponder = responder;
      await _saveToStorage();
      notifyListeners();
    }
  }

  Future<void> deleteIncident(String id) async {
    _incidents.removeWhere((i) => i.id == id);
    await _saveToStorage();
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setFilterStatus(String status) {
    _filterStatus = status;
    notifyListeners();
  }

  void setFilterPriority(String priority) {
    _filterPriority = priority;
    notifyListeners();
  }

  void setFilterCategory(String category) {
    _filterCategory = category;
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _filterStatus = 'All';
    _filterPriority = 'All';
    _filterCategory = 'All';
    notifyListeners();
  }

  void setOnlineStatus(bool online) {
    _isOnline = online;
    if (online) _syncUnsynced();
    notifyListeners();
  }

  Future<void> _syncUnsynced() async {
    int synced = 0;
    for (final incident in _incidents) {
      if (!incident.isSynced) {
        incident.isSynced = true;
        synced++;
      }
    }
    if (synced > 0) {
      await _saveToStorage();
      notifyListeners();
    }
  }

  Incident? getIncidentById(String id) {
    try {
      return _incidents.firstWhere((i) => i.id == id);
    } catch (_) {
      return null;
    }
  }

  Map<String, int> getCategoryDistribution() {
    final map = <String, int>{};
    for (final i in _incidents) {
      map[i.category] = (map[i.category] ?? 0) + 1;
    }
    return map;
  }
}
