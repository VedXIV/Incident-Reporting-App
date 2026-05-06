# Smart Emergency Response & Incident Reporting App 

A Flutter-based mobile application that allows users to quickly report emergencies, track incident status, and helps administrators manage and prioritize emergency cases efficiently.

## Features

### User Module
- Report incidents with:
  - Title
  - Description
  - Category
  - Priority
  - Location
- Generate unique Incident ID
- Track incident status
- Offline incident reporting
- Search and filter incidents

### Admin Module
- View all reported incidents
- Update incident status
- Prioritize critical cases
- Assign responders

### Dashboard
- Total incidents count
- Active vs Resolved cases
- Priority-wise statistics
- Urgency indicators

## Tech Stack
- Flutter
- Dart
- Provider / Riverpod
- Hive / SQLite
- Firebase (Optional)

## Project Structure

```bash
lib/
│
├── models/
├── screens/
├── providers/
├── services/
├── widgets/
└── main.dart
