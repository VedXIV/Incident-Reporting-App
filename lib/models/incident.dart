import 'dart:convert';

import 'package:hive/hive.dart';

part 'incident.g.dart';

@HiveType(typeId: 0)
class Incident {
  @HiveField(0)
  String id;
  @HiveField(1)
  String title;
  @HiveField(2)
  String description;
  @HiveField(3)
  String category;
  @HiveField(4)
  String priority;
  @HiveField(5)
  String location;
  @HiveField(6)
  String status;
  @HiveField(7)
  DateTime timeReported;
  @HiveField(8)
  String? assignedResponder;
  @HiveField(9)
  bool isSynced;

  Incident({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    required this.location,
    required this.status,
    required this.timeReported,
    this.assignedResponder,
    this.isSynced = true,
  });

  int get priorityOrder {
    switch (priority.toLowerCase()) {
      case 'critical':
        return 0;
      case 'high':
        return 1;
      case 'medium':
        return 2;
      case 'low':
        return 3;
      default:
        return 4;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'priority': priority,
      'location': location,
      'status': status,
      'timeReported': timeReported.toIso8601String(),
      'assignedResponder': assignedResponder,
      'isSynced': isSynced,
    };
  }

  String toJson() => jsonEncode(toMap());

  factory Incident.fromMap(Map<String, dynamic> map) {
    return Incident(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      category: map['category'],
      priority: map['priority'],
      location: map['location'],
      status: map['status'],
      timeReported: DateTime.parse(map['timeReported']),
      assignedResponder: map['assignedResponder'],
      isSynced: map['isSynced'] ?? true,
    );
  }

  factory Incident.fromJson(String source) =>
      Incident.fromMap(jsonDecode(source));
}